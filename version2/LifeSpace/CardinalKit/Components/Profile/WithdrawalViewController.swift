//
//  WithdrawalViewController.swift
//
//  Created for the CardinalKit framework.
//  Copyright © 2020 CardinalKit. All rights reserved.
//

import UIKit
import SwiftUI
import ResearchKit
import Firebase
import CardinalKit

struct WithdrawalViewController: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    typealias UIViewControllerType = ORKTaskViewController
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let config = CKPropertyReader(file: "CKConfiguration")

        let instructionStep = ORKInstructionStep(identifier: "WithdrawlInstruction")
        instructionStep.title = config.read(query: "Withdrawal Instruction Title") ?? "Are you sure you want to withdraw?"
        instructionStep.text = config.read(query: "Withdrawal Instruction Text") ?? """
            Withdrawing from the study will reset the app to the state it was in prior to you originally joining the study.
        """

        let completionStep = ORKCompletionStep(identifier: "Withdraw")
        completionStep.title = config.read(query: "Withdraw Title") ?? "We appreciate your time."
        completionStep.text = config.read(query: "Withdraw Text") ?? """
            Thank you for your contribution to this study. We are sorry that you could not continue. The app will now close.
        """

        let withdrawTask = ORKOrderedTask(identifier: "Withdraw", steps: [instructionStep, completionStep])

        // wrap that task on a view controller
        let taskViewController = ORKTaskViewController(task: withdrawTask, taskRun: nil)

        taskViewController.delegate = context.coordinator // enables `ORKTaskViewControllerDelegate` below

        // & present the VC!
        return taskViewController
    }

    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        public func taskViewController(
            _ taskViewController: ORKTaskViewController,
            didFinishWith reason: ORKTaskViewControllerFinishReason,
            error: Error?
        ) {
            switch reason {
            case .completed:
                do {
                    // try CKCareKitManager.shared.wipe() -- CareKit is disabled
                    try CKStudyUser.shared.signOut()

                    if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
                        ORKPasscodeViewController.removePasscodeFromKeychain()
                    }

                    UserDefaults.standard.set(nil, forKey: Constants.prefCareKitCoreDataInitDate)
                    UserDefaults.standard.set(nil, forKey: Constants.prefHealthRecordsLastUploaded)
                    UserDefaults.standard.set(false, forKey: Constants.onboardingDidComplete)
                } catch {
                    print(error.localizedDescription)
                    Alerts.showInfo(title: "Error", message: error.localizedDescription)
                }
                fallthrough
            default:
                taskViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
