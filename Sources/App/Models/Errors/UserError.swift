//
//  UserError.swift
//  
//
//  Created by Alaa Alabdullah on 09/05/2023.
//

import Vapor

enum UserError {
  case emailTaken
  case siwaEmailMissing
  case siwaInvalidState
}
extension UserError: AbortError {
  var description: String { reason }

  var status: HTTPResponseStatus {
    switch self {
    case .emailTaken: return .conflict
    case .siwaEmailMissing: return .badRequest
    case .siwaInvalidState: return .badRequest
    }
  }

  var reason: String {
    switch self {
    case .emailTaken: return "A user with this email address is already registered."
    case .siwaEmailMissing: return "The email is missing from Apple Identity Token. Try to revoke access for this application on https://appleid.apple.com and try again."
    case .siwaInvalidState: return "Invalid state."
    }
  }
}
