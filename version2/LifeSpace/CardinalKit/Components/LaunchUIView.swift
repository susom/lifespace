//
//  OnboardingUIView.swift
//  CardinalKit_Example
//
//  Created by Varun Shenoy on 8/14/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import ResearchKit
import CardinalKit
import Firebase

struct LaunchUIView: View {
    
    @State var didCompleteOnboarding = false
    @ObservedObject var launchData: LaunchModel = LaunchModel.sharedinstance
    
    
    init() {
        
    }

    var body: some View {
        VStack(spacing: 10) {
            
            if didCompleteOnboarding && (CKStudyUser.shared.currentUser != nil){
                if launchData.showSurvey {
                    DailySurveyStartButton()
                }
                else if launchData.showPermissionView{
                    PermissionLocationUIView()
                }
                else{
                    MainUIView()
                }
                
            } else {
                OnboardingUIView() {
                    //on complete
                    if let completed = UserDefaults.standard.object(forKey: Constants.onboardingDidComplete) as? Bool {
                       self.didCompleteOnboarding = completed
                    }
                }
            }
        }.onAppear(perform: {
            launchData.showPermissionView = !AlternovaLocationFetcher.shared.userAuthorizeAlways()
            
            
            if let completed = UserDefaults.standard.object(forKey: Constants.onboardingDidComplete) as? Bool {
               self.didCompleteOnboarding = completed
            }
        }).onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(Constants.onboardingDidComplete))) { notification in
            if let newValue = notification.object as? Bool {
                self.didCompleteOnboarding = newValue
            } else if let completed = UserDefaults.standard.object(forKey: Constants.onboardingDidComplete) as? Bool {
               self.didCompleteOnboarding = completed
            }
        }
        
    }
}

struct LaunchUIView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchUIView()
    }
}

class LaunchModel: ObservableObject{
    static let sharedinstance = LaunchModel()
    @Published var showSurvey:Bool = false
    @Published var showSurveyAfterPasscode:Bool = false
    @Published var showPermissionView:Bool = false
    init(){
        showSurvey = false
        showSurveyAfterPasscode = false
        showPermissionView = false
    }
}
