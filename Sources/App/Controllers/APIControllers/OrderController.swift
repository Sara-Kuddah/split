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
    
    // get order / users_orders
    
    
    // put status
    // put active 
}
