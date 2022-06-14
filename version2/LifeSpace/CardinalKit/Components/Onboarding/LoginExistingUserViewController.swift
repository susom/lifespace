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
        
        let studyIDAnswerFormat = ORKAnswerFormat.textAnswerFormat(withMaximumLength: 10)
        let studyIDEntryStep = ORKQuestionStep(identifier: "StudyIDEntryStep", title: "Study ID", question: "Enter your study ID:", answer: studyIDAnswerFormat)
        
        loginSteps = [studyIDEntryStep]
        
        if config["Login-Sign-In-With-Apple"]["Enabled"] as? Bool == true {
            let signInWithAppleStep = CKSignInWithAppleStep(identifier: "SignExistingInWithApple")
            loginSteps += [signInWithAppleStep]
        } else {
            let loginStep = ORKLoginStep(identifier: "LoginExistingStep", title: "Login", text: "Log into this study.", loginViewControllerClass: LoginViewController.self)
            
            loginSteps += [loginStep]
        }
        
        // use the `ORKPasscodeStep` from ResearchKit.
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode") //NOTE: requires NSFaceIDUsageDescription in info.plist
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
        
        // get consent if user doesn't have a consent document in cloud storage
        let consentDocument = ConsentDocument()
        let signature = consentDocument.signatures?.first
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.text = config.read(query: "Review Consent Step Text")
        reviewConsentStep.reasonForConsent = config.read(query: "Reason for Consent Text")
        let consentReview = CKReviewConsentDocument(identifier: "ConsentReview")
        
        // create a task with each step
        loginSteps += [consentReview, reviewConsentStep, passcodeStep]
        
        let navigableTask = ORKNavigableOrderedTask(identifier: "StudyLoginTask", steps: loginSteps)
        
        // ADD New navigation Rule (if has or not consentDocument)
        // Consent Rule
        let resultConsent = ORKResultSelector(resultIdentifier: "ConsentReview")
        let booleanAnswerConsent = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultConsent, expectedAnswer: true)
        let predicateRuleConsent = ORKPredicateStepNavigationRule(resultPredicates: [booleanAnswerConsent],
                                                           destinationStepIdentifiers: ["HealthKit"],
                                                           defaultStepIdentifier: "ConsentReviewStep",
                                                           validateArrays: true)
        navigableTask.setNavigationRule(predicateRuleConsent, forTriggerStepIdentifier: "ConsentReview")
        
        // wrap that task on a view controller
        let taskViewController = ORKTaskViewController(task: navigableTask, taskRun: nil)
        taskViewController.delegate = context.coordinator // enables `ORKTaskViewControllerDelegate` below
        
        // & present the VC!
        return taskViewController
    }
    
}

