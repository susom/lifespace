//
//  DailySurveyStartButton.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 19/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI

struct DailySurveyStartButton: View {
    @State var showingOnboard = false
    
    var body: some View {
        VStack(spacing: 10){
            Spacer()
            Text("Daily Questionnaire")
                .font(.system(size: 24, weight: .light, design: .default))
                .bold()
            Text("Please complete this survey daily to assess your own health.")
                .font(.system(size: 20, weight: .light, design: .default))
                .padding()
            Spacer()
            Button(action: {
                self.showingOnboard.toggle()
            }, label: {
                 Text("Get Started")
            })
                .padding()
                .foregroundColor(.white)
                .background(Color("primaryRed"))
                .cornerRadius(40)
            .sheet(isPresented: $showingOnboard, onDismiss: {
            }, content: {
                AnyView(CKTaskViewController(tasks: DailySurveyTask(showInstructions: false)))
            })
            Spacer();
        }
    }
}


struct DailySurveyStartButton_Previews: PreviewProvider {
    static var previews: some View {
        DailySurveyStartButton()
    }
}
