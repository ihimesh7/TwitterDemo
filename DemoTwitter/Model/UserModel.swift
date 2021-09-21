//
//  UserModel.swift
//  DemoTwitter
//
//  Created by Morning_Star on 19/08/21.
//

import Foundation

struct UserModel:Decodable {
    
    //    MARK:- Initialize Variables
    var userName : String?
    var userImage : String?
    var userFollower : Int?
    var userFollowing : Int?
    
    init(user_name: String?,user_image: String?,user_follower: Int?,user_following: Int?) {
        self.userName = user_namez
        self.userImage = user_image
        self.userFollower = user_follower
        self.userFollowing = user_following
    }
}
