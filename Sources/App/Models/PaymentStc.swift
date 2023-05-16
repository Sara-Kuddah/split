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
    var phone: Int
    
    @Field(key: "link")
    var link: URL
    
    @Field(key: "QR")
    var QR: Data
    
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
