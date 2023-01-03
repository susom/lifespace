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

struct OnboardingViewController: UIViewControllerRepresentable {
    func makeCoordinator() -> OnboardingViewCoordinator {
        OnboardingViewCoordinator()
    }

    typealias UIViewControllerType = ORKTaskViewController

    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let config = CKPropertyReader(file: "CKConfiguration")
        /* **************************************************************
        *  STEP (1): Ask user to review, then sign consent form
        **************************************************************/
        let consentDocument = LifeSpaceConsent()
        let signature = consentDocument.signatures?.first
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.text = config.read(query: "Review Consent Step Text")
        reviewConsentStep.reasonForConsent = config.read(query: "Reason for Consent Text")

        /* **************************************************************
        *  STEP (2): get permission to collect HealthKit data - DISABLED
        **************************************************************/
        // see `HealthDataStep` to configure!
        // let healthDataStep = CKHealthDataStep(identifier: "Healthkit")

        /* **************************************************************
        *  STEP (3): get permission to collect HealthKit health records data - DISABLED
        **************************************************************/
        // let healthRecordsStep = CKHealthRecordsStep(identifier: "HealthRecords")

        /* **************************************************************
        *  STEP (4): ask user to enter their study ID
        **************************************************************/
        let studyIDAnswerFormat = ORKAnswerFormat.textAnswerFormat(withMaximumLength: 10)
        let studyIDEntryStep = ORKQuestionStep(identifier: "StudyIDEntryStep", title: "Study ID", question: "Enter your study ID:", answer: studyIDAnswerFormat)
        studyIDEntryStep.isOptional = false

        /* **************************************************************
        *  STEP (5): ask user to sign up with Apple or their email address
        **************************************************************/
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
                loginViewControllerClass: LoginViewController.self
            )
            loginSteps = [registerStep, loginStep]
        }
        /* **************************************************************
        *  STEP (6): ask the user to create a security passcode
        *  that will be required to use this app!
        **************************************************************/
        // use the `ORKPasscodeStep` from ResearchKit.
        // NOTE: requires NSFaceIDUsageDescription in info.plist
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        let type = config.read(query: "Passcode Type")
        if type == "6" {
            passcodeStep.passcodeType = .type6Digit
        } else {
            passcodeStep.passcodeType = .type4Digit
        }
        passcodeStep.text = config.read(query: "Passcode Text")

        /* **************************************************************
        *  STEP (7): inform the user that they are done with sign-up!
        **************************************************************/
        // use the `ORKCompletionStep` from ResearchKit
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = config.read(query: "Completion Step Title")
        completionStep.text = config.read(query: "Completion Step Text")

        /* **************************************************************
        * finally, CREATE an array with the steps to show the user
        **************************************************************/
        // given intro steps that the user should review and consent to
        let introSteps: [ORKStep] = [studyIDEntryStep, reviewConsentStep]

        // and steps regarding login / security
        let securitySteps = loginSteps + [passcodeStep]

        // guide the user through ALL steps
        let fullSteps = introSteps + securitySteps + [completionStep]

        /* **************************************************************
        * and SHOW the user these steps!
        **************************************************************/
        // create a task with each step
        let orderedTask = ORKOrderedTask(identifier: "StudyOnboardingTask", steps: fullSteps)

        // wrap that task on a view controller
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = context.coordinator // enables `ORKTaskViewControllerDelegate` below

        // & present the VC!
        return taskViewController
    }
}

