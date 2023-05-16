//
//  Group.swift
//  
//
//  Created by Alaa Alabdullah on 03/05/2023.
//

import Fluent
import Vapor

final class Group: Model, Content {
    static let schema = "friends"

    @ID(key: .id)
    var id: UUID?


    @Parent(key: "created_user_id")
    var created_user_id: User
    
    @Parent(key: "joined_user_id")
    var joined_user_id: User
    
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
    
    //timer
    
    @Timestamp(key: "created_at", on: .create)
       var createdAt: Date?
    
    init() { }

    init(id: UUID? = nil, created_user_id: User, joined_user_id: User, merchant_name: String, app_name: String, delivery_fee: Double, checkpoint: String, createdAt: Date?) throws {
        self.id = id
        $created_user_id.id = try created_user_id.requireID()
        $joined_user_id.id = try joined_user_id.requireID()
        self.merchant_name = merchant_name
        self.app_name = app_name
        self.delivery_fee = delivery_fee
        self.checkpoint = checkpoint
        self.createdAt = createdAt
    }
}
