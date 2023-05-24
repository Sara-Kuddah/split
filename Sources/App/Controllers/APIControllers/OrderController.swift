//
//  OrderController.swift
//  
//
//  Created by Alaa Alabdullah on 22/05/2023.
//

import Fluent
import Vapor


struct OrderController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get("myorders", use: getMeHandler)
    }
    
    // post order / users_orders
    // merchant_name, app_name, delivery_fee
    // checkpoint, active=true, status
    // notes, location
    // user_order: order_id, user_id, user_type
    
    
    // post users_orders
    //order_id, user_id, user_type="joined"
    
    // get order / users_orders *imma start here*
    // -- all my orders--
    func getMeHandler(req: Request) async throws -> [User_Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return try await User_Order.query(on: req.db)
            .with(\.$order)
            .join(Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
            .filter(\.$user.$id == userID)
            .all()
    }
    
    
    // -- all active orders \ for unsigned users --
    func getActiveOrder(req: Request) async throws -> [Order] {
        return try await Order.query(on: req.db)
//            .chunk(max: 10 ){ _ in }
            .join(User_Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
            .filter(\Order.$active == true)
            .sort(Order.self, \.$createdAt)
            .all()
//            .range(..<10)
    
}
    
    // -- my active order --
    func getMy(req: Request) async throws -> [User_Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let orderStatus = try await Order.query(on: req.db).filter(\Order.$active == true).all(\.$active)
        return try await User_Order.query(on: req.db)
        // -- to get order stuff
            .with(\.$order)
            .join(Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
        // -- where user_id == signed in, order status not arrived
            .filter(Order.self, \.$status != "arrived")
            .filter(Order.self, \.$active == true)
            .filter(\.$user.$id == userID)
        // -- sort by date
            .sort(Order.self, \.$createdAt)
            .all()
    }
    
    
    
    // -- all active orders around me --
    func getActiveAroundMe(req: Request) async throws -> [Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        return try await Order.query(on: req.db)
            
            .all()
    }
    
    
    // put status
    // put active
}
