//
//  CKReviewConsentDocument.swift
//  LifeSpace
//
//  Created by Julian Esteban Ramos Martinez on 16/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Firebase
import ResearchKit


public class CKReviewConsentDocument: ORKQuestionStep{
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

public class CKReviewConsentDocumentViewController:ORKQuestionStepViewController{
    public var CKReviewConsentDocument: CKReviewConsentDocument!{
        return step as? CKReviewConsentDocument
    }
    
    public override func viewDidLoad() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // REVIEW IF DOCUMENT EXIST
        if let DocumentCollection = CKStudyUser.shared.consentCollection {
            let config = CKPropertyReader(file: "CKConfiguration")
            let consentFileName = config.read(query: "Consent File Name")
            let DocumentRef = storageRef.child("\(DocumentCollection)\(consentFileName).pdf")
            // Create local filesystem URL
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent("\(consentFileName).pdf") as NSURL?
            let url = docURL! as URL
            // Download to the local filesystem
            let downloadTask = DocumentRef.write(toFile: url) { url, error in
              if let error = error {
                  print("Consent Error: " + error.localizedDescription)
                  self.setAnswer(false)
              } else {
                  self.setAnswer(true)
              }
                super.goForward()
            }
        }
    }
}
