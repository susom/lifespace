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
    @State private var showingSurvey = false
    @State private var trackingOn = true
    @State private var optionsPanelOpen = true
    
    var surveyActive: Bool {
        // if it's after 7pm today in the user's local time, the survey is active
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 19
    }
    
    var body: some View {
        ZStack {
            //map on the bottom layer
            MapManagerViewWrapper()
            
            //overlay buttons on map
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
                        GroupBox{
                            Button {
                                if(surveyActive){
                                    self.showingSurvey.toggle()
                                } else {
                                    self.showingSurveyAlert.toggle()
                                }
                            } label: {
                                Text("Take Daily Survey")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .alert(isPresented: $showingSurveyAlert){
                                Alert(title: Text("Survey Not Available Yet"), message: Text("Please come back after 7:00 PM to complete your daily survey!"), dismissButton: .default(Text("OK")))
                            }
                            .sheet(isPresented: $showingSurvey){
                                CKTaskViewController(tasks: DailySurveyTask(showInstructions: false))
                            }
                        }.groupBoxStyle(ButtonGroupBoxStyle())
                        
                        GroupBox{
                            Toggle("Track My Location", isOn: $trackingOn)
                                .onChange(of: trackingOn) { value in
                                    AlternovaLocationFetcher.shared.startStopTracking()
                                }
                        }
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
