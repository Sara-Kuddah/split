//
//  LocationController.swift
//  
//
//  Created by Alaa Alabdullah on 22/05/2023.
//

import Fluent
import Vapor


struct LocationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("create", use: createLocation)
        routes.get("location", use: getLocation)
//        routes.patch("location", ":id", use: updateLocation)
    }
    
    // post location
    // name, discription, long, lat
    func createLocation(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let data = try req.content.decode(createLocationData.self)

        let location = Location(userID: userID.self,
                                discription: data.description,
                                long: data.long,
                                lat: data.lat)

        try await location.save(on: req.db)
        
        return .noContent
    }
    
    // get location
    //  locations/{id}
    func getLocation(req: Request) async throws -> Location {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        guard let location = try await Location.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all().last
        else{
            throw Abort(.notFound, reason: "location not found")
        }
        return location
    }
    // put location
    func updateLocation(req: Request) async throws -> Location {
        try req.auth.require(User.self)
        let location = try req.content.decode(Location.self)
        guard let locationFromDB = try await Location.find(location.id, on: req.db) else {
            throw Abort(.notFound)
        }
        locationFromDB.discription = location.discription
        locationFromDB.long = location.long
        locationFromDB.lat = location.lat
        try await locationFromDB.update(on: req.db)
        return location
    }
    
}


struct createLocationData: Content {
    let description: String
    let long: Double
    let lat: Double
}
