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
    
    func follow(req: Request) async throws -> Response {
        var response = Response()
        
        if let sql = req.db as? SQLDatabase, let toFollowID = req.parameters.get("toFollowID"), let followerID = req.parameters.get("followerID") {
            
            let folowerInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter { $0.userID.uuidString == followerID }
                .first
            let folowingInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter { $0.userID.uuidString == toFollowID }
                .first
            
            guard let folowerInfo = folowerInfo else {
                response.error = "Can't find follower!"
                return response
            }
            
            guard let folowingInfo = folowingInfo else {
                response.error = "Can't find folowing!"
                return response
            }
            
            guard !folowerInfo.folowingsIDs.contains(toFollowID) else {
                response.error = "Already followed!"
                return response
            }
            
            folowingInfo.folowersIDs.append(followerID)
            folowerInfo.folowingsIDs.append(toFollowID)
            
            try? await folowerInfo.update(on: req.db)
            try? await folowingInfo.update(on: req.db)
            
            response.success = "ok"
            
            return response
        }
        
        response.error = "Error: /follow/:userID"
        return response
    }
    
    func unfollow(req: Request) async throws -> Response {
        var response = Response()
        
        if let sql = req.db as? SQLDatabase,
           let toUnfollowID = req.parameters.get("toUnfollowID"),
           let followerID = req.parameters.get("followerID") {
            
            let folowerInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter { $0.userID.uuidString == followerID }
                .first
            let folowingInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter { $0.userID.uuidString == toUnfollowID }
                .first
            
            guard let folowerInfo = folowerInfo else {
                response.error = "Can't find follower!"
                return response
            }
            
            guard folowerInfo.folowingsIDs.contains(toUnfollowID) else {
                response.error = "You don't follow this user!"
                return response
            }
            
            folowerInfo.folowingsIDs
                .remove(at: folowerInfo.folowingsIDs.firstIndex(of: toUnfollowID) ?? .init())
            folowingInfo?.folowersIDs
                .remove(at: folowingInfo?.folowersIDs.firstIndex(of: followerID) ?? .init())
            
            try? await folowerInfo.update(on: req.db)
            try? await folowingInfo?.update(on: req.db)
            
            response.success = "ok"
            
            return response
        }
        
        response.error = "Error: /unfollow/:userID"
        return response
    }
    
}

