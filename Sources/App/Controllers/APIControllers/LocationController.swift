//
//  LocationController.swift
//  
//
//  Created by Alaa Alabdullah on 22/05/2023.
//

import Fluent
import Vapor


struct LocationController: RouteCollection {
//    func boot(routes: Vapor.RoutesBuilder) throws {
//        let locations = routes.grouped("location")
//        locations.on(.GET,  ":id" , use: getLocation)
    func boot(routes: RoutesBuilder) throws {
        routes.get(":id", use: getLocation)
       
    }
    
    // post location
    // name, discription, long, lat
    func createLocation(req: Request) async throws -> Location {
        let location = try req.content.decode(Location.self)
        // save on database
        try await location.save(on: req.db)
        return location
    }
    
    // get location
    //  locations/{id}
    func getLocation(req: Request) async throws -> Location {
        guard let location = try await User.Field(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound, reson: "location not found")
        }
        return location
    }
    // patch location
    func updateLocation(req: Request) async throws -> Location {
        let input = try req.content.decode(Location.self)
        if let location = try await Resource.find(req.parameters.get("id"), on: req.db) {
            location.discription = input.discription
            location.long = input.long
            location.lat = input.lat
            try await location.update(on: req.db)
            return location
        } else {
            return try await createLocation(req: req)
        }
    }
    
}
