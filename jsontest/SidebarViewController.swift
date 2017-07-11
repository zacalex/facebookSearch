//
//  SidebarViewController.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/15/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapHome = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        self.Home.addGestureRecognizer(tapHome)
        
        Home.isUserInteractionEnabled = true
        
        let tapAbout = UITapGestureRecognizer(target: self, action: #selector(handleTapAbout(sender:)))
        
        self.About.addGestureRecognizer(tapAbout)
        
        About.isUserInteractionEnabled = true
        
        let tapFavo = UITapGestureRecognizer(target: self, action: #selector(handleTapFavo(sender:)))
        
        self.Favo.addGestureRecognizer(tapFavo)
        
        Favo.isUserInteractionEnabled = true
    }

    @IBOutlet weak var Home: UIView!
    
    @IBOutlet weak var Favo: UIView!
    
    
    @IBOutlet weak var About: UIView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    @IBAction func tabar(_ sender: Any) {
        print("taptab")
        performSegue(withIdentifier: "sidetest", sender: nil)
    }
    func handleTap(sender: UITapGestureRecognizer) {
        print("tap")
        performSegue(withIdentifier: "sidehome", sender: nil)
    }
    
    func handleTapAbout(sender: UITapGestureRecognizer) {
        print("tapAbout")
        performSegue(withIdentifier: "sideAbout", sender: nil)
    }
    func handleTapFavo(sender: UITapGestureRecognizer) {
        print("tapFavo")
        performSegue(withIdentifier: "sideFavo", sender: nil)
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
