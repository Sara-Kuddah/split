//
//  CreateToken.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent

struct CreateToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Token.schema)
            .id() 
            .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("value", .string, .required)
            .unique(on: "value")
            .field("createdAt", .datetime, .required)
            .field("expiresAt", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Token.schema).delete()
    }
}
