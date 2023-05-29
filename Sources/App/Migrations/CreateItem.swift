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
            .field("joined_userID", .uuid, .required, .references("users", "id"))
            .field("orderID", .uuid, .required, .references("orders", "id"))
            .field("item_name", .string, .required)
            .field("price", .double, .required)
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Item.schema).delete()
    }
}
