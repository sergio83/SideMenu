//
//  SliderMenuTableViewCell.swift
//  Menu
//
//  Created by Sergio Cirasa on 1/2/17.
//  Copyright © 2017 Sergio Cirasa. All rights reserved.
//

import UIKit

class SliderMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
