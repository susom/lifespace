//
//  SurveyRules.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 7/3/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import Foundation

class SurveyRules {

    // Formatted string with the start hour of the survey
    private static var startHourString: String {
        if Constants.hourToOpenSurvey <= 12 {
            return String(Constants.hourToOpenSurvey) + " AM"
        } else {
            return String(Constants.hourToOpenSurvey - 12) + " PM"
        }
    }

    // Error messages to show the user when rules aren't met
    public static let tooEarlyMessage = "Please come back after \(startHourString) to complete your survey!"
    public static let alreadyTookSurveyMessage = "You've already taken the survey today, please check back tomorrow after \(startHourString)"

    // Rule: Participants can only take the daily survey after a certain hour
    public static func isAfterStartHour() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= Constants.hourToOpenSurvey
    }

    // Rule: Participants are only allowed to complete the daily survey once daily
    public static func wasNotTakenToday() -> Bool {
        if let lastSurveyDateString = UserDefaults.standard.value(forKey: Constants.lastSurveyDate) as? String {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)

            if let lastSurveyDate = formatter.date(from: lastSurveyDateString) {
                return !(Calendar.current.isDateInToday(lastSurveyDate))
            }
        }
        return true
    }

}
