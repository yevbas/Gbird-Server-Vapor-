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
    @Field(key: "title")
    var title: String
    @Field(key: "content")
    var content: String
    
    @Field(key: "timeInterval")
    var timeInterval: Double?
    @Field(key: "likes")
    var likes: Int?
    @Field(key: "feedbackIDs")
    var feedbackIDs: [String]?
//    @Field(key: "isFavourite")
//    var isFavourite: Bool
    
    init() {}
    
    init(id: UUID? = nil,
         ownerID: UUID,
         title: String,
         content: String,
         
         timeInterval: Double?,
         likes: Int?, /*isFavourite: Bool = false*/
         feedbackIDs: [String]?
    ) {
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.content = content
        self.timeInterval = timeInterval
        self.likes = likes
//        self.isFavourite = isFavourite
        self.feedbackIDs = feedbackIDs
    }
    
}
