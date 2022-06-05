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
                
                Button("Take Daily Survey"){
                    if(surveyActive){
                        self.showingSurvey.toggle()
                    } else {
                        self.showingSurveyAlert.toggle()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color("primaryRed"))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(5)
                .alert(isPresented: $showingSurveyAlert){
                    Alert(title: Text("Survey Not Available"), message: Text("Please come back after 7:00 PM to complete your daily survey!"), dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented: $showingSurvey){
                    CKTaskViewController(tasks: DailySurveyTask(showInstructions: false))
                }
                
                Toggle("Track My Location", isOn: $trackingOn)
                    .onChange(of: trackingOn) { value in
                        AlternovaLocationFetcher.shared.startStopTracking()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("primaryRed"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(5)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
