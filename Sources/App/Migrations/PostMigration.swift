//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 24/10/2022.
//

import Fluent

struct PostMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("posts")
            .id()
            .field("ownerID", .uuid, .required)
            .field("ownerName", .string, .required)
            .field("content", .string, .required)
        
            .field("timeInterval", .double, .required)
            .field("likes", .array(of: .string), .required)
            .field("feedbackIDs", .array(of: .string), .required)
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema("posts").delete()
    }
}
