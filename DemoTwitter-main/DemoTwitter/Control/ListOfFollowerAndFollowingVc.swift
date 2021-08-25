//
//  ListOfFollowerAndFollowingVc.swift
//  DemoTwitter
//
//  Created by Morning_Star on 19/08/21.
//

import UIKit
import Alamofire
import ProgressHUD

class ListOfFollowerAndFollowingVc: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    //    MARK:- Outlets
    @IBOutlet weak var mytable:UITableView!
    
    //    MARK:- Initialize Variables
    var page: String! = "-1"
    var flag: Int!
    var arrList: NSMutableArray!
    
    //    MARK:- View Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Register XIB to load in Table
        self.mytable.register(UINib(nibName: "FollowerAndFollowingList", bundle: nil), forCellReuseIdentifier: "FollowerAndFollowingList")
        
        // Clear the arrList
        self.arrList = NSMutableArray.init()
        
        // if Flag is 0 get Follower list Else get Friend list
        if self.flag == 0 {
            self.getallFollower()
        }else{
            self.getallFrienfList()
        }
    }

    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerAndFollowingList", for: indexPath) as! FollowerAndFollowingList
        let dict = self.arrList.object(at: indexPath.row) as? NSDictionary
        cell.lblname.text = dict?.value(forKey: "name") as? String
        cell.lbluser.text = dict?.value(forKey: "screen_name") as? String
        
        cell.imgProfile.layer.cornerRadius = 10
        cell.imgProfile.clipsToBounds = true
        
        let profile_image_url = dict?.value(forKey: "profile_image_url") as? String
        
        do{
            let data = try Data.init(contentsOf: URL.init(string: (profile_image_url ?? ""))!)
            cell.imgProfile.image = UIImage.init(data: data)
        }catch{
            //Error thrown
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Pagination
        let lastElement = self.arrList.count - 1
        if indexPath.row == lastElement {
            
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.mytable {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
                
                // if Flag is 0 get Follower list Else get Friend list
                if self.flag == 0{
                    self.getallFollower()
                }else{
                    self.getallFrienfList()
                }
            }
        }
    }
    
    //MARK:- Api Calling for Friend & Follower list
    func getallFollower()
    {
        let auth_token = UserDefaults.standard.object(forKey: "auth_token") as? String
        
        _ = String.init(format: "Bearer %@", auth_token!)
        let header : HTTPHeaders = HTTPHeaders([
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAACBp8AAAAAAAqDXiIcKpEgzEPFrbnaGOImA1qc4%3DnbY9SlsnTlcWXCSSsOvQjfw77FbuGOaMjzUIvWbEemxCvq50rb",
            "Accept":"application/json"
        ])
        let user_id = UserDefaults.standard.object(forKey: "user_id") as? String
        let str = String.init(format: "https://api.twitter.com/1.1/followers/list.json?user_id=%@&count=10&cursor=%@", user_id!,self.page)
        
        // Show loader
        ProgressHUD.show()
        
        // API Call to get list of follower
        AF.request(str,method: .get,encoding: URLEncoding.default,headers: header,interceptor: nil).response{(responseData) in
            // Hide Loader
            ProgressHUD.dismiss()
            do{
                
                //Data parsing of received API response
                let dict = try JSONSerialization.jsonObject(with: responseData.data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                
                var dataDict = NSMutableDictionary()
                dataDict = (dict as? NSDictionary ?? NSDictionary()).mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
                print(dataDict)
                
                let users = dataDict.value(forKey: "users") as? NSArray
                
                if users!.count > 0{
                    if self.page == "-1"{
                        self.arrList = NSMutableArray.init(array: users!)
                    }else{
                        let temp = NSMutableArray.init(array: users!)
                        for i in (0..<temp.count){
                            let dict = temp.object(at: i) as? NSDictionary
                            self.arrList.add(dict as Any)
                        }
                    }
                    self.mytable.reloadData()
                    self.page = dataDict.value(forKey: "next_cursor_str") as? String
                }else{
                    // No users found
                }
            }catch{
                print(responseData)
            }
        }
    }
    
    
    func getallFrienfList(){
        
        let auth_token = UserDefaults.standard.object(forKey: "auth_token") as? String
        
        _ = String.init(format: "Bearer %@", auth_token!)
        let header : HTTPHeaders = HTTPHeaders([
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAACBp8AAAAAAAqDXiIcKpEgzEPFrbnaGOImA1qc4%3DnbY9SlsnTlcWXCSSsOvQjfw77FbuGOaMjzUIvWbEemxCvq50rb",
            "Accept":"application/json"
        ])
        
        let user_id = UserDefaults.standard.object(forKey: "user_id") as? String
        let str = String.init(format: "https://api.twitter.com/1.1/friends/list.json?user_id=%@&count=10&cursor=%@", user_id!,self.page)
        
        // Show Loader
        ProgressHUD.show()
        
        // API Call to get list of follower
        AF.request(str,method: .get,encoding: URLEncoding.default,headers: header,interceptor: nil).response{(responseData) in
            
            // Hide Loader
            ProgressHUD.dismiss()
            do{
                
                //Parsing data received from API
                let dict = try JSONSerialization.jsonObject(with: responseData.data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                
                var dataDict = NSMutableDictionary()
                dataDict = (dict as? NSDictionary ?? NSDictionary()).mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
                print(dataDict)
                
                let users = dataDict.value(forKey: "users") as? NSArray
                
                if users!.count > 0{
                    self.arrList = NSMutableArray.init(array: users!)
                    self.mytable.reloadData()
                }else{
                    //No users found
                }
            }catch{
                print(responseData)
            }
        }
    }
}
