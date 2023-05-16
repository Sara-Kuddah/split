//
//  SIWAViewController.swift
//  
//
//  Created by Alaa Alabdullah on 10/05/2023.
//

import JWT
import Leaf
import Vapor

final class SIWAViewController {

  struct SignInViewContext: Encodable {
    let clientID: String
    let scope: String
    let redirectURL: String
    let state: String
  }

  func renderSignIn(req: Request) throws -> EventLoopFuture<View> {
    let state = [UInt8].random(count: 32).base64
    req.session.data["state"] = state

    return req.view
      .render(
        "Auth/siwa",
        SignInViewContext(
          clientID: ProjectConfig.SIWA.servicesIdentifier,
          scope: "name email",
          redirectURL: ProjectConfig.SIWA.redirectURL,
          state: state
        )
      )
  }

  func callback(req: Request) throws -> EventLoopFuture<UserResponse> {
    let auth = try req.content.decode(AppleAuthorizationResponse.self)
    guard
      let sessionState = req.session.data["state"],
      !sessionState.isEmpty,
      sessionState == auth.state else {
        return req.eventLoop.makeFailedFuture(UserError.siwaInvalidState)
    }

    return req.jwt.apple.verify(
      auth.idToken,
      applicationIdentifier: ProjectConfig.SIWA.servicesIdentifier
    ).flatMap { appleIdentityToken in
      User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req)
        .flatMap { user in
          if user == nil {
            return SIWAAPIController.signUp(
              appleIdentityToken: appleIdentityToken,
              firstName: auth.user?.name?.firstName,
              lastName: auth.user?.name?.lastName,
              req: req
            )
          } else {
            return SIWAAPIController.signIn(
              appleIdentityToken: appleIdentityToken,
              firstName: auth.user?.name?.firstName,
              lastName: auth.user?.name?.lastName,
              req: req
            )
          }
        }
    }
  }
}

// MARK: - RouteCollection
extension SIWAViewController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.get("sign-in", use: renderSignIn)
    routes.post("callback", use: callback)
  }
}
