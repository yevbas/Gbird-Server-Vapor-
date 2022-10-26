import Vapor
import FluentSQL
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { todo in
            todo.delete(use: delete)
        }
    }
    
    // users
    func index(req: Request) async throws -> [User] {
        if let sql = req.db as? SQLDatabase {
           return try await sql.raw("SELECT * FROM users")
                .all(decoding: User.self)
        }
        return []
    }
    
    // users
    func create(req: Request) async throws -> Response {
        var response = Response()
        
        if let sql = req.db as? SQLDatabase {
            let users = try await sql.raw("SELECT * FROM users")
                .all(decoding: User.self)
            
            guard let byteBuffer = req.body.data else {
                response.error = "No body was provided!"
                return response
            }
            let user = try JSONDecoder().decode(User.self, from: Data(buffer: byteBuffer))
            
            guard user.email != "", user.password != "", user.login != "" else {
                response.error = "Enter data to create account!"
                return response
            }
            
            guard !users.contains(where: { $0 == user }) else {
                response.error = "User with this email already exists!"
                return response
            }
            guard !users.contains(where: { $0.login == user.login}) else {
                response.error = "User with this login already exists!"
                return response
            }
            try await user.save(on: req.db)
            
            let userInfo = UserInfo(userID: user.id ?? .init())
            
            try await userInfo.save(on: req.db)
            response.success = user.id?.uuidString ?? "status ok, no user id..."
            return response
        }
        
        return response
        
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}


