//
//  AppDelegate+CardinalKit.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import ResearchKit
import Firebase
import CardinalKit

extension AppDelegate {
    
    /**
     Handle special CardinalKit logic for when the app is launched.
     */
    func CKAppLaunch() {
        // Sets up the CardinalKit SDK
        var options = CKAppOptions()
        options.networkDeliveryDelegate = CKAppNetworkManager()
        options.networkReceiverDelegate = CKAppNetworkManager()
        CKApp.configure(options)

        // Updates the last active date on the user document
        CKStudyUser.shared.save()
    }

}
