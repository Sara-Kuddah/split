//
//  CreateUser.swift
//  
//
//  Created by Alaa Alabdullah on 03/05/2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id() // here n n p
            .field("email", .string, .required)
            .field("firstName", .string)
            .field("lastName", .string)
            .field("phone", .string)
            .field("location_id", .uuid, .references("locations", "id"))
            .field("appleUserIdentifier", .string, .required)
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
