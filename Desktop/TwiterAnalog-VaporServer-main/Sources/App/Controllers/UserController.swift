import Vapor
import FluentSQL
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: allUsers)
        users.post(use: create)
        users.group(":userID") { todo in
            todo.delete(use: delete)
        }
    }
    
    // users
    func allUsers(req: Request) async throws -> ServerResponse<[User]> {
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        let users = try await sql.raw("SELECT * FROM users")
            .all(decoding: User.self)
        
        return .init(code: HTTPStatus.ok.code,
                     message: HTTPStatus.ok.reasonPhrase,
                     data: users
        )
    }
    
    // users
    func create(req: Request) async throws -> ServerResponse<UserInfo> {
        guard  let sql = req.db as? SQLDatabase else {
            throw Abort(.notFound)
        }
        let users = try await sql.raw("SELECT * FROM users")
            .all(decoding: User.self)
        
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest, reason: "No body was found")
        }
        
        let user = try JSONDecoder().decode(User.self, from: Data(buffer: byteBuffer))
        
        guard !user.email.isEmpty,
              !user.password.isEmpty,
              !user.login.isEmpty else {
            throw Abort(.badRequest, reason: "Fill all fields to create account")
        }
        guard !users.contains(where: { $0 == user }) else {
            throw Abort(.badRequest, reason: "User with this email already exists")
        }
        guard !users.contains(where: { $0.login == user.login}) else {
            throw Abort(.badRequest, reason: "User with this login already exists")
        }
        
        try await user.save(on: req.db)
        
        let userInfo = UserInfo(userID: user.id ?? .init(), userName: user.login)
        
        try await userInfo.save(on: req.db)
        
        return .init(code: HTTPStatus.created.code,
                     message: HTTPStatus.created.reasonPhrase,
                     data: userInfo
        )
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}


//extension Abort: Codable {
//}
