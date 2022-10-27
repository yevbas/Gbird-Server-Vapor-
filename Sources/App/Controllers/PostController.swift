import Vapor
import FluentSQL
import Fluent

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("posts")
        posts.get(use: index)
        posts.get(":ownerID", use: indexByOwnerID)
        posts.post(use: create)
    }
    
    // posts
    func index(req: Request) async throws -> [Post] {
        if let sql = req.db as? SQLDatabase {
           return try await sql.raw("SELECT * FROM posts")
                .all(decoding: Post.self)
        }
        return []
    }
    
    // followingposts/:followerID
//    func indexByFollowersID(req: Request) async throws -> [Post] {
//        guard let followerID = req.parameters.get("followerID") else {
//            throw Abort(.notFound)
//        }
//
//        if let sql = req.db as? SQLDatabase {
//            let usersInfo = try await sql.raw("SELECT * FROM userinfo")
//                .all(decoding: UserInfo.self)
//                .filter { $0.userID.uuidString == followerID }
//                .first
//
//
//            var posts = [Post]()
//
//            usersInfo?.folowingsIDs.forEach { followingID in
//                try await sql.raw("SELECT * FROM users")
//                    .all(decoding: UserInfo.self)
//                    .filter { $0.userID.uuidStringq == followerID }
//            }
//
//
//        }
        
//        return []
//    }
    
    
    // posts/:ownerID
    func indexByOwnerID(req: Request) async throws -> [Post] {
        guard let parametr = req.parameters.get("ownerID") else {
            throw Abort(.notFound)
        }

        if let sql = req.db as? SQLDatabase {
            let posts = try await sql.raw("SELECT * FROM posts")
                .all(decoding: Post.self)
            return posts.filter { $0.ownerID.uuidString == parametr }
        }
        return []
    }
    
    // posts
    func create(req: Request) async throws -> Response {
        var response = Response()
        
        if let sql = req.db as? SQLDatabase {
            let usersInfo = try await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
            
            guard let byteBuffer = req.body.data else {
                response.error = "No body was provided!"
                return response
            }
            let post = try JSONDecoder().decode(Post.self, from: Data(buffer: byteBuffer))
            
            guard let userInfo = usersInfo.filter({ $0.userID == post.ownerID }).first else {
                response.error = "Owner didn't find!"
                return response
            }
            
            // SET CURRENT DATE FOR POST
            post.timeInterval = Date().timeIntervalSince1970
            
            // SAVING POST
            try await post.save(on: req.db)
            
            guard let postID = post.id?.uuidString else {
                response.error = "ERROR:___"
                return response
            }
            
            userInfo.postsIDs.append(postID)
            
            // UPDATING USER POSTS
            try await userInfo.update(on: req.db)
            
            response.success = "ok"
            return response
        }
        
        
        return response
    }
}
