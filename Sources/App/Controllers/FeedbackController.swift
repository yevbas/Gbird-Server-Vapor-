//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 31/10/2022.
//

import Vapor
import Fluent
import FluentSQL

struct FeedbackCollection: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let feedback = routes.grouped("feedback")
//        auth.post("login", use: enter)
        feedback.post(use: create)
    }
    
    // feedback
    func create(req: Request) async throws -> Response {
        var response = Response()
        
        guard let byteBuffer = req.body.data else {
            response.error = "No body was provided!"
            return response
        }
        let feedback = try JSONDecoder().decode(Feedback.self, from: Data(buffer: byteBuffer))
        
        feedback.timeInterval = Date().timeIntervalSince1970
        feedback.likes = []
        
        try await feedback.save(on: req.db)

        let post = try await Post.find(feedback.postID, on: req.db)
        
        guard let feedbackID = feedback.id?.uuidString else {
            response.error = "Error: __"
            return response
        }
        
        post?.feedbackIDs?.append(feedbackID)
        
        try await post?.update(on: req.db)
        
        return response
    }
    
}

