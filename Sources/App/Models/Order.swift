//
//  Order.swift
//  
//
//  Created by Alaa Alabdullah on 03/05/2023.
//

import Fluent
import Vapor

final class Order: Model, Content {
    static let schema = "friends"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "joined_user_id")
    var joined_user_id: User

    @Field(key: "order_name")
    var order_name: String
    
    @Field(key: "price")
    var price: Double
    
    @Timestamp(key: "created_at", on: .create)
       var createdAt: Date?
    
    init() { }

    init(id: UUID? = nil, joined_user_id: User, order_name: String, price: Double, createdAt: Date?) throws {
        self.id = id
//        $created_user_id.id = try user.requireID()
//        $joined_user_id.id = try friend.requireID()
        self.order_name = order_name
        self.price = price

        self.createdAt = createdAt
    }
}
