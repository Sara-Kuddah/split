//
//  File.swift
//  
//
//  Created by Alaa Alabdullah on 10/05/2023.
//

import Fluent
import JWT
import Vapor

struct UserAPIController {
    // api/users/me
  func getMeHandler(req: Request) throws -> UserResponse {
    let user = try req.auth.require(User.self)
    return try .init(user: user)
  }
    
    //put user to post phone number
    func updateUserToAddPhoneNumber(req: Request) async throws -> User {
        let input = try req.content.decode(User.self)
       if let user = try await User.find(req.parameters.get("id"), on: req.db){
           user.phone = input.phone
           try await user.update(on: req.db)
           return user
       } else {
           print( "Error line 26 in UserAPIController can not add phone number to user")
           throw Abort(.notFound, reson: "user not found can not add phone number to user")
       }
    }
    // get all info including phone
    //  users/{id}
    func getUser(req: Request) async throws -> User{
        guard let user = try await User.Field(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound, reson: "user not found")
        }
        return user
    }
    
    // updateUserToAddLOcationID
    // we need get users based on location around
    
}





// MARK: - RouteCollection
extension UserAPIController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
  //  func boot(routes: Vapor.RoutesBuilder) throws {
      // api/users/me
      routes.get("me", use: getMeHandler)
      routes.patch(":id", use: updateUserToAddPhoneNumber)
      routes.get(":id", use: getUser)
      //no need
//        let users = routes.grouped("users")
//        users.on(.GET, "me" , use: getMeHandler)
//        users.on(.PATCH, ":id" , use: updateUserToAddPhoneNumber)
//        users.on(.GET, ":id" , use: getUser)
  }
}
