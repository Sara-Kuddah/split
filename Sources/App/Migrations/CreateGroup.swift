//
//  CreateGroup.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent

struct CreateGroup: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("groups")
            .id()
            .field("created_user_id", .uuid, .required, .references("users", "id"))
//            .field("joined_user_id", .uuid, .required, .references("users", "id"))
            .field("location_id", .uuid, .required, .references("locations", "id"))
            .field("merchant_name", .string, .required)
            .field("app_name", .string, .required)
            .field("delivery_fee", .string, .required)
            .field("checkpoint", .string, .required)
            .field("created_at", .date, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
