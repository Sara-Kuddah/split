//
//  File.swift
//  
//
//  Created by Sara Khalid BIN kuddah on 12/11/1444 AH.
//

import Fluent
import JWT
import Vapor
import APNSwift

struct UserAPIController {
    //to return user info
    // api/users/me
    func getMeHandler(req: Request) throws -> UserResponse {
        let user = try req.auth.require(User.self)
        return try .init(user: user)
    }
//    func sendApns(req: Request)
//    async throws -> HTTPStatus {
//        let user = try req.auth.require(User.self)
//        let userID = try user.requireID()
//        let token = try await Token.query(on: req.db)
//            .filter(\.$user.$id == userID)
//            .first()
//        print("token :" , token?.$value.value.self!)
//        let alert = APNSwiftAlert(
//            title: "Hey There",
//            subtitle: "Full moon sighting",
//            body: "There was a full moon last night did you see it"
//        )
//        req.apns.send(alert, to: token?.$value.value.self! ?? <#default value#>)
//        return .ok
//    }
    //put user to post phone number
    // api/users/me/addphone
    func updateUserToAddPhoneNumber(req: Request) async throws -> User {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let input = try req.content.decode(UserPhoneData.self)
       if let user = try await User.find(userID, on: req.db){
           user.phone = input.phone
           try await user.update(on: req.db)
           return user
       } else {
           throw Abort(.notFound, reason: "user not found, can not add phone number to user")
       }
    }
    // get all users around order based on locations
    // we need order id to return user around
    // api/users/allaroundorder/:oreder_id
    func getUsersAroundOrder(req: Request) async throws -> [User] {
        let orderID = try req.parameters.require("orderid", as: UUID.self)
        guard let order = try await Order.find(orderID, on: req.db) else{
            throw Abort(.notFound, reason: "Order not found")
        }
        let locationID = order.$location.$id.value
        guard  let orderCurrentLocation = try await Location.find(locationID, on: req.db) else{
            throw Abort(.notFound, reason: "Location not found")
        }
        let orderCurrentLocation_Down = orderCurrentLocation.lat - 0.00040000000000
        let orderCurrentLocation_Up = orderCurrentLocation.lat + 0.00040000000000
        let orderCurrentLocation_Right = orderCurrentLocation.long + 0.00040000000000
        let orderCurrentLocation_Left = orderCurrentLocation.long - 0.00040000000000
        
        return try await User.query(on: req.db)
            .join(Location.self , on:  \User.$id == \Location.$user.$id)
            .filter(Location.self , \.$lat >= orderCurrentLocation_Down)
            .filter(Location.self, \.$lat <= orderCurrentLocation_Up)
            .filter(Location.self, \.$long <= orderCurrentLocation_Right)
            .filter(Location.self, \.$long >= orderCurrentLocation_Left)
            .all()
    }
}
   
    
    extension UserAPIController: RouteCollection {
        func boot(routes: Vapor.RoutesBuilder) throws {
          routes.get("me", use: getMeHandler)
          routes.patch("me", "addphone" ,use: updateUserToAddPhoneNumber)
          routes.get("allaroundorder",":orderid" , use: getUsersAroundOrder)
//            routes.get("test-push" , use: sendApns)
       
      }
    }
struct UserPhoneData: Content {
    let phone: String
}

