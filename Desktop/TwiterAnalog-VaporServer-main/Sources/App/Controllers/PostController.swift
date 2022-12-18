import Vapor
import FluentSQL
import Fluent

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("posts")
        
        posts.get(use: index)
        posts.get("info", ":postID", use: getPost)
        posts.get(":ownerID", use: postByOwnerID)
        
        posts.get("fresh", ":userID", use: freshPostsByUserID)
        posts.put("like", use: toggleLike)
        posts.post(use: create)
    }
    
    // posts/:postID
//    func post(req: Request) async throws -> Post {
//        guard let postID = req.parameters.get("postID") else {
//            throw Abort(.notFound)
//        }
//        guard let post = try? await Post.find(.init(uuidString: postID), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return post
//    }
    
    // posts
    func index(req: Request) async throws -> ServerResponse<[Post]> {
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        guard let posts = try? await sql.raw("SELECT * FROM posts")
            .all(decoding: Post.self) else {
            throw Abort(.notFound)
        }
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: posts
        )
    }
    
    // posts/info/:postID
    func getPost(req: Request) async throws -> ServerResponse<Post> {
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        
        let posts = try await sql.raw("SELECT * FROM posts")
            .all(decoding: Post.self)
            .filter { $0.id?.uuidString == req.parameters.get("postID") }
        
        guard let post = posts.first else {
            throw Abort(.notFound)
        }
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: post
        )
    }
    
    // posts/fresh/:userID
    func freshPostsByUserID(req: Request) async throws -> ServerResponse<[Post]> {
        guard let userID = req.parameters.get("userID"),
              let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        
        let userInfo = try await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
            .filter { $0.userID.uuidString == userID }
            .first
        
        guard let folowingsIDs = userInfo?.folowingsIDs else {
            throw Abort(.notFound)
        }
        
        var posts: [Post] = []
        
        for id in folowingsIDs {
            let folowingPosts = try await sql.raw("SELECT * FROM posts")
                .all(decoding: Post.self)
                .filter { $0.ownerID.uuidString == id }
            
            posts.append(contentsOf: folowingPosts)
        }
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: posts
        )
    }
    
    // posts/:ownerID
    func postByOwnerID(req: Request) async throws -> ServerResponse<[Post]> {
        guard let parametr = req.parameters.get("ownerID"),
              let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        let posts = try await sql.raw("SELECT * FROM posts")
            .all(decoding: Post.self)
            .filter { $0.ownerID.uuidString == parametr }
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: posts
        )
    }
    
    // posts
    func create(req: Request) async throws -> ServerResponse<Post> {
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        
        let usersInfo = try await sql.raw("SELECT * FROM userinfo")
            .all(decoding: UserInfo.self)
        
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest, reason: "No body was found")
        }
        
        let post = try JSONDecoder().decode(Post.self, from: Data(buffer: byteBuffer))
        
        guard let userInfo = usersInfo.filter({ $0.userID == post.ownerID }).first else {
            throw Abort(.notFound)
        }
        
        // SET CURRENT DATE FOR POST
        post.timeInterval = Date().timeIntervalSince1970
        post.feedbackIDs = []
        post.likes = []
        
        // SAVING POST
        try await post.save(on: req.db)
        
        guard let postID = post.id?.uuidString else {
            throw Abort(.notFound)
        }
        
        userInfo.postsIDs.append(postID)
        
        // UPDATING USER POSTS
        try await userInfo.update(on: req.db)
        
        return .init(code: HTTPStatus.created.code,
                     message: HTTPStatus.created.reasonPhrase,
                     data: nil
        )
    }
    
    // PUT posts/like
    // - userID
    // - postID
    func toggleLike(req: Request) async throws -> ServerResponse<String>  {
        struct Body: Codable {
            let userID, postID: String
        }
                
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest, reason: "No body was provided")
        }
        
        let body = try JSONDecoder().decode(Body.self, from: Data(buffer: byteBuffer))
        
        guard let post = try await Post.find(UUID(uuidString: body.postID), on: req.db) else {
            throw Abort(.badRequest, reason: "Cant't find post with this ID")
        }
        
        let postWasLikedPreviously = (post.likes ?? []).contains(body.userID)
        
        if postWasLikedPreviously {
            post.likes?.removeAll(where: { $0 == body.userID } )
        } else {
            post.likes?.append(body.userID)
        }
        
        try await post.update(on: req.db)
            
        return .init(code: HTTPStatus.created.code,
                     message: HTTPStatus.created.reasonPhrase,
                     data: nil
        )
    }
}
