//
//  ViewController.swift
//  DemoTwitter
//
//  Created by Morning_Star on 19/08/21.
//

import UIKit
import TwitterKit


class ViewController: UIViewController {
    //    MARK:- Outlets
    @IBOutlet weak var loginBtn: UIButton!
    //    MARK:- Initialize Variables

    //    MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    //    MARK:- SetUI
    func setUI() {
        loginBtn.layer.cornerRadius = 20
    }
    //    MARK:- Button Action
    @IBAction func btnLoginTapped(_ sender: Any) {
        // Twitter SDK login call.
        TWTRTwitter.sharedInstance().logIn(with: self) { (session, error) in
            if let session = session{
                // Save data to user defaults for later use
                UserDefaults.standard.setValue(session.userID, forKey: "user_id")
                UserDefaults.standard.setValue(session.authToken, forKey: "auth_token")
                
                // Navigate user to Home screen
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if let error = error{
                
                //Twitter SDK Login failed
                print("error :\(error.localizedDescription)")
            }
        }
    }

}

