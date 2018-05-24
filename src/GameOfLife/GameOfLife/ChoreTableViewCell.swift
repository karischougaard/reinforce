//
//  ChoreTableViewCell.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 14/04/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit

class ChoreTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
