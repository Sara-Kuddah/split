//
//  User_Order.swift
//  
//
//  Created by Alaa Alabdullah on 18/05/2023.
//

import Fluent

struct CreateUser_Order: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User_Order.schema)
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("orderID", .uuid, .required, .references("orders", "id"))
            .field("type", .string, .required)
            .field("joinedAt", .string)
            
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User_Order.schema).delete()
    }
}
