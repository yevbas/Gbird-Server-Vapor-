//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 31/10/2022.
//

import Fluent
import Vapor

final class Feedback: Model, Content {
    static var schema: String = "postfeedbacks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "ownerID")
    var ownerID: UUID
    @Field(key: "postID")
    var postID: UUID
    @Field(key: "ownerName")
    var ownerName: String
    @Field(key: "feedback")
    var feedback: String
    @Field(key: "timeInterval")
    var timeInterval: Double?
    @Field(key: "likes")
    var likes: [String]?
    
    init() {}
    
    init(id: UUID? = nil,
         ownerID: UUID,
         postID: UUID,
         ownerName: String,
         feedback: String,
         timeInterval: Double = Date().timeIntervalSince1970,
         likes: [String] = []
    ) {
        self.id = id
        self.ownerID = ownerID
        self.postID = postID
        self.ownerName = ownerName
        self.feedback = feedback
        self.timeInterval = timeInterval
        self.likes = likes
    }
    
}
