//
//  CreateOrder.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent

struct CreateOrder: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("orders")
            .id()
            .field("joined_user_id", .uuid, .required, .references("users", "id"))
            .field("order_name", .string, .required)
            .field("price", .string, .required)
            .field("created_at", .date, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
