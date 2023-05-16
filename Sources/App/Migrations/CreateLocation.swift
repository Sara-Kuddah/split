//
//  CreateLocation.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent

struct CreateLocation: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("locations")
            .id()
            .field("discription", .string, .required)
            .field("long", .double, .required)
            .field("lat", .double, .required)
            .field("created_at", .date, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
