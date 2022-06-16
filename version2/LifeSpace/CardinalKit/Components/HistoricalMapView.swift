//
//  HistoricalMapView.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 6/16/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

struct HistoricalMapView: View {
    @State private var date = Date()

    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2022, month: 5, day: 1)
        let endComponents = DateComponents(year: 2022, month: 6, day: 1)
        return calendar.date(from: startComponents)! ... calendar.date(from: endComponents)!
    }()

    var body: some View {
        ZStack {
            HistoricalMapViewWrapper(date: self.$date)


            VStack {
                Spacer()

                GroupBox {
                    DatePicker("", selection: $date, displayedComponents: [.date]).padding()
                }
            }
            
        }
    }
}

struct HistoricalMaps_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalMapView()
    }
}
