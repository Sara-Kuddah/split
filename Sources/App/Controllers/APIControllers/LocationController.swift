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
        routes.post("user", ":id" ,"location" , use: createLocation)
        routes.get("location", ":id", use: getLocation)
        routes.patch("location", ":id", use: updateLocation)
    }
    
    // post location
    // name, discription, long, lat
    func createLocation(req: Request) async throws -> Location {
        let location = try req.content.decode(Location.self)
        // save on database
        try await location.save(on: req.db)
        
        if let user = try await User.find(req.parameters.get("id"), on: req.db){
            print(user)
            print("user.location?.id" , user.location?.id ?? "user.location?.id" )
            print("location.id" , location.id ?? "user.location?.id" )
            location.id = user.location?.id
            try await user.update(on: req.db)
            //        let updetedUserLocation : User = try await UserAPIController().updateUserToAddLocationID(req: req)
            //        print( updetedUserLocation)
        }
        return location
    }
    
    // get location
    //  locations/{id}
    func getLocation(req: Request) async throws -> Location {
        guard let location = try await Location.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound, reason: "location not found")
        }
        return location
    }
    // patch location
    func updateLocation(req: Request) async throws -> Location {
        let input = try req.content.decode(Location.self)
        if let location = try await Location.find(req.parameters.get("id"), on: req.db) {
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
