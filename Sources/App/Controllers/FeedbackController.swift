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
        feedback.post(use: create)
        feedback.get(":postID", use: feedbacksByPostID)
        feedback.put("like", use: toggleLike)
    }
    
    // feedback/:postID
    func feedbacksByPostID(req: Request) async throws -> ServerResponse<[Feedback]> {
        guard let sql = req.db as? SQLDatabase,
              let postID = req.parameters.get("postID") else {
            throw Abort(.notFound)
        }
        let feedbacks = try await sql.raw("SELECT * FROM postfeedbacks")
            .all(decoding: Feedback.self)
            .filter { $0.postID.uuidString == postID }
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: feedbacks
        )
    }
    
    // feedback
    func create(req: Request) async throws -> ServerResponse<Feedback> {
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest, reason: "No body was provided")
        }
        
        let feedback = try JSONDecoder().decode(Feedback.self, from: Data(buffer: byteBuffer))
        
        feedback.timeInterval = Date().timeIntervalSince1970
        feedback.likes = []
        
        try await feedback.save(on: req.db)

        let post = try await Post.find(feedback.postID, on: req.db)
        
        guard let feedbackID = feedback.id?.uuidString else {
            throw Abort(.notFound)
        }
        
        post?.feedbackIDs.append(feedbackID)
        
        try await post?.update(on: req.db)
                
        return .init(code: HTTPStatus.created.code,
                     message: HTTPStatus.created.reasonPhrase,
                     data: feedback
        )
    }
    
    // PUT feedback/like
    // - userID
    // - feedbackID
    func toggleLike(req: Request) async throws -> ServerResponse<String>  {
        struct Body: Codable {
            let userID, feedbackID: String
        }
                
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest, reason: "No body was provided")
        }
        
        let body = try JSONDecoder().decode(Body.self, from: Data(buffer: byteBuffer))
        
        guard let feedback = try await Feedback.find(UUID(uuidString: body.feedbackID), on: req.db) else {
            throw Abort(.badRequest, reason: "Cant't find feedback with this ID!")
        }
        
        let postWasLikedPreviously = feedback.likes.contains(body.userID)
        
        if postWasLikedPreviously {
            feedback.likes.removeAll(where: { $0 == body.userID } )
        } else {
            feedback.likes.append(body.userID)
        }
        
        try await feedback.update(on: req.db)
            
        return .init(code: HTTPStatus.created.code,
                     message: HTTPStatus.created.reasonPhrase,
                     data: nil
        )
    }
    
}

