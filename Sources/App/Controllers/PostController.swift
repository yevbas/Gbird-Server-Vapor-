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
            let users = try await sql.raw("SELECT * FROM users")
                .all(decoding: User.self)
            
            guard let byteBuffer = req.body.data else {
                response.error = "No body was provided!"
                return response
            }
            let post = try JSONDecoder().decode(Post.self, from: Data(buffer: byteBuffer))
            
            guard let owner = users.filter({ $0.id == post.ownerID }).first else {
                response.error = "Owner didn't find!"
                return response
            }
            
            post.feedbackIDs = []
            post.likes = 0
            post.timeInterval = Date().timeIntervalSince1970
            
            try await post.save(on: req.db)
            
            guard let postID = post.id?.uuidString else {
                response.error = "ERROR:___"
                return response
            }
            
            if owner.posts == nil {
                owner.posts = [postID]
            } else {
                owner.posts?.append(postID)
            }
            
            try await owner.update(on: req.db)
            
            response.success = "ok"
            return response
        }
        
        
        return response
    }
}
