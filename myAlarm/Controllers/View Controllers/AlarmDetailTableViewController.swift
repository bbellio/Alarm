//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Bethany Wride on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    // Receiver
    var receivingAlarm: Alarm?
    var alarmIsOn: Bool = true
    
    // MARK: - Outlets
    
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var disableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Actions
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = receivingAlarm else { return }
        if alarmIsOn == true {
            alarmIsOn = false
            disableButton.setTitle("Enable", for: .normal)
            AlarmController.sharedInstance.scheduleUserNotifications(for: alarm)
        } else {
            alarmIsOn = true
            disableButton.setTitle("Disable", for: .normal)
            AlarmController.sharedInstance.cancelUserNotifications(for: alarm)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmName = alarmNameTextField.text,
            let alarmTime = alarmTimePicker?.date,
            !alarmName.isEmpty else { return}
        
        if let alarmToBeUpdated = receivingAlarm {
            AlarmController.sharedInstance.updateAlarm(to: alarmToBeUpdated, fireDate: alarmTime, name: alarmName, enabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: alarmTime, name: alarmName, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
            
  
    private func updateViews() {
        guard let alarm = receivingAlarm else { return }
        alarmTimePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.alarmName
        self.title = alarm.alarmName
        self.alarmIsOn = alarm.enabled
        if alarm.enabled == true {
            disableButton.setTitle("Disable", for: .normal)
        } else {
            disableButton.setTitle("Enable", for: .normal)
        }
    }
}
