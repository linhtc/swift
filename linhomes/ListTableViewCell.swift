//
//  ListTableViewCell.swift
//  linhomes
//
//  Created by Leon on 7/20/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconDirect: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
