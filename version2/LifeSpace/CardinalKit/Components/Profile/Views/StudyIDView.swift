//
//  StudyIDView.swift
//  CardinalKit_Example
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import SwiftUI

struct StudyIDView: View {
    var studyID = ""
    
    init() {
        self.studyID = CKStudyUser.shared.studyID
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Study ID").font(.system(.headline)).foregroundColor(Color(.greyText()))
                Spacer()
            }
            HStack {
                Text(self.studyID).font(.system(.body)).foregroundColor(Color(.greyText()))
                Spacer()
            }
        }.frame(height: 100)
    }
}

struct StudyIDView_Previews: PreviewProvider {
    static var previews: some View {
        StudyIDView()
    }
}
