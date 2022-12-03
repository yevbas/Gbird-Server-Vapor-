//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 24/10/2022.
//

import Fluent
import Vapor

final class User: Model, Content {
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.email == rhs.email
    }
    
    static var schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    @Field(key: "password")
    var password: String
    @Field(key: "login")
    var login: String
    
    init() {}
    
    #warning("This init is what should we provide in request body !!!")
    init(id: UUID? = nil,
         email: String,
         password: String,
         login: String
    ){
        self.id = id
        self.email = email
        self.password = password
        self.login = login
    }
    
}
