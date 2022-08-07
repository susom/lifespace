//
//  LoginViewController.swift
//  CardinalKit_Example
//
//  Created by Varun Shenoy on 3/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import UIKit
import ResearchKit
import CardinalKit
import Firebase

struct LoginExistingUserViewController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> OnboardingViewCoordinator {
        OnboardingViewCoordinator()
    }

    typealias UIViewControllerType = ORKTaskViewController
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    func makeUIViewController(context: Context) -> ORKTaskViewController {

        let config = CKPropertyReader(file: "CKConfiguration")
        
        var loginSteps: [ORKStep]
        
        // Step for verifying study ID
        let studyIDAnswerFormat = ORKAnswerFormat.textAnswerFormat(withMaximumLength: 10)
        let studyIDEntryStep = ORKQuestionStep(identifier: "StudyIDEntryStep", title: "Study ID", question: "Enter your study ID:", answer: studyIDAnswerFormat)
        loginSteps = [studyIDEntryStep]
        
        // Login step
        if config["Login-Sign-In-With-Apple"]["Enabled"] as? Bool == true {
            let signInWithAppleStep = CKSignInWithAppleStep(identifier: "SignExistingInWithApple")
            loginSteps += [signInWithAppleStep]
        } else {
            let loginStep = ORKLoginStep(identifier: "LoginExistingStep", title: "Login", text: "Log into this study.", loginViewControllerClass: LoginViewController.self)
            
            loginSteps += [loginStep]
        }
        
        // Step for setting passcode
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        let type = config.read(query: "Passcode Type")
        if type == "6" {
            passcodeStep.passcodeType = .type6Digit
        } else {
            passcodeStep.passcodeType = .type4Digit
        }
        passcodeStep.text = config.read(query: "Passcode Text")
        
        // *** Health Data collection is disabled for this project ***
        // let healthDataStep = CKHealthDataStep(identifier: "HealthKit")
        // let healthRecordsStep = CKHealthRecordsStep(identifier: "HealthRecords")
        
        // Steps to get consent if user doesn't have a consent document in cloud storage
        let consentDocument = LifeSpaceConsent()
        let signature = consentDocument.signatures?.first
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.text = config.read(query: "Review Consent Step Text")
        reviewConsentStep.reasonForConsent = config.read(query: "Reason for Consent Text")
        let consentReview = CKReviewConsentDocument(identifier: "ConsentReview")

        // Creates a summary step once login is complete
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = config.read(query: "Completion Step Title")
        completionStep.text = config.read(query: "Completion Step Text")
        
        // Creates a navigable task from the above steps
        loginSteps += [consentReview, reviewConsentStep, passcodeStep, completionStep]
        let navigableTask = ORKNavigableOrderedTask(identifier: "StudyLoginTask", steps: loginSteps)
        
        // Navigation rule that checks if the user has a consent document in cloud storage
        // and directs them to the consent process if they do not
        let resultConsent = ORKResultSelector(resultIdentifier: "ConsentReview")
        let booleanAnswerConsent = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultConsent, expectedAnswer: true)
        let predicateRuleConsent = ORKPredicateStepNavigationRule(resultPredicates: [booleanAnswerConsent],
                                                           destinationStepIdentifiers: ["Passcode"],
                                                           defaultStepIdentifier: "ConsentReviewStep",
                                                           validateArrays: true)
        navigableTask.setNavigationRule(predicateRuleConsent, forTriggerStepIdentifier: "ConsentReview")
        
        let taskViewController = ORKTaskViewController(task: navigableTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        return taskViewController
    }
}
