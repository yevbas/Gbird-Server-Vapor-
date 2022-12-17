import Fluent
import FluentSQL
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    // users/:query
    app.get("users", ":query") { req async -> [SearchedUser] in
        if let sql = req.db as? SQLDatabase, let query = req.parameters.get("query") {
            let users = try? await sql.raw("SELECT * FROM users")
                .all(decoding: User.self)
                .filter { $0.login.lowercased().contains(query.lowercased()) }
                .map { SearchedUser(id: $0.id?.uuidString ?? "", name: $0.login) }
            return users ?? []
        }
        return []
    }

    try app.register(collection: UserController())
    try app.register(collection: UserInfoController())
    try app.register(collection: PostController())
    try app.register(collection: AuthCollection())
    try app.register(collection: FollowersController())
    try app.register(collection: FeedbackCollection())
}

struct SearchedUser: Content {
    let id: String
    let name: String
}
