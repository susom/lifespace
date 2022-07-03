//
//  CKStudyUser.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import Firebase
import CardinalKit

class CKStudyUser {

    static let shared = CKStudyUser()
    
    /* **************************************************************
     * the current user only resolves if we are logged in
     **************************************************************/
    var currentUser: User? {
        // this is a reference to the
        // Firebase + Google Identity User
        return Auth.auth().currentUser
    }

    /* **************************************************************
     * store your Firebase objects under this path in order to
     * be compatible with CardinalKit GCP rules.
     **************************************************************/
    fileprivate let prefix = "ls"

    fileprivate var baseCollection: String? {
        if let bundleId = Bundle.main.bundleIdentifier {
            return "/\(bundleId)"
        }
        return nil
    }

    fileprivate var rootAuthCollection: String? {
        if let baseCollection = baseCollection {
            return "\(baseCollection)/study/\(prefix)_users/"
        }
        return nil
    }

    var authCollection: String? {
        if let userId = currentUser?.uid,
           let root = rootAuthCollection {
            return "\(root)\(userId)/"
        }
        return nil
    }

    var mapPointsCollection: String? {
        if let authCollection = authCollection {
            return "\(authCollection)\(prefix)_location_data/"
        }
        return nil
    }
    
    var surveysCollection: String? {
        if let baseCollection = baseCollection {
            return "\(baseCollection)/\(prefix)_surveys/"
        }
        return nil
    }

    var consentCollection: String? {
        if let authCollection = authCollection {
            return "\(authCollection)\(prefix)_consent/"
        }
        
        return nil
    }

    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.prefUserEmail)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: Constants.prefUserEmail)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.prefUserEmail)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return (currentUser?.isEmailVerified ?? false) && UserDefaults.standard.bool(forKey: Constants.prefConfirmedLogin)
    }

    var studyID: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.prefStudyID)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: Constants.prefStudyID)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.prefStudyID)
            }
        }
    }

    /**
     Send a login email to the user.

     At this stage, we do not have a `currentUser` via Google Identity.

     - Parameters:
     - email: validated address that should receive the sign-in link.
     - completion: callback
     */
    func sendLoginLink(email: String, completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty else {
            completion(false)
            return
        }
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://cs342.page.link")
        actionCodeSettings.handleCodeInApp = true // The sign-in operation has to always be completed in the app.
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }

    /**
     Save a snapshot of our current user into Firestore.
     */
    func save() {
        if let dataBucket = rootAuthCollection,
           let email = currentUser?.email,
           let uid = currentUser?.uid {

            CKSession.shared.userId = uid
            CKSendHelper.createNecessaryDocuments(path: dataBucket)
            let settings = FirestoreSettings()
            settings.isPersistenceEnabled = false
            let db = Firestore.firestore()
            db.settings = settings
            db.collection(dataBucket).document(uid).setData([
                "userID": uid,
                "studyID": studyID ?? "",
                "lastActive": Date().ISOStringFromDate(),
                "email": email],
                merge: true
            )
        }
    }

    /**
        Updates the last completed survey date in the user document with
        the current date, stored as an ISO 8601 formatted string
     */
    func updateLastSurveyDate() {
        let today = Date().ISOStringFromDate()

        // Update locally
        UserDefaults.standard.setValue(today, forKey: Constants.lastSurveyDate)

        // Update in database
        if let dataBucket = rootAuthCollection,
           let uid = currentUser?.uid {
            let db = Firestore.firestore()
            db.collection(dataBucket).document(uid).updateData([
                "lastSurveyDate": today])
        }
    }

    func getLastSurveyDate() async throws -> Date? {
        var lastSurveyDate: Date?

        if let dataBucket = rootAuthCollection,
           let uid = currentUser?.uid {

            // Get the date of the last completed survey from the user document in Firestore
            let db = Firestore.firestore()
            let document = try await db.collection(dataBucket).document(uid).getDocument()
            let lastSurveyDateString = document.get("lastSurveyDate") as? String
            if let lastSurveyDateString = lastSurveyDateString {
                let formatter = ISO8601DateFormatter()
                let date = formatter.date(from: lastSurveyDateString)
                lastSurveyDate = date
            }
        }
        return lastSurveyDate
    }

    /**
     Remove the current user's auth parameters from storage.
     */
    func signOut() throws {
        email = nil
        studyID = nil
        try Auth.auth().signOut()
    }

}
