//
//  HomeViewController.swift
//  DemoTwitter
//
//  Created by Morning_Star on 19/08/21.
//

import UIKit
import TwitterKit
import Alamofire
import ProgressHUD

class HomeViewController: UIViewController {
    
    //    MARK:- Outlets
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserFollower: UILabel!
    @IBOutlet weak var lblUserFollowing: UILabel!
    @IBOutlet weak var follwerView: UIView!
    @IBOutlet weak var follwingView: UIView!
    
    //    MARK:- Initialize Variables
    var user_id = String()
    var UserData : UserModel? = nil
    
    
    //    MARK:- View Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setUI()
        getUserInfo()
    }
    
    //MARK:- SetUI
    func setUI(){
        imgUser.layer.cornerRadius = 40.0
        imgUser.clipsToBounds = true
        follwerView.layer.borderWidth = 0.3
        follwerView.layer.borderColor = UIColor.black.cgColor
        follwingView.layer.borderWidth = 0.3
        follwingView.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: API Call to get the user detail
    func getAllData() {
        _ = UserDefaults.standard.object(forKey: "auth_token") as? String
        
        let header : HTTPHeaders = HTTPHeaders([
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAACBp8AAAAAAAqDXiIcKpEgzEPFrbnaGOImA1qc4%3DnbY9SlsnTlcWXCSSsOvQjfw77FbuGOaMjzUIvWbEemxCvq50rb",
            "Accept":"application/json"
        ])
        
        let user_id = UserDefaults.standard.object(forKey: "user_id") as? String
        let str = String.init(format: "https://api.twitter.com/1.1/users/show.json?user_id=%@", (user_id) ?? "")
        
        //API call with alamofire
        AF.request(str,method: .get,encoding: URLEncoding.default,headers: header,interceptor: nil).response{(responseData) in
            do{
                ProgressHUD.show()
                
                let dict = try JSONSerialization.jsonObject(with: responseData.data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                
                var dataDict = NSMutableDictionary()
                dataDict = (dict as? NSDictionary ?? NSDictionary()).mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
                print(dataDict)
                
                let username = dataDict.value(forKey: "screen_name") as? String ?? "NA"
                let userimage = dataDict.value(forKey: "profile_image_url") as? String ??  "NA"
                let followingcount = dataDict.value(forKey: "followers_count") as? Int ?? 0
                let friendsCount = dataDict.value(forKey: "friends_count") as? Int ?? 0
                
                self.UserData = UserModel(user_name: username, user_image: userimage, user_follower: followingcount, user_following: friendsCount)
                
                self.lblUsername.text   = self.UserData?.user_name
                self.lblUserFollower.text  = "\(self.UserData?.user_follower ?? 0)"
                self.lblUserFollowing.text = "\(self.UserData?.user_following ?? 0)"
                ProgressHUD.dismiss()
            }catch{
                print(responseData)
            }
        }
        
    }
    
    //MARK:- Get User details
    func getUserInfo(){
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let twitterClient = TWTRAPIClient(userID: userID)
            twitterClient.loadUser(withID: userID ) {(user, error) in
                self.user_id = userID
                self.getAllData()
                if user != nil {
                    
                    do {
                        let data = try Data.init(contentsOf: URL.init(string: (user?.profileImageURL ?? ""))!)
                        self.imgUser.image = UIImage.init(data: data)
                    } catch (let exception) {
                        print(exception)
                    }
                    self.lblUsername.text = user?.screenName ?? ""
                }
            }
        }
    }
    
    //    MARK:- Button Action
    //Logout
    @IBAction func btnLogoutTapped(_ sender: Any) {
        // Logging out the user if logged in
        for session in TWTRTwitter.sharedInstance().sessionStore.existingUserSessions() {
            if let session = session as? TWTRSession {
                TWTRTwitter.sharedInstance().sessionStore.logOutUserID(session.userID)
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).isLogin(login: false)
    }
    
    //following
    @IBAction func btnFollowingClk(_ sender: UIButton) {
        
        
        //Navigate user to list of followers and following
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListOfFollowerAndFollowingVc") as! ListOfFollowerAndFollowingVc
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.flag = 1
        self.present(vc, animated: true, completion: nil)
        
    }
    //followers
    @IBAction func btnFollowersClk(_ sender: UIButton) {
     
        //Navigate user to list of followers and following
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListOfFollowerAndFollowingVc") as! ListOfFollowerAndFollowingVc
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.flag = 0
        self.present(vc, animated: true, completion: nil)
    }
    
}
