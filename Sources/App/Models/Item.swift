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

    // add order id
    @Parent(key: "Order_id")
    var order: Order
    
    @Field(key: "item_name")
    var item_name: String
    
    @Field(key: "price")
    var price: Double
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    init() { }

    init(id: UUID? = nil,
         joined_user_id: User.IDValue,
         item_name: String,
         price: Double,
         updatedAt: Date? = nil,
         createdAt: Date? = nil) throws {
        
        self.id = id
        self.item_name = item_name
        self.price = price
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
