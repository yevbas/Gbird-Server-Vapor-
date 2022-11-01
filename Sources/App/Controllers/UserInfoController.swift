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
    func index(req: Request) async throws -> ServerResponse<[UserInfo]> {
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        let allUsersInformation = try await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: allUsersInformation
        )
    }
    
    // /user-info/:userID
    func userInfoByID(req: Request) async throws -> ServerResponse<UserInfo> {
        guard let userID = req.parameters.get("userID"),
              let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        
        let filteredUsersInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == userID }
        
        guard let userInfo = filteredUsersInfo?.first else {
            throw Abort(.notFound)
        }
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: userInfo
        )
    }
}
