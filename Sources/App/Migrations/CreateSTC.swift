//
//  CreateSTC.swift
//  
//
//  Created by Alaa Alabdullah on 17/05/2023.
//

import Fluent

struct CreateSTC: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(PaymentStc.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("phone", .string, .required)
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(PaymentStc.schema).delete()
    }
}
