//
//  User.swift
//  
//
//  Created by Alaa Alabdullah on 02/05/2023.
//

import Fluent
import JWT
import Vapor

final class User: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "firstName")
    var firstName: String?

    @Field(key: "lastName")
    var lastName: String?
    
    @Field(key: "email")
    var email: String

    @OptionalField(key: "phone")
    var phone: String?

    @OptionalParent(key: "location_id")
    var location: Location?
    
    // payments!! children
    
    @Field(key: "appleUserIdentifier")
    var appleUserIdentifier: String?
    
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    
    //updated
    
    init() { }
    // twice here and add f n l
    init(id: UUID? = nil,
         email: String,
         firstName: String? = nil,
         lastName: String? = nil,
         phone: String? = nil,
         location: Location.IDValue? = nil,
         appleUserIdentifier: String?,
//         password: String,
//         locationID: Location.IDValue,
         updatedAt: Date? = nil,
         createdAt: Date? = nil
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        $location.id = location
        self.appleUserIdentifier = appleUserIdentifier
//        self.$location.id = locationID
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        
    }
//    struct Public: Content {
//        var id: UUID?
//        var email: String
//        var name: String
//    }
}


extension User: Authenticatable {}

// MARK: - Public representation of a User
extension User {
  struct Public: Content {
    let id: UUID
    let email: String
    let firstName: String?
    let lastName: String?

    init(user: User) throws {
      self.id = try user.requireID()
      self.email = user.email
      self.firstName = user.firstName
      self.lastName = user.lastName
    }
  }

  func asPublic() throws -> Public {
    try .init(user: self)
  }
}

// MARK: - Token Creation
extension User {
  func createAccessToken(req: Request) throws -> Token {
    let expiryDate = Date() + ProjectConfig.AccessToken.expirationTime
    return try Token(
      userID: requireID(),
      token: [UInt8].random(count: 32).base64,
      expiresAt: expiryDate
    )
  }
}

// MARK: - Helpers
extension User {
  static func assertUniqueEmail(_ email: String, req: Request) -> EventLoopFuture<Void> {
    findByEmail(email, req: req)
      .flatMap {
        guard $0 == nil else {
          return req.eventLoop.makeFailedFuture(UserError.emailTaken)
        }
        return req.eventLoop.future()
    }
  }

  static func findByEmail(_ email: String, req: Request) -> EventLoopFuture<User?> {
    User.query(on: req.db)
      .filter(\.$email == email)
      .first()
  }

  static func findByAppleIdentifier(_ identifier: String, req: Request) -> EventLoopFuture<User?> {
    User.query(on: req.db)
      .filter(\.$appleUserIdentifier == identifier)
      .first()
  }
}





