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
        routes.post("join",":orderID", use: joinGroup)
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
            .sort(Order.self, \.$createdAt)
            .all()
    }
    
    
    // -- all active orders 10 \ for unsigned users --
    func getActiveOrder(req: Request) async throws -> [Order] {
        return try await Order.query(on: req.db)
            .join(User_Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
            .filter(\Order.$active == true)
            .sort(Order.self, \.$createdAt)
            .range(..<10)
            .all()

    
}
    
    // -- my active order --
    func getMy(req: Request) async throws -> User_Order {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
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
                    .all().last
        else {
            throw Abort(.notFound)
        }
        return order
    }
    
    
    
    // -- all active orders around me -- \ location needed
    func getActiveAroundMe(req: Request) async throws -> [Order] {
        try req.auth.require(User.self)
        return try await Order.query(on: req.db)
            .join(User_Order.self, on: \User_Order.$order.$id == \Order.$id, method: .inner)
            .join(Location.self, on: \Location.$id == \Order.$location.$id)
        //-- here do location math --
            .filter(\Order.$active == true)
            .sort(Order.self, \.$createdAt)
            .all()
    }
    
    // if user already has an active order????????
    // user_order: order_id, user_id, user_type \ Location??
    func createOrder(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        guard let location = try await Location.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all(\.$id).last
        else{
            throw Abort(.notFound, reason: "location not found")
        }
        let data = try req.content.decode(createOrderData.self)
        let order = try Order(locationID: location,
                              merchant_name: data.merchant_name,
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
        return .noContent
    }
    
    // post users_orders
    //order_id, user_id, user_type="joined"
    func joinGroup(req: Request) async throws -> Order {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let orderID = try req.parameters.require("orderID", as: UUID.self)
        let itemData = try req.content.decode(createItemData.self)
        let item = try Item(joined_userID: userID.self,
                            orderID: orderID.self,
                            item_name: itemData.item_name,
                             price: itemData.price)
        try await item.save(on: req.db)
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
    
    // patch status
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
    
    // patch active
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
//    let location: Location.IDValue
    let merchant_name: String
    let app_name: String
    let delivery_fee: Double
    let checkpoint: String
    let notes: String?
    let active: Bool?
    let status: String?
    
}

struct createItemData: Content {
//    let user: User.IDValue
//    let order: Order.IDValue
    let item_name: String
    let price: Double
}
