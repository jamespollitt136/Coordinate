//
//  HomeTableViewCell.swift
//  coordinate
//
//  Created by Pollitt James on 19/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit

// Custom class for table view
class HomeTableViewCell: UITableViewCell {

    // Outlets for cell UI
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellSubLabel: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
