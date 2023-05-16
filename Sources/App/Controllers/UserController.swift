////
////  UserController.swift
////
////
////  Created by Alaa Alabdullah on 04/05/2023.
////
//
//import Vapor
//import FluentKit
//// all of it
//struct UsersController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let usersRoutes = routes.grouped("api", "users")
//        usersRoutes.post(use: createHandler)
//
//        let basicAuthMiddleware = User.authenticator()
//        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
//        basicAuthGroup.post("login", use: loginHandler)
//        usersRoutes.get( use: getAllUsernamesHandler)
//    }
//        // sign up
//        func createHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
//            let user = try req.content.decode(User.self)
//            user.password = try Bcrypt.hash(user.password)
//            return user.save(on: req.db).map {
//                user.convertToPublic()
//            }
//        }
//
//        // log in
//        func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
//            let user = try req.auth.require(User.self)
//            let token = try Token.generate(for: user)
//            return token.save(on: req.db).map { token }
//        }
//
//        func getAllUsernamesHandler(_ req: Request) throws -> EventLoopFuture<[String]> {
//            return User.query(on: req.db).all().map { users in
//                users.map { $0.email }
//            }
//        }
//
//}
