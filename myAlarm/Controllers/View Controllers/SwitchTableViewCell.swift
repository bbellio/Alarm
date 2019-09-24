//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Bethany Wride on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

// Step 1
protocol AlarmTableViewCellDelegate: class {
       func enabledValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
   }

class SwitchTableViewCell: UITableViewCell {
    
    // Receiver
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // Step 2
    // Delegate receiver
    weak var delegate: AlarmTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // MARK: - Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Step 3
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.enabledValueChanged(self, selected: alarmSwitch.isOn)
        AlarmController.sharedInstance.saveToPersistentStorage()
    }
    
    func updateViews() {
        guard let alarm = alarm else { return }
        nameLabel.text = alarm.alarmName
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }
}
