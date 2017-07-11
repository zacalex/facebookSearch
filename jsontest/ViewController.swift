//
//  ViewController.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/12/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import SwiftSpinner
import EasyToast

class ViewController: UIViewController {
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view, typically from a nib.
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        print(self.revealViewController())
    
        
        
    }
    

    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var keyword: UITextField!
    
    @IBAction func Clear(_ sender: UIButton) {
        keyword.text = nil
    }
    
    @IBAction func Search(_ sender: UIButton) {
        
        if(keyword.text != ""){
            print(keyword.text!)
            self.performSegue(withIdentifier: "search", sender: nil)

        } else {
            print("empty")
            self.view.showToast("Enter a valid query", position: .bottom, popTime: 5, dismissOnTap: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail: ResultTabBarViewController = segue.destination as! ResultTabBarViewController
        detail.keyword = keyword.text!
        detail.sidebarController = self.revealViewController()
        
        
    }


}

