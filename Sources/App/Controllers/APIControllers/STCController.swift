//
//  File.swift
//  
//
//  Created by Sara Khalid BIN kuddah on 11/11/1444 AH.
//

import Fluent
import Vapor

// done testing all routes 
struct STCController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        //api/stcpayments/
        routes.post("create", use: createSTCPayment)
        routes.get("stcpayment", use: getSTCPayment)
        routes.patch("stcpayment", use: updateSTCPayment)
    }
    //post STC pay info
    //api/stcpayments/create
    func createSTCPayment(req: Request) async throws -> PaymentStc {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let data = try req.content.decode(STCPaymentData.self)

        let newPaymentStc = try PaymentStc(joined_user_id: userID, phone: data.phone)

        try await newPaymentStc.save(on: req.db)
        
        return newPaymentStc
    }
    
    //get STC pay info
    //api/stcpayments/stcpayment
    func getSTCPayment(req: Request) async throws -> PaymentStc {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        guard let newPaymentStc = try await PaymentStc.query(on: req.db)
            .filter(\.$user_id.$id == userID)
            .all().last
        else{
            throw Abort(.notFound, reason: "STCPayment not found")
        }
        return newPaymentStc
    }
    // patch STC pay info
    //api/stcpayments/stcpayment
    func updateSTCPayment(req: Request) async throws -> PaymentStc {
        let newPaymentStc = try req.content.decode(STCPaymentData.self)
        let PaymentStcFromDB = try await getSTCPayment(req: req)
        PaymentStcFromDB.phone = newPaymentStc.phone
        try await PaymentStcFromDB.update(on: req.db)
        return PaymentStcFromDB
    }
    
}

struct STCPaymentData: Content {
    let phone: String
}
