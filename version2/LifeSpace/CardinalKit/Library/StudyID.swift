//
//  StudyID.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 7/3/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import Foundation

class StudyID {

    /**
     Loads study IDs from a file in the bundle named 'studyIDs.csv' that contains a list of IDs separated by
     newline characters and checks if the list contains the given ID.
     */
    public static func validate(id: String) -> Bool {
        var allStudyIDs = [String]()

        if let studyIDsURL = Bundle.main.url(forResource: "studyIDs", withExtension: ".csv"),
           let studyIDs = try? String(contentsOf: studyIDsURL) {
            allStudyIDs = studyIDs.components(separatedBy: "\n")
            return allStudyIDs.contains(id)
        }

        return false
    }
}
