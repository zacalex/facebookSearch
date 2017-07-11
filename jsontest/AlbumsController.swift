//
//  AlbumsController.swift
//  jsontest
//
//  Created by Qinjia Huang on 4/13/17.
//  Copyright © 2017 Qinjia Huang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import SwiftSpinner
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class AlbumsController: UIViewController,UITableViewDelegate,UITableViewDataSource, FBSDKSharingDelegate {
    /**
     Sent to the delegate when the share completes without error or cancellation.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter results: The results from the sharer.  This may be nil or empty.
     */
   
    var show: Int = 1
    var idReceiver:String = ""
    var json:JSON = []
    @IBOutlet weak var keyid: UILabel!
    @IBOutlet weak var testtitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath: IndexPath?
    var name :String = ""
    var profile:String = ""
    var type:String = ""
    var defaults = UserDefaults.standard
   
   
    
    @IBOutlet weak var Navigation: UINavigationBar!
    
    func showOptions() {
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Add to favorites", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Add to favorites")
            self.addFavo()
        })
        
        
        let saveAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Share")
            self.fbShare();
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel",style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        
        
        if defaults.object(forKey: self.type) != nil {
            var res :[String:String] = [:]
            res = defaults.dictionary(forKey: self.type)! as! [String : String]
            if res[idReceiver] != nil {
                print("added")
                let removeAction = UIAlertAction(title: "Remove from favorites", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    print("remove to favorites")
                    self.removeFavo()
                })
                optionMenu.addAction(removeAction)
            } else {
                print("no found in favo")
                optionMenu.addAction(deleteAction)
                
            }
        } else {
            print("no found in favo")
            optionMenu.addAction(deleteAction)
            
        }
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        // 5
        self.present(optionMenu, animated: true, completion: nil)

    
    }
       func removeFavo() {
        
        print("in remove favo")
        var res :[String:String] = [:]
        res = defaults.dictionary(forKey: self.type)! as! [String : String]
        res.removeValue(forKey: idReceiver)
        print(res)
        defaults.set(res, forKey: self.type)
        
        if defaults.object(forKey:  self.type + "FavoPic") != nil {

            var pic :[String:String] = [:]
            pic = defaults.dictionary(forKey: self.type+"FavoPic")! as! [String : String]
            pic.removeValue(forKey: idReceiver)
            print(pic)
            defaults.set(pic, forKey: self.type+"FavoPic")
        }
        
        if defaults.object(forKey:  self.type + "order") != nil {
        
            var order:[String] = []
            order = defaults.array(forKey: self.type + "order") as! [String]
            order = order.filter{$0 != idReceiver}
            print(order)
            defaults.set(order, forKey: self.type + "order")
        }
        
        
        
        self.view.showToast("Removed from favoirtes!", position: .bottom, popTime: 5, dismissOnTap: true)
    }
    func addFavo()   {
        print("in add favo")
        if defaults.object(forKey: self.type) == nil {
            let cur:[String:String] = [idReceiver:name]
            defaults.set(cur, forKey: self.type)
            let order = [idReceiver]
            defaults.set(order, forKey: self.type + "order")
            
            
            
        } else {
            var res :[String:String] = [:]
            res = defaults.dictionary(forKey: self.type)! as! [String : String]
            res[idReceiver] = name
            print(res)
            defaults.set(res, forKey: self.type)
            
            if defaults.object(forKey:  self.type + "order") != nil {
                
                var order:[String] = []
                
                order = defaults.array(forKey: self.type + "order") as! [String]
                order.append(idReceiver)
                print(order)
                defaults.set(order, forKey: self.type + "order")
            } else {
            
                let order = [idReceiver]
                defaults.set(order, forKey: self.type + "order")
            }
            
            
        }
        
        if defaults.object(forKey: self.type+"FavoPic") == nil {
            let newPic:[String:String] = [idReceiver: profile]
            defaults.set(newPic, forKey: self.type+"FavoPic")
        }else {
            var pic :[String:String] = [:]
            pic = defaults.dictionary(forKey: self.type+"FavoPic")! as! [String : String]
            pic[idReceiver] = profile
            print(pic)
            defaults.set(pic, forKey: self.type+"FavoPic")
        
        }
        
        self.view.showToast("Added to favorites!", position: .bottom, popTime: 5, dismissOnTap: true)
    }
    
    func fbShare() {
        print("in share")
        print(name)
        print(profile)
        //showFacebookShareDialog(mode: FBSDKShareDialogMode.browser)
        let share = FBSDKShareLinkContent()
        
        share.contentTitle = name
        share.imageURL = NSURL(string: profile)! as URL
        share.contentDescription = "FB Share for CSCI 571"
        
        //支持web 和app
        FBSDKShareDialog.show(from: self, with: share, delegate: self)
    }

    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        NSLog("Photo shared!")
        if results.count == 0{
            self.view.showToast("Photo share cancelled!", position: .bottom, popTime: 5, dismissOnTap: true)
        } else {
            self.view.showToast("Photo shared!", position: .bottom, popTime: 5, dismissOnTap: true)

        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        // TODO: Take action if sharing failed
        if let err = error{
            NSLog("Photo share failed! - \(err)")
            self.view.showToast("Photo share failed!", position: .bottom, popTime: 5, dismissOnTap: true)
            
        }
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        //TODO: Take action if user cancelled sharing of photos
        NSLog("Photo share cancelled!")
        self.view.showToast("Photo share cancelled!", position: .bottom, popTime: 5, dismissOnTap: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let loginButton = FBSDKLoginButton()
//        view.addSubview(loginButton)
//        loginButton.frame = CGRect.init(x: 16, y: 230, width: view.frame.width - 32, height: 50)
        
        print("in albumsController")
        print(idReceiver)
        print(name)
        print(profile)
        SwiftSpinner.show(duration: 2.0, title : "Loading data...")
        let parameters: Parameters = ["id" : idReceiver, "type" : "album"]
        let urlTo = "http://sample-env.35jfmtj3kn.us-west-2.elasticbeanstalk.com"
        Alamofire.request(urlTo, parameters: parameters, encoding: URLEncoding.default).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let jsonData = response.result.value!
//                print(jsonData)
                //
                let dataFromString = String(describing: jsonData).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = JSON(dataFromString!)
                //                print(json[self.type]["data"])
//                print(json)
                self.json = json["albums"]["data"]
                print(self.json)
                print("checkJson")
                print(self.json[0]["name"])
                //                super.viewDidLoad()
                
                if (self.json.count == 0) {
                    print("none")
                    
                    
                    let nodata = UILabel(frame: CGRect.init(x: 16, y: 100, width: 200, height: 40))
                    nodata.center = CGPoint.init(x: 160, y: 284)
                    nodata.textAlignment = NSTextAlignment.center
                    nodata.text = "No data found."
                    self.view.addSubview(nodata)
                } else {
                    self.tableView.isHidden = false;
                    

                }
                self.tableView.reloadData()
                SwiftSpinner.hide()

            } else{
                print("fail")
//                super.viewDidLoad()
            }
            
        }        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView()
       
        let options = UIBarButtonItem.init(image: UIImage.init(named: "options"), style: .plain, target: self, action: #selector(AlbumsController.showOptions))
//        Navigation.backItem?.setLeftBarButton(leftButton, animated: true)
        
       // backitom.action = #selector(AlbumsController.back(_:))
        tabBarController?.navigationItem.title = "Details"
        tabBarController?.navigationItem.setRightBarButton(options, animated: true)
        tabBarController?.navigationItem.leftBarButtonItem?.title = "Results"
        
        let backbutton = UIBarButtonItem.init()
        backbutton.title = "Results"
        tabBarController?.navigationController?.navigationBar.topItem?.backBarButtonItem = backbutton
        tabBarController?.navigationController?.view.backgroundColor = UIColor.white

           
    }
    
  
    @IBOutlet weak var navigationitem: UINavigationItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.json.count == 0 {
            self.tableView.isHidden = true
        }
        return self.json.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumcell", for: indexPath) as! AlbumTableViewCell
        
        cell.title?.text = String(describing: self.json[indexPath.row]["name"])
        
        cell.first?.sd_setImage(with: URL(string: String(describing: self.json[indexPath.row]["photos"]["data"][0]["picture"])))
    
        cell.second?.sd_setImage(with: URL(string: String(describing: self.json[indexPath.row]["photos"]["data"][1]["picture"])))
        
        cell.first.autoresizingMask = UIViewAutoresizing.flexibleWidth
        cell.first.contentMode = UIViewContentMode.scaleAspectFit
        cell.second.autoresizingMask = UIViewAutoresizing.flexibleWidth
        cell.second.contentMode = UIViewContentMode.scaleAspectFit

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath{
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumTableViewCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumTableViewCell).ignoreFrameChanges()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if tableView != nil {
            for cell in tableView.visibleCells as! [AlbumTableViewCell] {
                cell.ignoreFrameChanges()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
//            print(self.json[indexPath.row]["photos"]["data"][0]["picture"])
//            print(self.json[indexPath.row]["photos"]["data"][1]["picture"])
//            if (self.json[indexPath.row]["photos"]["data"][1]["picture"] == JSON.null) && (self.json[indexPath.row]["photos"]["data"][0]["picture"] != JSON.null) {
//                print("here")
//                return 350
//            } else if (self.json[indexPath.row]["photos"]["data"][1]["picture"] == JSON.null) && (self.json[indexPath.row]["photos"]["data"][0]["picture"] == JSON.null)  {
//                print("here0")
//                return AlbumTableViewCell.defaultHeight
//            }
            return AlbumTableViewCell.expandHeight
        } else {
            return AlbumTableViewCell.defaultHeight
        
        }
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
