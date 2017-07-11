//
//  PostTableViewCell.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/13/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var timestamp: UILabel!
}
