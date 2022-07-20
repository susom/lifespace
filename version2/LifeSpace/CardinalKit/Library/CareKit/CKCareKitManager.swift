//
//  CKCareKitManager.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 12/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

//import CareKit
//
//class CKCareKitManager: NSObject {
//    
//    //static let shared = CKCareKitManager()
//
//    override init() {
//        super.init()
//        initStore()
//    }
//
//    func wipe() throws {
//        try coreDataStore.delete()
//    }
//
//    fileprivate func initStore(forceUpdate: Bool = false) {
//        let lastUpdateDate: Date? = UserDefaults.standard.object(forKey: Constants.prefCareKitCoreDataInitDate) as? Date
//        if forceUpdate || UserDefaults.standard.object(forKey: Constants.prefCareKitCoreDataInitDate) == nil {
//            coreDataStore.populateSampleData(lastUpdateDate:lastUpdateDate)
//            healthKitStore.populateSampleData()
//            UserDefaults.standard.set(Date(), forKey: Constants.prefCareKitCoreDataInitDate)
//        }
//    }
//
//}
