//
//  Item.swift
//  
//
//  Created by Alaa Alabdullah on 03/05/2023.
//

import Fluent
import Vapor

final class Item: Model, Content {
    static let schema = "items"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "joined_user_id")
    var joined_user_id: User

    @Field(key: "order_name")
    var order_name: String
    
    @Field(key: "price")
    var price: Double
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    init() { }

    init(id: UUID? = nil, joined_user_id: User, order_name: String, price: Double, updatedAt: Date? = nil,
         createdAt: Date? = nil) throws {
        self.id = id
//        $created_user_id.id = try user.requireID()
//        $joined_user_id.id = try friend.requireID()
        self.order_name = order_name
        self.price = price

        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
