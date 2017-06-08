//
//  SubscriptionCell.swift
//  ShearGear
//
//  Created by Kevin on 5/25/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var subscription: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
