//
//  ManageRideCell.swift
//  List
//
//  Created by Maria Todd on 7/19/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit

class ManageRideCell: UITableViewCell {
    
    @IBOutlet weak var fromLabel: UILabel!
    
    
    @IBOutlet weak var toLabel: UILabel!
    
    
    @IBOutlet weak var newRequestAlert: UIImageView!
    
    
    @IBOutlet weak var myPic: UIImageView!
    
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
