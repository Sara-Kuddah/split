//
//  UserResponse.swift
//  
//
//  Created by Alaa Alabdullah on 09/05/2023.
//

import Vapor

struct UserResponse: Content {
  let accessToken: String?
  let user: User.Public

  init(accessToken: Token? = nil, user: User) throws {
    self.accessToken = accessToken?.value
    self.user = try user.asPublic()
  }
}
