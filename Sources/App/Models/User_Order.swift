//
//  User_Order.swift
//  
//
//  Created by Alaa Alabdullah on 18/05/2023.
//

import Fluent
import Vapor

final class User_Order: Model, Content {
    static let schema = "users_orders"
    
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "userID")
    var user: User

    @Parent(key: "orderID")
    var order: Order
    
    @Field(key: "type")
    var type: String
    
    @Timestamp(key: "joinedAt", on: .create, format: .iso8601)
    var joinedAt: Date?
    
    init() { }

    init(id: UUID? = nil,
         userID: User.IDValue,
         orderID: Order.IDValue,
         type: String,
         joinedAt: Date? = nil) {
        self.id = id
        self.$user.id = userID
        self.$order.id = orderID
        self.type = type
        self.joinedAt = joinedAt
    }
    
}


