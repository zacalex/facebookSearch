//
//  ResultTableViewCell.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/12/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit
protocol OptionButtonsDelegate{
    func closeFriendsTapped(at index:IndexPath)
}
class ResultTableViewCell: UITableViewCell {
    var title :String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func ChangeFavo(_ sender: UIButton) {
        self.deligate?.closeFriendsTapped(at: indexPath)
    }
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var favo: UIButton!
    
    
    var indexPath: IndexPath!
    var deligate : OptionButtonsDelegate!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
