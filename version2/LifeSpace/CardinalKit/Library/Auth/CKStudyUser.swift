//
//  CKStudyUser.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import Firebase
import CardinalKit

class CKStudyUser: ObservableObject {

    static let shared = CKStudyUser()

    private weak var authStateHandle: AuthStateDidChangeListenerHandle?
    
    /* **************************************************************
     * the current user only resolves if we are logged in
     **************************************************************/
    var currentUser: User? {
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
        if let authCollection = authCollection {
            return "\(authCollection)\(prefix)_surveys/"
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

    init() {
        // listen for changes in authentication state from Firebase and update currentUser
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, _) in
            self?.objectWillChange.send()
        }
    }

    deinit {
        // remove the authentication state handle when the instance is deallocated
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
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

    func getLastSurveyDate() async throws {
        // Get the date of the last completed survey from the user document in Firestore
        // then store the result locally
        
        if let dataBucket = rootAuthCollection,
           let uid = currentUser?.uid {

            let db = Firestore.firestore()
            let document = try await db.collection(dataBucket).document(uid).getDocument()
            let lastSurveyDateString = document.get("lastSurveyDate") as? String
            UserDefaults.standard.setValue(lastSurveyDateString, forKey: Constants.lastSurveyDate)
        }
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
