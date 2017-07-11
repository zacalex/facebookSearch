//
//  testViewController.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/16/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))


        // Do any additional setup after loading the view.
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var open: UIBarButtonItem!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
