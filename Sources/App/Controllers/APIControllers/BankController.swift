//
//  File.swift
//  
//
//  Created by Sara Khalid BIN kuddah on 11/11/1444 AH.
//

import Fluent
import Vapor

// done testing all routes
struct BankController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        //api/bankpayments/
        routes.post("create", use: createBankPayment)
        routes.get("bankpayment", use: getBankPayment)
        routes.patch("bankpayment", use: updateBankPayment)
    }
    //post STC pay info
    //api/bankpayments/create
    func createBankPayment(req: Request) async throws -> PaymentBank {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let data = try req.content.decode(BankPaymentData.self)

        let newPaymentBank = try PaymentBank(user_id: userID, phone: data.phone, bname: data.bname, iban: data.iban, account: data.account)

        try await newPaymentBank.save(on: req.db)
        
        return newPaymentBank
    }
    
    //get Bank pay info
    //api/bankpayments/bankpayment
    func getBankPayment(req: Request) async throws -> PaymentBank {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        guard let paymentBank = try await PaymentBank.query(on: req.db)
            .filter(\.$user_id.$id == userID)
            .all().last
        else{
            throw Abort(.notFound, reason: "Bank info not found")
        }
        return paymentBank
    }
    // patch Bank pay info
    //api/bankpayments/bankpayment
    func updateBankPayment(req: Request) async throws -> PaymentBank {
        let updatedPaymentBank = try req.content.decode(BankPaymentData.self)
        let paymentBankFromDB = try await getBankPayment(req: req)
        paymentBankFromDB.phone = updatedPaymentBank.phone
        paymentBankFromDB.bname = updatedPaymentBank.bname
        paymentBankFromDB.iban = updatedPaymentBank.iban
        paymentBankFromDB.account = updatedPaymentBank.account
        try await paymentBankFromDB.update(on: req.db)
        return paymentBankFromDB
    }
    
}

struct BankPaymentData: Content {
    let phone: String?
    let bname: String
    let iban: String
    let account: String?
}
