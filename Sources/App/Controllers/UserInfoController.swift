//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Vapor
import FluentSQL

//struct CommonHeadersMiddleware: Middleware {
//    func respond(to request: Vapor.Request, chainingTo next: Vapor.Responder) -> NIOCore.EventLoopFuture<Vapor.Response> {
//
//        next.respond(to: request).map {
//            request.headers.add(name: "<name>", value: "<value>")
//            return $0
//        }
//    }
//}

struct UserInfoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userInfo = routes.grouped("userinfo")
        userInfo.get(use: index)
        userInfo.get(":userID", use: userInfoByID)
        
        userInfo.put(":userID", "delete-image", use: deleteImage)
        userInfo.put(":userID", "upload-image", use: uploadImage)
    }
    
    // userinfo/:userID/upload-image
    // File:
    // -filename: String
    // -data: Data
    func uploadImage(req: Request) async throws -> ServerResponse<UserInfo> {
        
        guard let userID = req.parameters.get("userID"),
              let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        
        let file = try req.content.decode(File.self)
        
        let filteredUsersInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == userID }
        
        guard let userInfo = filteredUsersInfo?.first else {
            throw Abort(.notFound)
        }
        
        let uploadPath = req.application.directory.publicDirectory + "users-images/"
        let fileName =
        "img-profile-"
        + userInfo.userID.uuidString.lowercased()
        + (file.extension == nil ? "" : "." + file.extension!)
        
        try await req.fileio.writeFile(file.data, at: uploadPath + fileName)
        
        let serverConfig = req.application.http.server.configuration
        let hostname = serverConfig.hostname
        let port = serverConfig.port
        
        let url = "http://\(hostname):\(port)/users-images/\(fileName)"
        
        userInfo.imageURL = url
        
        try await userInfo.update(on: req.db)
        
        try await sql.raw("SELECT * FROM posts")
            .all(decoding: Post.self)
            .filter { $0.ownerID.uuidString == userInfo.userID.uuidString }
            .forEach {
                $0.imageURL = url
                $0.update(on: req.db )
            }
        
        try await sql.raw("SELECT * FROM postfeedbacks")
            .all(decoding: Feedback.self)
            .filter { $0.ownerID.uuidString == userInfo.userID.uuidString }
            .forEach {
                $0.imageURL = url
                $0.update(on: req.db )
            }
        
        return .init(
            code: HTTPStatus.ok.code,
            message: HTTPStatus.ok.reasonPhrase,
            data: userInfo
        )
    }
    
    // PUT userinfo/:userID/delete-image
    func deleteImage(req: Request) async throws -> ServerResponse<UserInfo> {
        
        guard let id = req.parameters.get("userID"),
              let sql = req.db as? SQLDatabase else {
            throw Abort(.badRequest)
        }
        
        let filteredUsersInfo = try? await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == id }
        
        guard let userinfo = filteredUsersInfo?.first else {
            throw Abort(.notFound, reason: "No user with this \(id).")
        }
                
        let fileName = "img-profile-\(userinfo.userID.uuidString.lowercased()).jpg"
        let imageFilePath = req.application.directory.publicDirectory + "users-images/\(fileName)"
        
        try FileManager.default.removeItem(atPath: imageFilePath)
                
        userinfo.imageURL = nil
        
        try await userinfo.update(on: req.db)
        
        try await sql.raw("SELECT * FROM posts")
            .all(decoding: Post.self)
            .filter { $0.ownerID.uuidString == userinfo.userID.uuidString }
            .forEach {
                $0.imageURL = nil
                $0.update(on: req.db )
            }
        
        try await sql.raw("SELECT * FROM postfeedbacks")
            .all(decoding: Feedback.self)
            .filter { $0.ownerID.uuidString == userinfo.userID.uuidString }
            .forEach {
                $0.imageURL = nil
                $0.update(on: req.db )
            }
        
        return .init(
            code: HTTPStatus.ok.code,
            message: HTTPStatus.ok.reasonPhrase,
            data: userinfo
        )
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
