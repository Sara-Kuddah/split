//
//  Token.swift
//  
//
//  Created by Alaa Alabdullah on 03/05/2023.
//

import Fluent
import Vapor

final class Token: Model, Content {
    static let schema = "tokens"
    
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String

    @Parent(key: "userID")
    var user: User

    @Field(key: "expiresAt")
    var expiresAt: Date?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    init() { }

    init(id: UUID? = nil,
         userID: User.IDValue,
         token: String,
         expiresAt: Date?) {
        self.id = id
        self.$user.id = userID
        self.value = token
        self.expiresAt = expiresAt
    }
    
}

// MARK: - ModelTokenAuthenticatable
extension Token: ModelTokenAuthenticatable {
  static let valueKey = \Token.$value
  static let userKey = \Token.$user

  var isValid: Bool {
    guard let expiryDate = expiresAt else {
      return true
    }

    return expiryDate > Date()
  }
}


//extension Token {
//    static func generate(for user: User) throws -> Token {
//        let random = [UInt8].random(count: 16).base64
//        return try Token(value: random, userID: user.requireID())
//    }
//}
//
//extension Token: ModelTokenAuthenticatable {
//
//    typealias User = App.User
//
//    static let valueKey = \Token.$value
//    static let userKey = \Token.$user
//
//    var isValid: Bool {
//        true
//    }
//}
