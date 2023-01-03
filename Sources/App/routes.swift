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

    try app.register(collection: UserController())
    try app.register(collection: UserInfoController())
    try app.register(collection: PostController())
    try app.register(collection: AuthCollection())
    try app.register(collection: FollowersController())
    try app.register(collection: FeedbackCollection())
}

struct SearchedUser: Content {
    var id: String = ""
    var name: String = ""
    var imageURL: String? = nil
}
