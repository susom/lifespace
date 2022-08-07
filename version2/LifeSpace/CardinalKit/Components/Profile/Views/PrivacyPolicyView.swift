//
//  PrivacyPolicyView.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 8/7/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var site = ""

    init(site: String) {
        self.site = site
    }

    var body: some View {
        HStack {
            Text("Privacy Policy")
            Spacer()
            Text("›")
        }.frame(height: 70).contentShape(Rectangle())
            .gesture(TapGesture().onEnded({
                if let url = URL(string: self.site) {
                UIApplication.shared.open(url)
            }
        }))
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView(site: Constants.privacyPolicyURL)
    }
}
