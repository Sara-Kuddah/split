//
//  CreateItem.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent

struct CreateItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Item.schema)
            .id()
            .field("joined_user_id", .uuid, .required, .references("users", "id"))
            .field("order_name", .string, .required)
            .field("price", .string, .required)
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Item.schema).delete()
    }
}
