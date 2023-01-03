//
//  OnboardingUIView.swift
//
//  Created for the CardinalKit framework.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import ResearchKit
import CardinalKit
import Firebase

struct OnboardingElement {
    let logo: String
    let title: String
    let description: String
}

struct OnboardingUIView: View {
    var onboardingElements: [OnboardingElement] = []
    let color: Color
    let config = CKPropertyReader(file: "CKConfiguration")
    @State var showingOnboard = false
    @State var showingLogin = false
    
    var onComplete: (() -> Void)?

    init(onComplete: (() -> Void)? = nil) {
        self.color = Color(config.readColor(query: "Primary Color") ?? UIColor.primaryColor())
        self.onComplete = onComplete

        if let onboardingData = config.readAny(query: "Onboarding") as? [[String: String]] {
            for data in onboardingData {
                guard let logo = data["Logo"],
                      let title = data["Title"],
                      let description = data["Description"] else {
                    continue
                }
                let element = OnboardingElement(
                    logo: logo,
                    title: title,
                    description: description
                )
                self.onboardingElements.append(element)
            }
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Image("LifeSpace")
                .resizable()
                .scaledToFit()
                .padding()

            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.showingOnboard.toggle()
                }, label: {
                     Text("Join Study")
                        .padding(Metrics.PADDING_BUTTON_LABEL)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(self.color)
                        .cornerRadius(Metrics.RADIUS_CORNER_BUTTON)
                        .font(.system(size: 20, weight: .bold, design: .default))
                })
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)
                .sheet(isPresented: $showingOnboard, onDismiss: {
                    self.onComplete?()
                }, content: {
                    OnboardingViewController().ignoresSafeArea(edges: .all)
                })
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    self.showingLogin.toggle()
                }, label: {
                     Text("I'm a Returning User")
                        .padding(Metrics.PADDING_BUTTON_LABEL)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(self.color)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: Metrics.RADIUS_CORNER_BUTTON
                            ).stroke(
                                self.color, lineWidth: 2
                            )
                        )
                })
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)
                .sheet(isPresented: $showingLogin, onDismiss: {
                    self.onComplete?()
                }, content: {
                    LoginExistingUserViewController().ignoresSafeArea(edges: .all)
                })
                Spacer()
            }
        }
    }
}

struct InfoView: View {
    let logo: String
    let title: String
    let description: String
    let color: Color
    var body: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(6)
                .overlay(
                    Text(logo)
                        .foregroundColor(.white)
                        .font(.system(size: 42, weight: .light, design: .default))
                )

            Text(title).font(.title)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.leading, 40)
                .padding(.trailing, 40)
        }
    }
}

struct OnboardingUIView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingUIView()
    }
}
