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

            Image("LifeSpace")
                .resizable()
                .scaledToFit()
                .padding()

            GroupBox {
                Text("Daily Survey")
                    .font(.largeTitle)
                    .bold()
                Text("Please complete this simple survey daily to assess your own health.")
                    .font(.body)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding()
                Button(action: {
                    self.showingOnboard.toggle()
                }, label: {
                    Text("Start Survey")
                        .frame(maxWidth: .infinity)
                })
                .padding()
                .foregroundColor(.white)
                .background(Color("primaryRed"))
                .cornerRadius(8)
                .padding()
                .sheet(isPresented: $showingOnboard, onDismiss: {
                }, content: {
                    AnyView(CKTaskViewController(tasks: DailySurveyTask(showInstructions: false)))
                })
            }.padding()

            Spacer()
        }
    }
}


struct DailySurveyStartButton_Previews: PreviewProvider {
    static var previews: some View {
        DailySurveyStartButton()
    }
}
