//
//  CKReviewConsentDocument.swift
//  LifeSpace
//
//  Created for the CardinalKit framework.
//  Copyright © 2021 CardinalKit. All rights reserved.
//

import Foundation
import Firebase
import ResearchKit

public class CKReviewConsentDocument: ORKQuestionStep {
    // Boolean step that checks for the existence of a consent document
    // and sets its answer to the result. Used for navigation during
    // onboarding.
    public override init(
        identifier: String
    ) {
        super.init(identifier: identifier)
        self.answerFormat = ORKAnswerFormat.booleanAnswerFormat()
    }

    @available(*, unavailable)
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class CKReviewConsentDocumentViewController: ORKQuestionStepViewController {
    public var CKReviewConsentDocument: CKReviewConsentDocument! {
        return step as? CKReviewConsentDocument
    }

    public override func viewDidLoad() {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        // Attempt to download consent document from cloud storage
        if let consentCollection = CKStudyUser.shared.consentCollection {
            let config = CKPropertyReader(file: "CKConfiguration")
            var consentFileName = config.read(query: "Consent File Name") ?? "consent"

            // Adds study ID to consent file name if it exists
            if let studyID = CKStudyUser.shared.studyID {
                consentFileName = "\(studyID)_\(consentFileName)"
            }

            let documentRef = storageRef.child("\(consentCollection)\(consentFileName).pdf")
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent("\(consentFileName).pdf") as NSURL?
            let url = docURL! as URL
            documentRef.write(toFile: url) { _, error in
                if let error = error {
                    // Couldn't download consent document
                    print("Error downloading consent document: " + error.localizedDescription)
                    self.setAnswer(false)
                } else {
                    // Successfully downloaded consent document
                    self.setAnswer(true)
                }
                super.goForward()
            }
        }
    }
}
