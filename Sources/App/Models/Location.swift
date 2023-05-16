//
//  Location.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent
import Vapor

final class Location: Model {
    static let schema = "locations"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "discription")
    var discription: String
    
    @Field(key: "long")
    var long: Double

    @Field(key: "lat")
    var lat: Double
    
    @Timestamp(key: "created_at", on: .create)
       var createdAt: Date?

    @Children(for: \.$location)
    var users: [User]

    init() { }

    init(id: UUID? = nil,discription: String,
         long: Double,
         lat: Double,
         createdAt: Date?) {
        self.id = id
        self.discription = discription
        self.lat = lat
        self.long = long
        self.createdAt = createdAt
    }
}
