import Vapor
import FluentSQL
import Fluent

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("posts")
        posts.get(use: index)
        posts.get("fresh", ":userID", use: fresh)
        posts.get(":ownerID", use: indexByOwnerID)
        posts.put("like", use: toggleLike)
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
    
    // posts/fresh/:userID
    func fresh(req: Request) async throws -> [Post] {
        guard let userID = req.parameters.get("userID") else {
            throw Abort(.notFound)
        }
        
        if let sql = req.db as? SQLDatabase {
            var posts: [Post] = []
            
            let userInfo = try await sql.raw("SELECT * FROM userinfo")
                .all(decoding: UserInfo.self)
                .filter { $0.userID.uuidString == userID }
                .first
            
            guard let folowingsIDs = userInfo?.folowingsIDs else {
                throw Abort(.notFound)
            }
            
            for id in folowingsIDs {
                let folowingPosts = try await sql.raw("SELECT * FROM posts")
                    .all(decoding: Post.self)
                    .filter { $0.ownerID.uuidString == id }
                
                posts.append(contentsOf: folowingPosts)
            }
            
            return posts
        }
        return []
    }
    
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
            post.feedbackIDs = []
            post.likes = []
            
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
    
    // PUT posts/like
    // - userID
    // - postID
    func toggleLike(req: Request) async throws -> Response  {
        struct Body: Codable {
            let userID, postID: String
        }
        
        var response = Response()
        
        guard let byteBuffer = req.body.data else {
            response.error = "No body was provided!"
            return response
        }
        
        let body = try JSONDecoder().decode(Body.self, from: Data(buffer: byteBuffer))
        
        guard let post = try await Post.find(UUID(uuidString: body.postID), on: req.db) else {
            response.error = "Cant't find post with this ID!"
            return response
        }
        
        let postWasLikedPreviously = (post.likes ?? []).contains(body.userID)
        
        if postWasLikedPreviously {
            post.likes?.removeAll(where: { $0 == body.userID } )
        } else {
            post.likes?.append(body.userID)
        }
        
        try await post.update(on: req.db)
        
        response.success = "ok"
    
        return response
    }
}
