//
//  NotificationFetcher.swift
//  CardinalKit_Example
//
//  Created by Annabel Tan on 10/25/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
//    }

    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

           center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
               if granted {
                   print("Yay!")
               } else {
                   print("Oops")
               }
           }
    }
    
    @objc func scheduleLocal() {
            registerCategories()
        
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
            content.title = "Survey Reminder"
            content.body = "Remember to complete your daily survey!"
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 19
            dateComponents.minute = 00
        
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Go to survey", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")

            case "show":
                // the user tapped our "show more info…" button
                //return AnyView(CKTaskViewController(tasks: TaskSamples.sampleSurveyTask))
                break
                
            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
}

