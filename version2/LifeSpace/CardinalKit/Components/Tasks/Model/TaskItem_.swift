//
//  StudyTableItem.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit
import SwiftUI

enum LocalTaskItem: Int {

    /*
     * STEP (1) APPEND TABLE ITEMS HERE,
     * Give each item a recognizable name!
     */
    case sampleResearchKitSurvey,
         sampleLocation,
         sampleLearnItem
         
    /*
     * STEP (2) for each item, what should its
     * title on the list be?
     */
    var title: String {
        switch self {
        case .sampleLocation:
            return "Location"
        case .sampleResearchKitSurvey:
            return "Survey (ResearchKit)"
        case .sampleLearnItem:
            return "About CardinalKit"
        }
    }
        
    /*
     * STEP (3) do you need a subtitle?
     */
    var subtitle: String {
        switch self {
        case .sampleLocation:
            return "Track your location"
        case .sampleResearchKitSurvey:
            return "Daily Survey"
        case .sampleLearnItem:
            return "Visit cardinalkit.org"
        }
    }
    
    /*
     * STEP (4) what image would you like to associate
     * with this item under the list view?
     * Check the Assets directory.
     */
    var image: UIImage? {
        switch self {
        case .sampleLocation:
             return getImage(named: "ActivityIcon")
        case .sampleLearnItem:
            return getImage(named: "CKLogoIcon")
        default:
            return getImage(named: "SurveyIcon")
        }
    }
    
    /*
     * STEP (5) what section should each item be under?
     */
    var section: String {
        switch self {
        case .sampleResearchKitSurvey, .sampleLocation:
            return "Current Tasks"
        case .sampleLearnItem:
            return "Learn"
        }
    }

    /*
     * STEP (6) when each element is tapped, what should happen?
     * define a SwiftUI View & return as AnyView.
     */
    var action: some View {
        switch self {
        case .sampleResearchKitSurvey:
            return AnyView(CKTaskViewController(tasks: TaskSamples.sampleSurveyTask))
        case .sampleLocation:
            return AnyView(LocationView())
        case .sampleLearnItem:
            return AnyView(LearnUIView())
        }
    }
    
    /*
     * HELPERS
     */
    
    fileprivate func getImage(named: String) -> UIImage? {
        UIImage(named: named) ?? UIImage(systemName: "questionmark.square")
    }
    
    static var allValues: [LocalTaskItem] {
        var index = 0
        return Array (
            AnyIterator {
                let returnedElement = self.init(rawValue: index)
                index = index + 1
                return returnedElement
            }
        )
    }
    
}
