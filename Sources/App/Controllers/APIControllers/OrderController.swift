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
        routes.get("lastrandomorders", use: getActiveOrder)
        routes.get("myactiveorder", use: getMy)
        routes.post("create", use: createOrder)
        routes.post("join", use: joinGroup)
        routes.patch("changestatus", use: changeStatus)
        routes.patch("falseactive", use: setActiveToFalse)
    }
    
    
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
    
    
    // -- all active orders 10 \ for unsigned users --
    func getActiveOrder(req: Request) async throws -> [Order] {
        return try await Order.query(on: req.db)
//            .chunk(max: 10 ){ _ in }
            .join(User_Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
            .filter(\Order.$active == true)
            .sort(Order.self, \.$createdAt)
            .range(..<10)
            .all()
//            .range(..<10)
    
}
    
    // -- my active order --
    func getMy(req: Request) async throws -> User_Order {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
//        let orderStatus = try await Order.query(on: req.db).filter(\Order.$active == true).all(\.$active)
        
        guard let order = try await User_Order.query(on: req.db)
                // -- to get order stuff
                    .with(\.$order)
                    .join(Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
                // -- where user_id == signed in, order status not arrived
                    .filter(Order.self, \.$status != "arrived")
                    .filter(Order.self, \.$active == true)
                    .filter(\.$user.$id == userID)
                // -- sort by date
                    .sort(Order.self, \.$createdAt)
                // guard
                    .all().last
        else {
            throw Abort(.notFound)
        }
        return order
    }
    
    
    
    // -- all active orders around me -- \ location needed
    func getActiveAroundMe(req: Request) async throws -> [Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        return try await Order.query(on: req.db)
            // get location, then??
        
            
            .all()
    }
    
    // post order / users_orders
    // merchant_name, app_name, delivery_fee
    // checkpoint, active=true, status
    // notes, location
    // user_order: order_id, user_id, user_type \ Location??
    func createOrder(req: Request) async throws -> Order {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let data = try req.content.decode(createOrderData.self)
        let order = try Order(merchant_name: data.merchant_name,
                              app_name: data.app_name,
                              delivery_fee: data.delivery_fee,
                              checkpoint: data.checkpoint,
                              notes: data.checkpoint,
                              active: data.active,
                              status: data.status)
        try await order.save(on: req.db)
        let user_order = try User_Order(userID: userID.self,
                                        orderID: order.requireID(),
                                        type: "created")
        try await user_order.save(on: req.db)
        return order
    }
    
    // post users_orders
    //order_id, user_id, user_type="joined"
    func joinGroup(req: Request) async throws -> Order {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let orderID = try req.parameters.require("orderID", as: UUID.self)
        
        guard let order = try await Order.find(orderID, on: req.db)
        else {
            throw Abort(.notFound, reason: "Order not found")
        }
        let user_order = User_Order(userID: userID.self,
                                        orderID: orderID.self,
                                        type: "joined")
        try await user_order.save(on: req.db)
        return order
        
    }
    
    // put status
    func changeStatus(req: Request) async throws -> HTTPStatus {
        try req.auth.require(User.self)
        let order = try req.content.decode(Order.self)
        
        guard let storedOrder = try await Order.find(order.id, on: req.db)
        else {
            throw Abort(.notFound)
        }
        storedOrder.status = order.status
        try await storedOrder.update(on: req.db)
        
        
        return .noContent
    }
    
    // put active
    func setActiveToFalse(req: Request) async throws -> HTTPStatus {
        try req.auth.require(User.self)
        let order = try req.content.decode(Order.self)
        
        guard let storedOrder = try await Order.find(order.id, on: req.db)
        else {
            throw Abort(.notFound)
        }
        storedOrder.active = false
        try await storedOrder.update(on: req.db)
        
        
        return .noContent
    }
}

struct createOrderData: Content {
    let merchant_name: String
    let app_name: String
    let delivery_fee: Double
    let checkpoint: String
    let status: String
    let active: Bool
    let note: String
}
