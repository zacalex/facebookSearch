//
//  DetailViewController.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/13/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit

class DetailViewController: UITabBarController {
    var keyId:String = ""
    var name :String = ""
    var profile:String = ""
    var type:String=""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("detialcontroller")
        print(keyId)
        print(name)
        print(profile)
        
        let barViewControllers = self.viewControllers
        
        let albums = barViewControllers![0] as! AlbumsController
        albums.idReceiver = keyId
        albums.name = self.name
        albums.profile = self.profile
        albums.type = self.type
        
        
        let posts = barViewControllers![1] as! PostsController
        posts.idReceiver = keyId
        posts.name = self.name
        posts.profile = self.profile
        posts.type = self.type
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
