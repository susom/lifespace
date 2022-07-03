//
//  HomeView.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 5/18/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSurveyAlert = false
    @State private var alertMessage = ""
    @State private var showingSurvey = false
    @State private var trackingOn = UserDefaults.standard.bool(forKey: Constants.prefTrackingStatus)
    @State private var optionsPanelOpen = true
    
    var body: some View {
        ZStack {
            // map on the bottom layer
            MapManagerViewWrapper()

            // overlay buttons on map
            VStack {
                
                Spacer()

                GroupBox {

                    Button {
                        withAnimation {
                            self.optionsPanelOpen.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Options")
                            Spacer()
                            Image(systemName: self.optionsPanelOpen ? "chevron.down" : "chevron.up")
                        }
                    }

                    if self.optionsPanelOpen {
                        GroupBox {
                            Button {
                                // First check if it's too early to take the survey,
                                // and if not, then check to make sure it hasn't been
                                // taken already today.
                                if !SurveyRules.isAfterStartHour() {
                                    self.alertMessage = SurveyRules.tooEarlyMessage
                                    self.showingSurveyAlert.toggle()
                                } else if !SurveyRules.wasNotTakenToday() {
                                    self.alertMessage = SurveyRules.alreadyTookSurveyMessage
                                    self.showingSurveyAlert.toggle()
                                } else {
                                    self.showingSurvey.toggle()
                                }
                            } label: {
                                Text("Take Daily Survey")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .alert(isPresented: $showingSurveyAlert) {
                                Alert(title: Text("Survey Not Available"),
                                      message: Text(self.alertMessage),
                                      dismissButton: .default(Text("OK")))
                            }
                            .sheet(isPresented: $showingSurvey) {
                                CKTaskViewController(tasks: DailySurveyTask(showInstructions: false))
                            }
                        }.groupBoxStyle(ButtonGroupBoxStyle())

                        GroupBox {
                            Toggle("Track My Location", isOn: $trackingOn)
                                .onChange(of: trackingOn) { _ in
                                    AlternovaLocationFetcher.shared.startStopTracking()
                                }
                        }
                    }
                }
            }.onAppear {
                // Make sure last survey date is updated
                async {
                    do {
                        try await CKStudyUser.shared.getLastSurveyDate()
                    } catch {
                        print("Error updating last survey date.")
                    }
                }
            }
        }
    }
}

struct ButtonGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color("primaryRed")))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
