//
//  ItemController.swift
//  
//
//  Created by Alaa Alabdullah on 22/05/2023.
//

import Fluent
import Vapor

struct ItemController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.post(":orderID", use: createItem)
        routes.get(":orderID", use: getItems)
        routes.get("get", use: getItemsInOrders)
        routes.get("getAll",":orderID", use: getAllItems)
    }
    
    // maybe will be deleted if not necessary
    // post item: user_id, order_id, item, price
    func createItem(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let orderID = try req.parameters.require("orderID", as: UUID.self)
        let itemData = try req.content.decode(createItemData.self)
        guard let order = try await Order.find(orderID, on: req.db)
              else {
                  throw Abort(.notFound, reason: "Order not found")
              }
        let item = try Item(joined_userID: userID,
                            orderID: try order.requireID(),
                            item_name: itemData.item_name,
                             price: itemData.price)
        try await item.save(on: req.db)
        return .noContent
    }
    // get my items in an order
    
    
    func getItems(req: Request) async throws -> [Item] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let orderID = try req.parameters.require("orderID", as: UUID.self)
        return try await Item.query(on: req.db)

            .filter(\Item.$joined_user.$id == userID)
            .filter(\Item.$order.$id == orderID)
            .all()
    }
    // get all order's items
    func getAllItems(req: Request) async throws -> [Item] {
        let user = try req.auth.require(User.self)
//        let userID = try user.requireID()
        let orderID = try req.parameters.require("orderID", as: UUID.self)
//        guard let order = try await Order.find(orderID, on: req.db)
//              else {
//                  throw Abort(.notFound, reason: "Order not found")
//              }
        return try await Item.query(on: req.db)
            .join(Order.self, on: \Order.$id == \Item.$order.$id)
            .filter(\Item.$order.$id == orderID)
            .sort(Order.self, \.$createdAt)
            .all()
    }
    
    func getItemsInOrders(req: Request) async throws -> [Order] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return try await Order.query(on: req.db)
            .with(\.$items)
            .join(User_Order.self, on: \Order.$id == \User_Order.$order.$id)
            .filter(User_Order.self, \.$user.$id == userID)
//            .filter(User_Order.self, \.$type == "joined")
            
            .all()
    }
    // get all my items in general
}
