//
//  RouteListTableViewCell.swift
//  MapsIntagration
//
//  Created by omnipro2 on 15/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

class RouteListTableViewCell: UITableViewCell {

    @IBOutlet weak var tripId: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
