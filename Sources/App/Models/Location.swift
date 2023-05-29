//
//  Location.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent
import Vapor

final class Location: Model , Content {
    static let schema = "locations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Field(key: "discription")
    var discription: String
    
    @Field(key: "long")
    var long: Double

    @Field(key: "lat")
    var lat: Double
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?

    

    init() { }

    init(id: UUID? = nil,
         userID: User.IDValue,
         discription: String,
         long: Double,
         lat: Double,
         updatedAt: Date? = nil,
         createdAt: Date? = nil) {
        
        self.id = id
        self.$user.id = userID
        self.discription = discription
        self.lat = lat
        self.long = long
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
