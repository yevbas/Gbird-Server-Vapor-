//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Vapor
import FluentSQL

struct UserInfoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userInfo = routes.grouped("userinfo")
        userInfo.get(use: index)
        userInfo.get(":userID", use: userInfoByID)
    }
    
    // /user-info
    func index(req: Request) async throws -> [UserInfo] {
        if let sql = req.db as? SQLDatabase {
            let userInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
            return userInfo ?? []
        }
        return []
    }
    
    // /user-info/:userID
    func userInfoByID(req: Request) async throws -> [UserInfo] {
        if let sql = req.db as? SQLDatabase, let userID = req.parameters.get("userID") {
            let userInfo = try? await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter { $0.userID.uuidString == userID }
            return userInfo ?? []
        }
        return []
    }
}
