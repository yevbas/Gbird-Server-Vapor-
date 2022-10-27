//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Fluent
import Vapor

final class Post: Model, Content {
    static var schema: String = "posts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "ownerID")
    var ownerID: UUID
    @Field(key: "ownerName")
    var ownerName: String
    @Field(key: "content")
    var content: String
    
    @Field(key: "timeInterval")
    var timeInterval: Double?
    @Field(key: "likes")
    var likes: Int?
    @Field(key: "feedbackIDs")
    var feedbackIDs: [String]?
    
    init() {}
    
    init(id: UUID? = nil,
         ownerID: UUID,
         ownerName: String,
         content: String,
         
         timeInterval: Double = Date().timeIntervalSince1970,
         likes: Int = 0,
         feedbackIDs: [String] = []
    ) {
        self.id = id
        self.ownerID = ownerID
        self.ownerName = ownerName
        self.content = content
        self.timeInterval = timeInterval
        self.likes = likes
        self.feedbackIDs = feedbackIDs
    }
    
}
