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

    @OptionalField(key: "phone")
    var phone: String?
    
    @Field(key: "bname")
    var bname: String
    
    @Field(key: "iban")
    var iban: String
    
    @OptionalField(key: "account")
    var account: String?
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    init() { }

    init(id: UUID? = nil,
         user_id: User.IDValue,
         phone: String?,
         bname: String,
         iban: String,
         account: String?,
         updatedAt: Date? = nil,
         createdAt: Date? = nil) throws {
        self.id = id
//        $created_user_id.id = try user.requireID()
//        $joined_user_id.id = try friend.requireID()
        self.$user_id.id = user_id
        self.phone = phone
        self.bname = bname
        self.iban = iban
        self.account = account
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
