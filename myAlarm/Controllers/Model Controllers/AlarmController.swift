//
//  AlarmController.swift
//  myAlarm
//
//  Created by Bethany Wride on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
   
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm"
        notificationContent.body = alarm.alarmName
        notificationContent.sound = UNNotificationSound.default()
        // Pull the hour and minute from the current calendar date
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        print("Notification scheduled")
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        print("Notification cancelled")
    }
}

class AlarmController: AlarmScheduler {

    // Singleton
    static let sharedInstance = AlarmController()
    
    // Source of truth
    var alarms: [Alarm] = []
    
    // CRUD
    // Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, alarmName: name, enabled: enabled)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        saveToPersistentStorage()
    }
    
    // Update
    func updateAlarm(to alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.alarmName = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistentStorage()
    }
    
    // Delete
    func delete(alarm: Alarm) {
        guard let alarmIndex = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: alarmIndex)
        cancelUserNotifications(for: alarm)
        saveToPersistentStorage()
    }
    
    // Creates the URL
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "myAlarm.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    // Save data
    func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonAlarms = try jsonEncoder.encode(alarms)
            try jsonAlarms.write(to: fileURL())
        } catch let encodingError {
             print("Error: \(encodingError.localizedDescription)")
        }
    }
    
    // Load data
    func loadPersistentStorage() {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileURL())
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: jsonData)
            alarms = decodedAlarms
        } catch let decodingError {
            print("Error: \(decodingError.localizedDescription)")
        }
    }
    
} // MARK: - End of Class

// Mock data
  var mockAlarms: [Alarm] = {
      let alarm1 = Alarm(fireDate: Date(), alarmName: "Wake up", enabled: true)
      let alarm2 = Alarm(fireDate: Date(), alarmName: "Go to sleep", enabled: true)
      let alarm3 = Alarm(fireDate: Date(), alarmName: "Eat dinner", enabled: false)
  
      return [alarm1, alarm2, alarm3]
  }()
