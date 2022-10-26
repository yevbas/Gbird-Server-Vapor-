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
    func enter(req: Request) async throws -> Response {
        var response = Response()
        
        if let sql = req.db as? SQLDatabase {
            let users = try await sql.raw("SELECT * FROM users")
                .all(decoding: User.self)
            
            guard let byteBuffer = req.body.data else {
                response.error = "No body was provided!"
                return response
            }
            let authCreds = try JSONDecoder().decode(AuthCollection.AuthCredentials.self, from: Data(buffer: byteBuffer))
            
            guard let user = users.first(where: { $0.email == authCreds.email && $0.password == authCreds.password }) else {
                response.error = "Email or password is incorrect!"
                return response
            }
            
            response.success = user.id?.uuidString
            return response
        }
        
        return response
    }
}
