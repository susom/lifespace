//
//  OnboardingViewController.swift
//  LifeSpace
//
//  Copyright © 2022 LifeSpace. All rights reserved.
//
import SwiftUI
import UIKit
import ResearchKit
import CardinalKit
import Firebase

/// Onboarding workflow for new users
struct OnboardingViewController: UIViewControllerRepresentable {
    func makeCoordinator() -> OnboardingViewCoordinator {
        OnboardingViewCoordinator()
    }

    typealias UIViewControllerType = ORKTaskViewController

    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let config = CKPropertyReader(file: "CKConfiguration")

        /// Ask user to review, then sign consent form
        let consentDocument = LifeSpaceConsent()
        let signature = consentDocument.signatures?.first
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.text = config.read(query: "Review Consent Step Text")
        reviewConsentStep.reasonForConsent = config.read(query: "Reason for Consent Text")

        /// Show the user a notice regarding battery usage
        let batteryUsageNoticeStep = ORKInstructionStep(identifier: "BatteryUsageNoticeStep")
        batteryUsageNoticeStep.title = "Battery Usage"
        batteryUsageNoticeStep.detailText = "Please note that running the LifeSpace app in the background may result in more rapid discharge of battery power."

        /// Ask user to enter their study ID
        let studyIDAnswerFormat = ORKAnswerFormat.textAnswerFormat(withMaximumLength: 10)
        let studyIDEntryStep = ORKQuestionStep(
            identifier: "StudyIDEntryStep",
            title: "Study ID",
            question: "Enter your study ID:",
            answer: studyIDAnswerFormat
        )
        studyIDEntryStep.isOptional = false

        /// Ask user to sign up with their Apple ID or e-mail address and password
        var loginSteps: [ORKStep]
        if config["Login-Sign-In-With-Apple"]?["Enabled"] as? Bool == true {
            let signInWithAppleStep = CKSignInWithAppleStep(identifier: "SignInWithApple")
            loginSteps = [signInWithAppleStep]
        } else {
            let regexp = try? NSRegularExpression(
                pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
            )
            let registerStep = ORKRegistrationStep(
                identifier: "RegistrationStep",
                title: "Registration",
                text: "Sign up for this study.",
                passcodeValidationRegularExpression: regexp,
                passcodeInvalidMessage: "Your password does not meet the following criteria: minimum 8 characters with at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character",
                options: []
            )
            let loginStep = ORKLoginStep(
                identifier: "LoginStep",
                title: "Login",
                text: "Log into this study.",
                loginViewControllerClass: CKLoginStepViewController.self
            )
            loginSteps = [registerStep, loginStep]
        }

        /// Ask the user to create a security passcode that will be used to access the app
        /// Please note, this requires `NSFaceIDUsageDescription`to be set  in Info.plist
        let passcodeInstructionStep = ORKInstructionStep(identifier: "PasscodeInstructionStep")
        passcodeInstructionStep.title = "Set a Passcode"
        passcodeInstructionStep.detailText = "In the next step, you'll be asked to create a passcode to protect access to your data in the app. You'll need to remember this passcode and enter it every time you open the app. Note that your passcode is different from your Study ID."

        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        let type = config.read(query: "Passcode Type")
        if type == "6" {
            passcodeStep.passcodeType = .type6Digit
        } else {
            passcodeStep.passcodeType = .type4Digit
        }
        passcodeStep.text = config.read(query: "Passcode Text")

        let passcodeSteps = [passcodeInstructionStep, passcodeStep]

        /// Inform the user that they are done with onboarding
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = config.read(query: "Completion Step Title")
        completionStep.text = config.read(query: "Completion Step Text")

        /// Create an array with the steps to show the user
        let introSteps: [ORKStep] = [studyIDEntryStep, reviewConsentStep, batteryUsageNoticeStep]
        let securitySteps = loginSteps + passcodeSteps
        let fullSteps = introSteps + securitySteps + [completionStep]

        /// Create a ResearchKit task from the array of steps
        let orderedTask = ORKOrderedTask(identifier: "StudyOnboardingTask", steps: fullSteps)

        /// Present the task to the user
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        return taskViewController
    }
}
