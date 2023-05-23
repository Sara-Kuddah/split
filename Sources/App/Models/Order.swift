//
//  Order.swift
//  
//
//  Created by Alaa Alabdullah on 03/05/2023.
//

import Fluent
import Vapor

final class Order: Model, Content {
    static let schema = "orders"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "location_id")
    var location_id: Location

    @Field(key: "merchant_name")
    var merchant_name: String
    
    @Field(key: "app_name")
    var app_name: String
    
    @Field(key: "delivery_fee")
    var delivery_fee: Double
    
    @Field(key: "checkpoint")
    var checkpoint: String
    
    @OptionalField(key: "notes")
    var notes: String?
    
    //items children
    
    @Children(for: \.$order)
    var items: [Item]
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    
    init() { }

    init(id: UUID? = nil,
         merchant_name: String,
         app_name: String,
         delivery_fee: Double,
         checkpoint: String,
         notes: String?,
         updatedAt: Date? = nil,
         createdAt: Date? = nil) throws {
        self.id = id
        self.merchant_name = merchant_name
        self.app_name = app_name
        self.delivery_fee = delivery_fee
        self.checkpoint = checkpoint
        self.notes = notes
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
