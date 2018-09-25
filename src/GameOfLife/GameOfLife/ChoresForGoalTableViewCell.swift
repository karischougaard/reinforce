//
//  ChoreInGoalTableViewCell.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 07/09/2018.
//  Copyright © 2018 Prinsisse. All rights reserved.
//

import UIKit

class ChoresForGoalTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var doesCountTowardsChoreSwitch: UISwitch!
    @IBOutlet weak var choreNameLabel: UILabel!
    
    var goal: Goal?
    var chore: Chore?
    var index: Int?
    var cellDelegate: ChoreCountsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func choreDoesCountToggled(_ sender: Any) {
        cellDelegate?.choreCountsToggled(checked: doesCountTowardsChoreSwitch.isOn, index: index!)
    }
}
