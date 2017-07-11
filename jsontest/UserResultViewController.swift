//
//  UserResultViewController.swift
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

class UserResultViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var Nav: UINavigationBar!
    var keyword : String = ""
    var type : String = ""
    let locationManager = CLLocationManager();
    var lat:String = ""
    var lon:String = ""
    var json: JSON = ""
    
    var preURL:String = ""
    var nextURL:String = ""
    var res :[String:String] = [:]
    var pic :[String:String] = [:]
    var order :[String] = []
    
    var defaults = UserDefaults.standard
    var sidebarController : SWRevealViewController? = nil



    @IBOutlet weak var ResultTable: UITableView!
    
    @IBOutlet weak var open: UIBarButtonItem!
        
    @IBOutlet weak var Pre: UIButton!
    
    @IBOutlet weak var Next: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.object(forKey: self.type) != nil {
            res = defaults.dictionary(forKey: self.type)! as! [String : String]
            print(res)
            
        }
        
        if defaults.object(forKey:  self.type+"FavoPic") != nil {
            pic = defaults.dictionary(forKey: self.type+"FavoPic")! as! [String : String]
            print(pic)
        
        }
        
        if defaults.object(forKey:  self.type + "order") != nil {
            
            order = defaults.array(forKey: self.type + "order") as! [String]
            print(order)
        }
        
        
        
        ResultTable.reloadData()
        print("table should reload")
    }
    
    override func viewDidLoad() {
        

//        Pre.setTitleColor(UIColor.gray, for: UIControlState.normal)
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        print("userresultviewcontroller")
        print(sidebarController as Any)
        print(keyword)
        
        
        if defaults.object(forKey: self.type) != nil {
            res = defaults.dictionary(forKey: self.type)! as! [String : String]
            print(res)
            
        }

        
        if(keyword == "") {
            print("here")
            if defaults.object(forKey:  "FavoPic") != nil {

            pic = defaults.dictionary(forKey: "FavoPic")! as! [String : String]
            print(pic)
            }
            
            if defaults.object(forKey:  self.type + "order") != nil {
                
                order = defaults.array(forKey: self.type + "order") as! [String]
                print(order)
            }
            self.Next.isEnabled = false
            
        } else {
            SwiftSpinner.show(duration: 2.0, title : "Loading data...")
            if(CLLocationManager.locationServicesEnabled()){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
        
        ResultTable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
//        open.target = sidebarController
//        open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let menu = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .plain, target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        //        Navigation.backItem?.setLeftBarButton(leftButton, animated: true)
        
        // backitom.action = #selector(AlbumsController.back(_:))
        tabBarController?.navigationItem.title = "Search Results"
        tabBarController?.navigationItem.setLeftBarButton(menu, animated: true)
        if keyword == "" {
        print("here to chagne")
        self.ResultTable.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 410)
        }
//        self.ResultTable.frame = CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)

        
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        lon = String(userLocation.coordinate.longitude)
        lat = String(userLocation.coordinate.latitude)
        print(lon)
        print(lat)
        print(keyword)
        keyword = keyword.trimmingCharacters(in: CharacterSet.whitespaces).replacingOccurrences(of: " ", with: "%20")
        let parameters: Parameters = ["kw" : keyword, "lat" : lat, "lon" : lon]
        let urlTo = "http://sample-env.35jfmtj3kn.us-west-2.elasticbeanstalk.com"
        Alamofire.request(urlTo, parameters: parameters, encoding: URLEncoding.default).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let jsonData = response.result.value!
                //
                let dataFromString = String(describing: jsonData).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = JSON(dataFromString!)
//                print(json[self.type]["data"])
                self.json = json[self.type]["data"]
//                print(self.json)
//                print(self.json.count)
//                print(self.json[0]["picture"]["data"]["url"])
//                print(self.json[0]["id"])
                let paging = json[self.type]["paging"]
                print(paging)
                
                
                if paging["next"].exists(){
                    self.nextURL = String(describing: paging["next"])
                }
                if paging["previous"].exists(){
                    self.preURL = String(describing: paging["previous"])
                } else {
                
                    print("no previous")
                    self.Pre.setTitleColor(UIColor.gray, for: UIControlState.normal)
                    self.Pre.titleLabel?.textColor = UIColor.gray
                    
                }
                
                
                self.loadView()
                SwiftSpinner.hide()
                
            } else{
                print("fail")
            }
            
        }
        locationManager.stopUpdatingLocation()
        print("stop")
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if keyword == "" {
            if res.count == 0 {
                ResultTable.isHidden = true
                let nodata = UILabel(frame: CGRect.init(x: 16, y: 100, width: 200, height: 40))
                nodata.center = CGPoint.init(x: 160, y: 284)
                nodata.textAlignment = NSTextAlignment.center
                nodata.text = "No data found."
                self.view.addSubview(nodata)
            }
            return res.count
        } else {
        
            return self.json.count
        }
    }
    

    var idToPass:String?
    var nameToPass:String?
    var profileToPass:String?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultTableViewCell
        
        if keyword == "" {
            let id = order[indexPath.row]
            cell.name?.text = res[id]
            let url = pic[id]
            if(url != nil) {
                cell.profile?.sd_setImage(with: URL(string: url!))
                cell.favo.setImage(UIImage(named: "filled"), for: UIControlState.normal)
            }
            
            
        } else {
            cell.name?.text = String(describing: self.json[indexPath.row]["name"])
            //        cell.name?.text = String(describing: self.json[indexPath.row]["name"])
            cell.profile?.sd_setImage(with: URL(string: String(describing: self.json[indexPath.row]["picture"]["data"]["url"])))
            if res.count > 0{
                if res[String(describing: self.json[indexPath.row]["id"])] != nil {
                    print(String(describing: self.json[indexPath.row]["name"]) + " is in favo")
                    cell.favo.setImage(UIImage(named: "filled"), for: UIControlState.normal)
                } else {
                    print(String(describing: self.json[indexPath.row]["name"]) + " is not in favo")
                    cell.favo.setImage(UIImage(named: "empty"), for: UIControlState.normal)
                }
            }
        }
        
        
        
//        performSegue(withIdentifier: "detail", sender: self)
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here to send")
        print(indexPath.row)
        if(keyword == "") {
            let id = order[indexPath.row]
            idToPass = id
            nameToPass = res[id]
            profileToPass = pic[id]
        } else {
        
            idToPass = String(describing: self.json[indexPath.row]["id"])
            nameToPass = String(describing: self.json[indexPath.row]["name"])
            profileToPass = String(describing: self.json[indexPath.row]["picture"]["data"]["url"])

        }
        

        print(idToPass!)
        performSegue(withIdentifier: "detail", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("here for segue")
        if (segue.identifier == "detail") {
            // initialize new view controller and cast it as your view controller
            print(idToPass!)
            let viewController = segue.destination as! DetailViewController
            // your new view controller should have property that will store passed value
            viewController.keyId = idToPass!
//            viewController.name = nameToPass!
            
            if nameToPass == nil {
               viewController.name = ""
            } else {
                viewController.name = nameToPass!
                
            }
            if profileToPass == nil {
                viewController.profile = ""
            } else {
                viewController.profile = profileToPass!

            }
            viewController.type = self.type
        }
    }
    
    @IBAction func Previous(_ sender: UIButton) {
        SwiftSpinner.show(duration: 2.0, title : "Loading data...")
//        sender.setTitleColor(UIColor.gray, for: UIControlState.normal)
        print("previous")
        Alamofire.request(preURL,encoding: URLEncoding.default).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let jsonData = response.result.value!
                
                
                let json = JSON(jsonData)

                self.json = json["data"]

                let paging = json["paging"]
                
                
                if paging["next"].exists(){
                    self.nextURL = String(describing: paging["next"])
                    self.Next.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: UIControlState.normal)
                    self.Next.isEnabled = true
                }
                if paging["previous"].exists(){
                    self.preURL = String(describing: paging["previous"])
                    sender.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: UIControlState.normal)
                }else {
                    sender.setTitleColor(UIColor.gray, for: UIControlState.normal)
                    sender.isEnabled = false
                }
                
                if self.ResultTable != nil{
                    self.ResultTable.isHidden = false
                
                    self.ResultTable.reloadData()
                    
                }                
                SwiftSpinner.hide()
                
            } else{
                print("fail")
            }
        }

    }
    
    
    @IBAction func Next(_ sender: UIButton) {
        SwiftSpinner.show(duration: 2.0, title : "Loading data...")

        print("next")
        print(nextURL)
        Alamofire.request(nextURL,encoding: URLEncoding.default).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let jsonData = response.result.value!
                
        
                let json = JSON(jsonData)
    
                self.json = json["data"]
                print(self.json)
     
                let paging = json["paging"]
                

                if paging["next"].exists(){
                    self.nextURL = String(describing: paging["next"])
                    sender.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: UIControlState.normal)
                    sender.isEnabled = true;
                }else {
                    sender.setTitleColor(UIColor.gray, for: UIControlState.normal)
                    sender.isEnabled = false
                }
    
                if paging["previous"].exists(){
                    self.preURL = String(describing: paging["previous"])
                    self.Pre.isEnabled = true
                    self.Pre.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: UIControlState.normal)
                    
                }
                
                if self.ResultTable != nil{
                    if self.json.count == 0 {
                        self.ResultTable.isHidden = true
//                        let nodata = UILabel(frame: CGRect.init(x: 16, y: 100, width: 200, height: 40))
//                        nodata.center = CGPoint.init(x: 160, y: 284)
//                        nodata.textAlignment = NSTextAlignment.center
//                        nodata.text = "No data found."
//                        self.view.addSubview(nodata)
                    } else {
                    
                        self.ResultTable.isHidden = false
                        
                    }
                    
                    self.ResultTable.reloadData()
                    
                }
                
                SwiftSpinner.hide()
                
            } else{
                print("fail")
            }
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
