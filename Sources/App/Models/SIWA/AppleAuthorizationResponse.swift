//
//  AppleAuthorizationResponse.swift
//  
//
//  Created by Alaa Alabdullah on 09/05/2023.
//

import Foundation

struct AppleAuthorizationResponse: Decodable {
  
  struct User: Decodable {
    struct Name: Decodable {
      let firstName: String?
      let lastName: String?
    }
    let email: String
    let name: Name?
  }
  
  let code: String
  let state: String
  let idToken: String
  let user: User?
  
  enum CodingKeys: String, CodingKey {
    case code
    case state
    case idToken = "id_token"
    case user
  }
  
  init(from decoder: Decoder) throws {
    
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try values.decode(String.self, forKey: .code)
    self.state = try values.decode(String.self, forKey: .state)
    self.idToken = try values.decode(String.self, forKey: .idToken)
    
    if let jsonString = try values.decodeIfPresent(String.self, forKey: .user),
      let jsonData = jsonString.data(using: .utf8) {
      self.user = try JSONDecoder().decode(User.self, from: jsonData)
    } else {
      self.user = nil
    }
  }
}
