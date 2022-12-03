//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Vapor
import Fluent
import FluentSQL

struct AuthCollection: RouteCollection {
    
    struct AuthCredentials: Codable {
        let email: String
        let password: String
    }
    
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: enter)
    }
    
    // auth/login
    func enter(req: Request) async throws -> ServerResponse<UserInfo> {
        guard let sql = req.db as? SQLDatabase else  {
            throw Abort(.notFound)
        }
        let users = try await sql.raw("SELECT * FROM users")
            .all(decoding: User.self)
        
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest, reason: "No body was provided")
        }
        let authCreds = try JSONDecoder().decode(AuthCollection.AuthCredentials.self, from: Data(buffer: byteBuffer))
        
        guard let user = users.first(where: { $0.email == authCreds.email && $0.password == authCreds.password }) else {
            throw Abort(.badRequest, reason: "Email or password is incorrect")
        }
        
        let filteredUserInfo = try await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID == user.id }
        
        guard let userInfo = filteredUserInfo.first else {
            throw Abort(.notFound)
        }
        
        return .init(code: HTTPStatus.accepted.code,
                     message: HTTPStatus.accepted.reasonPhrase,
                     data: userInfo
        )
    }
}
