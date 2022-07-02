//
//  DocumentView.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 10/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import Firebase

struct DocumentView: View {
    
    @State private var showPreview = false
    var documentsURL: URL? = nil
    
    init() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let DocumentCollection = CKStudyUser.shared.consentCollection {
            let config = CKPropertyReader(file: "CKConfiguration")
            var consentFileName = config.read(query: "Consent File Name")

            // Adds study ID to consent file name if it exists
            if let studyID = CKStudyUser.shared.studyID {
                consentFileName = "\(studyID)_\(consentFileName)"
            }

            let DocumentRef = storageRef.child("\(DocumentCollection)\(consentFileName).pdf")
            // Create local filesystem URL
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent("\(consentFileName).pdf") as NSURL?
            let url = docURL! as URL
            self.documentsURL = URL(fileURLWithPath: url.path, isDirectory: false)
            UserDefaults.standard.set(url.path, forKey: "consentFormURL")
            // Download to the local filesystem
            DocumentRef.write(toFile: url) { _, error in
                if let error = error {
                    print("error \(error)")
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            Text("View Consent Document")
            Spacer()
            Text("›")
        }.frame(height: 60)
            .contentShape(Rectangle())
            .gesture(TapGesture().onEnded({
                self.showPreview = true
            }))
            .background(DocumentPreviewViewController(self.$showPreview, url: self.documentsURL))
    }
}

struct DDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView()
    }
}
