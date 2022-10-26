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
            
            #warning("Remake from toFollowID -> userinfo id")
            let userInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter {
                    $0.userID.uuidString == followerID
                }
                .first
            
            guard let userInfo = userInfo else {
                response.error = "Can't find follower!"
                return response
            }
            
            userInfo.folowingsIDs.append(toFollowID)
            
            try? await userInfo.save(on: req.db)
            
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
            
            #warning("Remake from toUnfollowID -> userinfo id")
            let userInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter {
                    $0.userID.uuidString == followerID
                }
                .first
            
            guard let userInfo = userInfo else {
                response.error = "Can't find follower!"
                return response
            }
            
            userInfo.folowingsIDs.remove(at: userInfo.folowingsIDs.firstIndex(of: toUnfollowID) ?? .init())
            
            try? await userInfo.save(on: req.db)
            
            response.success = "ok"
            
            return response
        }
        
        response.error = "Error: /unfollow/:userID"
        return response
    }
    
}

