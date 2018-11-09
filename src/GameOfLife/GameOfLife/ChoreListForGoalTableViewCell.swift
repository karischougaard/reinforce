//
//  ChoreListForGoalTableViewCell.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 02/11/2018.
//  Copyright © 2018 Prinsisse. All rights reserved.
//

import UIKit

class ChoreListForGoalTableViewCell: UITableViewCell {


    @IBOutlet weak var choreCountsSwitch: UISwitch!
    @IBOutlet weak var choreNameLabel: UILabel!
    
    var index: Int!
    var cellDelegate: ChoreCountsProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
