//
//  ResultTabBarViewController.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/13/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit

class ResultTabBarViewController: UITabBarController {
    
    var keyword :String = ""
    var sidebarController : SWRevealViewController? = nil
    
    override func viewDidLoad() {
        
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        print("in tabbar")
        print(keyword)
        
        print(sidebarController as Any)
        
        
        let barViewControllers = self.viewControllers
        
        let user = barViewControllers![0] as! UserResultViewController
        user.keyword = self.keyword
        user.type = "user"
        user.sidebarController = self.sidebarController
        
        let page = barViewControllers![1] as! UserResultViewController
        page.keyword = self.keyword
        page.type = "page"
        
        let event = barViewControllers![2] as! UserResultViewController
        event.keyword = self.keyword
        event.type = "event"
        
        let place = barViewControllers![3] as! UserResultViewController
        place.keyword = self.keyword
        place.type = "place"
        
        let group = barViewControllers![4] as! UserResultViewController
        group.keyword = self.keyword
        group.type = "group"
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
