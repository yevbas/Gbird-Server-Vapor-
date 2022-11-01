//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Vapor
import FluentSQL

struct FollowersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.put("follow", ":toFollowID", ":followerID", use: follow)
        routes.put("unfollow", ":toUnfollowID", ":followerID", use: unfollow)
    }
    
    func follow(req: Request) async throws -> ServerResponse<String> {
        guard let sql = req.db as? SQLDatabase,
              let toFollowID = req.parameters.get("toFollowID"),
              let followerID = req.parameters.get("followerID") else {
            throw Abort(.notFound)
        }
            
        let folowerInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == followerID }
            .first
        let folowingInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == toFollowID }
            .first
        
        guard let folowerInfo = folowerInfo else {
            throw Abort(.badRequest, reason: "Can't find follower")
        }
        
        guard let folowingInfo = folowingInfo else {
            throw Abort(.badRequest, reason: "Can't find folowing")
        }
        
        guard !folowerInfo.folowingsIDs.contains(toFollowID) else {
            throw Abort(.badRequest, reason: "Already followed")
        }
        
        folowingInfo.folowersIDs.append(followerID)
        folowerInfo.folowingsIDs.append(toFollowID)
        
        try? await folowerInfo.update(on: req.db)
        try? await folowingInfo.update(on: req.db)
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: nil
        )
    }
    
    func unfollow(req: Request) async throws -> ServerResponse<String> {
        guard let sql = req.db as? SQLDatabase,
              let toUnfollowID = req.parameters.get("toUnfollowID"),
              let followerID = req.parameters.get("followerID") else {
            throw Abort(.notFound)
        }
        
        let folowerInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == followerID }
            .first
        let folowingInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == toUnfollowID }
            .first
        
        guard let folowerInfo = folowerInfo else {
            throw Abort(.badRequest, reason: "Can't find follower")
        }
        
        guard folowerInfo.folowingsIDs.contains(toUnfollowID) else {
            throw Abort(.badRequest, reason: "You don't follow this user")
        }
        
        folowerInfo.folowingsIDs
            .remove(at: folowerInfo.folowingsIDs.firstIndex(of: toUnfollowID) ?? .init())
        folowingInfo?.folowersIDs
            .remove(at: folowingInfo?.folowersIDs.firstIndex(of: followerID) ?? .init())
        
        try? await folowerInfo.update(on: req.db)
        try? await folowingInfo?.update(on: req.db)
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: nil
        )
    }
    
}

