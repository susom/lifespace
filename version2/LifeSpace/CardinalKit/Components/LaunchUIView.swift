//
//  LaunchUIView.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 7/13/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import SwiftUI

struct LaunchUIView: View {

    @AppStorage(Constants.onboardingDidComplete) var didCompleteOnboarding = false
    @ObservedObject var launchData: LaunchModel = LaunchModel.sharedinstance
    @ObservedObject var studyUser: CKStudyUser  = CKStudyUser.shared

    var body: some View {
        VStack(spacing: 10) {

            if didCompleteOnboarding && (studyUser.currentUser != nil) {
                if launchData.showSurvey {
                    DailySurveyStartButton()
                } else if launchData.showPermissionView {
                    PermissionLocationUIView()
                } else {
                    MainUIView()
                }
            } else {
                OnboardingUIView()
            }
        }.onAppear(perform: {
            launchData.showPermissionView = !LocationService.shared.userAuthorizeAlways()
        })
    }
}

struct LaunchUIView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchUIView()
    }
}

class LaunchModel: ObservableObject {
    static let sharedinstance = LaunchModel()
    @Published var showSurvey: Bool = false
    @Published var showSurveyAfterPasscode: Bool = false
    @Published var showPermissionView: Bool = false
    init() {
        showSurvey = false
        showSurveyAfterPasscode = false
        showPermissionView = false
    }
}

