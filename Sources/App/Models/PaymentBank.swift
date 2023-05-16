//
//  PaymentBank.swift
//  
//
//  Created by Alaa Alabdullah on 04/05/2023.
//

import Fluent
import Vapor

final class PaymentBank: Model, Content {
    static let schema = "payments_bank"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user_id: User

    @Field(key: "phone")
    var phone: Int
    
    @Field(key: "bname")
    var bname: String
    
    @Field(key: "iban")
    var iban: String
    
    @Field(key: "account")
    var account: String
    
    @Timestamp(key: "created_at", on: .create)
       var createdAt: Date?
    
    init() { }

    init(id: UUID? = nil, joined_user_id: User, order: String, price: Double, createdAt: Date?) throws {
        self.id = id
//        $created_user_id.id = try user.requireID()
//        $joined_user_id.id = try friend.requireID()
       

        self.createdAt = createdAt
    }
}
