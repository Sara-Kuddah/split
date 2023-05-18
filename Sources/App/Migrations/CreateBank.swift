//
//  CreateBank.swift
//  
//
//  Created by Alaa Alabdullah on 17/05/2023.
//

import Fluent

struct CreateBank: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(PaymentBank.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("phone", .string)
            .field("bname", .string, .required)
            .field("iban", .string, .required)
            .field("account", .string)
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(PaymentBank.schema).delete()
    }
}
