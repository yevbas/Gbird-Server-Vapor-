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
            .field("title", .string, .required)
            .field("content", .string, .required)
        
            .field("timeInterval", .double)
            .field("likes", .int64)
//            .field("isFavourite", .bool, .required)
            .field("feedbackIDs", .array(of: .string))
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema("posts").delete()
    }
}
