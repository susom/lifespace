//
//  ProfileUIView.swift
//  CardinalKit_Example
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import SwiftUI

struct ProfileUIView: View {
    let color: Color
    let config = CKPropertyReader(file: "CKConfiguration")

    init(color: Color) {
        self.color = color
    }

    var body: some View {
        VStack {
            Text("Profile").font(.system(size: 25, weight: .bold))
            List {
                Section {
                    StudyIDView()
                }.listRowBackground(Color.white)

                Section {
                    ChangePasscodeView()
                }

                Section {
                    ReportView(color: self.color, email: config.read(query: "Email") ?? "cardinalkit@stanford.edu")
                    DocumentView()
                    PrivacyPolicyView(site: Constants.privacyPolicyURL)
                }

                Section {
                    WithdrawView(color: self.color)
                }

                Section {
                    Text(config.read(query: "Copyright") ?? "Made at Stanford University")
                }
            }.listStyle(GroupedListStyle())
        }
    }
}

struct ProfileUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUIView(color: Color.red)
    }
}
