//
//  AlbumTableViewCell.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/13/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var second: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var expandHeight : CGFloat{ get {return 450}}
    class var defaultHeight : CGFloat{ get {return 35}}
    var frameAdded = false
    
    func checkHeight() {
        first.isHidden = (frame.size.height < AlbumTableViewCell.expandHeight)
    }
    
    func watchFrameChanges() {
        if(!frameAdded){
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            frameAdded = true
        }
    }
    func ignoreFrameChanges(){
        if(frameAdded){
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }


}
