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
        <#code#>
    }
    
    // post order / users_orders
    // merchant_name, app_name, delivery_fee
    // checkpoint, active=true, status
    // notes, location
    // user_order: order_id, user_id, user_type
    
    
    // post users_orders
    //order_id, user_id, user_type="joined"
    
    // get order / users_orders *imma start here* -- all my orders--
    func getMeHandler(req: Request) async throws -> [User_Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return try await User_Order.query(on: req.db)
            .join(Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
            .filter(\.$user.$id == userID)
            .all()
    }
    // -- active orders --
    func getActiveOrder(req: Request) async throws -> [User_Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return try await User_Order.query(on: req.db)
            .join(Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
//            .filter(\Order.$active == true)
            .filter(\.$user.$id == userID)
            
            .all()
    }
    
    // put status
    // put active
}
