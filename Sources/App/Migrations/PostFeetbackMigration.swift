//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 31/10/2022.
//

import Fluent

struct PostFeedbackMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("postfeedbacks")
            .id()
            .field("ownerID", .uuid, .required)
            .field("postID", .uuid, .required)
            .field("ownerName", .string, .required)
            .field("feedback", .string, .required)
            .field("timeInterval", .double)
            .field("likes", .array(of: .string))
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema("postfeedbacks").delete()
    }
}
