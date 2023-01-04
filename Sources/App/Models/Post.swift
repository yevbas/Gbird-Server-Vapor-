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
    var timeInterval: Double
    @Field(key: "likes")
    var likes: [String]
    @Field(key: "feedbackIDs")
    var feedbackIDs: [String]
    @Field(key: .imageURL)
    var imageURL: String?
    
    init() {}
    
    init(ownerID: UUID, ownerName: String, content: String) {
        self.ownerID = ownerID
        self.ownerName = ownerName
        self.content = content
        
        self.timeInterval = Date().timeIntervalSince1970
        self.likes = []
        self.feedbackIDs = []
    }
    
}
