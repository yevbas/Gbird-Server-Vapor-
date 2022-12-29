//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Fluent

struct UserInfoMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("userinfo")
            .id()
            .field("userID", .uuid, .required)
            .field("postsIDs", .array(of: .string), .required)
            .field("userName", .string, .required)
            .field("folowingsIDs", .array(of: .string), .required)
            .field("folowersIDs", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("userinfo").delete()
    }
}

// MARK: - IMAGE SAVING

struct UserInfoImageURLMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database
            .schema(UserInfo.schema)
            .field(.imageURL, .string)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database
            .schema(UserInfo.schema)
            .deleteField(.imageURL)
            .update()
    }
}
