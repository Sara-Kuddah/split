//
//  PaymentStc.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent
import Vapor

final class PaymentStc: Model, Content {
    static let schema = "payments_stc"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user_id: User

    @Field(key: "phone")
    var phone: String
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    init() { }

    init(id: UUID? = nil, joined_user_id: User.IDValue, phone: String, updatedAt: Date? = nil,
         createdAt: Date? = nil) throws {
        self.id = id
//        $created_user_id.id = try user.requireID()
//        $joined_user_id.id = try friend.requireID()
       
        self.$user_id.id = joined_user_id
        self.phone = phone
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
