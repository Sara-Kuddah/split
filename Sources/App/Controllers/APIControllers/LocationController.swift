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
        routes.patch("location", use: updateLocation)
    }
    
    // post location
    // api/locations/create
    func createLocation(req: Request) async throws -> Location {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let data = try req.content.decode(createLocationData.self)

        let location = Location(userID: userID.self,
                                discription: data.discription,
                                long: data.long,
                                lat: data.lat)
        try await location.save(on: req.db)
        return location
    }

    // get location
    //api/locations/location
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
    // patch location
    //api/locations/location
    func updateLocation(req: Request) async throws -> Location {
        try req.auth.require(User.self)
        let location = try req.content.decode(createLocationData.self)
        let locationFromDB = try await getLocation(req: req)
        locationFromDB.discription = location.discription
        locationFromDB.long = location.long
        locationFromDB.lat = location.lat
        try await locationFromDB.update(on: req.db)
        return locationFromDB
    }
    
}

struct createLocationData: Content {
    let discription: String
    let long: Double
    let lat: Double
}
