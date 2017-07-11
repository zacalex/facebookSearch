//
//  PostsController.swift
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

class PostsController: UIViewController,UITableViewDelegate,UITableViewDataSource,FBSDKSharingDelegate {
    
    var idReceiver:String = ""
    var name :String = ""
    var profile:String = ""
    var type:String = ""
    var json:JSON = []
    var defaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(idReceiver)
        SwiftSpinner.show(duration: 2.0, title : "Loading data...")
        let parameters: Parameters = ["id" : idReceiver, "type" : "post"]
        let urlTo = "http://sample-env.35jfmtj3kn.us-west-2.elasticbeanstalk.com"
        Alamofire.request(urlTo, parameters: parameters, encoding: URLEncoding.default).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let jsonData = response.result.value!
                
                let dataFromString = String(describing: jsonData).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = JSON(dataFromString!)
                                self.json = json["posts"]["data"]
                print(self.json)
                print("checkJson in post")
                print(self.json[0]["message"])
                
                
                if (self.json.count == 0) {
                    print("none")
                    
                    self.tableView.isHidden = true;
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
            
        }        // Do any additi
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension 
        tableView.estimatedRowHeight = 140
        let options = UIBarButtonItem.init(image: UIImage.init(named: "options"), style: .plain, target: self, action: #selector(AlbumsController.showOptions))
        //        Navigation.backItem?.setLeftBarButton(leftButton, animated: true)
        
        // backitom.action = #selector(AlbumsController.back(_:))
        tabBarController?.navigationItem.title = "Details"
        tabBarController?.navigationItem.setRightBarButton(options, animated: true)
        let backbutton = UIBarButtonItem.init()
        backbutton.title = "Results"
        tabBarController?.navigationController?.navigationBar.topItem?.backBarButtonItem = backbutton
        tabBarController?.navigationController?.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! PostTableViewCell
        if self.json[indexPath.row]["message"] != JSON.null {
            cell.title?.text = String(describing: self.json[indexPath.row]["message"])
        } else {
            cell.title?.text = "no data found"
        }
        
        
        
        
        
        
        cell.profilePhoto.sd_setImage(with: URL(string: self.profile))
        var dateString = ""
        dateString = String(describing: self.json[indexPath.row]["created_time"])
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+zzzz"
        dataFormatter.locale = Locale.init(identifier: "en_US")
        
        if(dateString != "null"){
            
            print(dateString)
            let dataObj = dataFormatter.date(from: dateString)
            dataFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
            let date = dataFormatter.string(from: dataObj!)
            print(date)
            cell.timestamp?.text = date

        }
        
        //        dataFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        

        return cell
    }
    


    
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
