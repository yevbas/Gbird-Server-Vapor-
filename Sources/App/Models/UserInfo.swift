//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Fluent
import Vapor

final class UserInfo: Model, Content {
    
    static var schema: String = "userinfo"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "userID")
    var userID: UUID
    @Field(key: "userName")
    var userName: String
    @Field(key: "postsIDs")
    
    var postsIDs: [String]
    @Field(key: "folowingsIDs")
    var folowingsIDs: [String]
    @Field(key: "folowersIDs")
    var folowersIDs: [String]
    @Field(key: .imageURL)
    var imageURL: String?
        
    init() {}
    
    init(userID: UUID, userName: String) {
        self.userID = userID
        self.userName = userName
        
        self.postsIDs = []
        self.folowingsIDs = []
        self.folowersIDs = []
        self.imageURL = nil
    }
    
}

