//
//  OnboardingViewController+Coordinator.swift
//  LifeSpace
//
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import ResearchKit
import Firebase
import CardinalKit

class OnboardingViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
    public func taskViewController(
        _ taskViewController: ORKTaskViewController,
        shouldPresent step: ORKStep
    ) -> Bool {
        // Check if study ID is valid and show an alert if it is not
        // If study ID is valid, add it to the current user object
        if let studyIDResult = taskViewController.result.stepResult(forStepIdentifier: "StudyIDEntryStep")?.results,
           let studyID = studyIDResult[0] as? ORKTextQuestionResult,
           let id = studyID.textAnswer {
            if !StudyID.validate(id: id) {
                let alert = UIAlertController(
                    title: nil,
                    message: "The ID entered is invalid, please try again",
                    preferredStyle: .alert
                )
                let confirmAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(confirmAction)
                taskViewController.present(alert, animated: false, completion: nil)
                return false
            } else {
                CKStudyUser.shared.studyID = id
            }
        }
        // Only allow users to continue the onboarding process if they consent
        if let consentStepResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.results,
           let signatureResult = consentStepResult[0] as? ORKConsentSignatureResult {
            if !signatureResult.consented {
                taskViewController.dismiss(animated: false, completion: nil)
                return false
            }
        }
        return true
    }

    public func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?
    ) {
        let storage = Storage.storage()

        switch reason {
        case .completed:
            // if we completed the onboarding task view controller, go to home screen
            UserDefaults.standard.set(true, forKey: Constants.onboardingDidComplete)

            // Save the current user object to the database
            CKStudyUser.shared.save()

            if let signatureResult = taskViewController.result.stepResult(
                forStepIdentifier: "ConsentReviewStep"
            )?.results?.first as? ORKConsentSignatureResult {
                let consentDocument = LifeSpaceConsent()
                signatureResult.apply(to: consentDocument)

                consentDocument.makePDF { data, error -> Void in
                    let config = CKPropertyReader(file: "CKConfiguration")
                    var consentFileName = config.read(query: "Consent File Name") ?? "consent"

                    // Adds study ID to consent file name if it exists
                    if let studyID = CKStudyUser.shared.studyID {
                        consentFileName = "\(studyID)_\(consentFileName)"
                    }

                    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
                    docURL = docURL?.appendingPathComponent("\(consentFileName).pdf")

                    do {
                        guard let url = docURL else {
                            return
                        }

                        try data?.write(to: url)
                        UserDefaults.standard.set(url.path, forKey: "consentFormURL")
                        print(url.path)

                        let storageRef = storage.reference()
                        if let documentCollection = CKStudyUser.shared.consentCollection {
                            let documentRef = storageRef.child("\(documentCollection)\(consentFileName).pdf")
                            documentRef.putFile(from: url, metadata: nil) { _, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }

            print("Login successful! task: \(taskViewController.task?.identifier ?? "(no ID)")")

            fallthrough
        default:
            taskViewController.dismiss(animated: true, completion: nil)
        }
    }

    func taskViewController(
        _ taskViewController: ORKTaskViewController,
        stepViewControllerWillAppear stepViewController: ORKStepViewController
    ) {
        /// If we are navigating forward from the registration step, then try to register an account
        if stepViewController.step?.identifier == "LoginStep" {
            let stepResult = taskViewController.result.stepResult(forStepIdentifier: "RegistrationStep")
            if let emailRes = stepResult?.results?.first as? ORKTextQuestionResult,
               let email = emailRes.textAnswer {
                if let passwordRes = stepResult?.results?[1] as? ORKTextQuestionResult,
                   let pass = passwordRes.textAnswer {

                    /// Register a new account with given email and password using Firebase
                    Auth.auth().createUser(withEmail: email, password: pass) { _, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                /// If an error occurs, show an alert and navigate back to the registration step
                                let alert = UIAlertController(
                                    title: "Registration Error!",
                                    message: error.localizedDescription,
                                    preferredStyle: .alert
                                )
                                let action = UIAlertAction(
                                    title: "OK",
                                    style: .cancel,
                                    handler: nil
                                )
                                alert.addAction(action)
                                taskViewController.present(alert, animated: false)
                                stepViewController.goBackward()
                            }
                        }
                    }
                }
            }
        }
    }

    func taskViewController(
        _ taskViewController: ORKTaskViewController,
        viewControllerFor step: ORKStep
    ) -> ORKStepViewController? {
        switch step {
        case is CKHealthDataStep:
            return CKHealthDataStepViewController(step: step)
        case is CKHealthRecordsStep:
            return CKHealthRecordsStepViewController(step: step)
        case is CKSignInWithAppleStep:
            return CKSignInWithAppleStepViewController(step: step)
        case is CKReviewConsentDocument:
            return CKReviewConsentDocumentViewController(step: step)
        default:
            return nil
        }
    }
}
