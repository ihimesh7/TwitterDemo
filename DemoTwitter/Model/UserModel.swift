//
//  UserModel.swift
//  DemoTwitter
//
//  Created by Morning_Star on 19/08/21.
//

import Foundation

struct UserModel:Decodable {
    
    //    MARK:- Initialize Variables
    var user_name : String?
    var user_image : String?
    var user_follower : Int?
    var user_following : Int?
    
    init(user_name: String?,user_image: String?,user_follower: Int?,user_following: Int?) {
        self.user_name = user_name
        self.user_image = user_image
        self.user_follower = user_follower
        self.user_following = user_following
    }
}
