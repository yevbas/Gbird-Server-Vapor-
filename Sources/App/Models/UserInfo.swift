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
    @Field(key: "postsIDs")
    var postsIDs: [String]
    @Field(key: "folowingsIDs")
    var folowingsIDs: [String]
    
    // folowersCount
    // folowingsCount
    
    init() {}
    
    init(id: UUID? = nil,
         userID: UUID,
         postsIDs: [String] = [],
         folowingsIDs: [String] = []
    ){
        self.id = id
        self.userID = userID
        self.postsIDs = postsIDs
        self.folowingsIDs = folowingsIDs
    }
    
}

