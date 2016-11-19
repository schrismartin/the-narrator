//
//  SCMGameManager.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/13/16.
//
//

import Vapor
import MongoKitten
import HTTP
import Foundation

public class SCMDatabaseManager {
    
    internal var database: MongoKitten.Database
    
    public init?() {
        
        // Connect to the database
        do {
            let hostname = ConfigService.shared.mongoURI
            let mongoServer = try Server(mongoURL: hostname, automatically: true)
            
            self.database = mongoServer["dont-shoot-the-messenger"]
        } catch {
            print("Could not connect to server. Exiting")
            return nil
        }
    }
    
}

extension SCMDatabaseManager {
    
    /// Save the player to the database
    /// - Parameter player: Player instance to save to the database
    public func savePlayer(player: Player) throws {
        
        let playerCollection = database["player"]
        try playerCollection.insert(player.document)
    }
    
    /// Polls the server for player with the given id
    /// - Parameter identifier: Unique identifier provided by Facebook, modified for MongoDB
    /// - Returns: Player object if expected player exists in database, `nil` otherwise
    /// - Throws: If request/response is unfulfilled or permissions are inadequate
    public func retrievePlayer(withId identifier: SCMIdentifier) throws -> Player? {
        
        let areaCollection = database["player"]
        guard let objectId = identifier.objectId else { return nil }
        let playerDoc = try areaCollection.findOne(matching: "_id" == objectId)
        
        if let document = playerDoc {
            return Player(document: document)
        } else {
            return nil
        }
        
    }
}

extension SCMDatabaseManager {

    /// Save the area to the database
    /// - Parameter area: Area instance to save to the database
    public func saveArea(area: Area) throws {
        
        let areaCollection = database["area"]
        try areaCollection.insert(area.document)
    }
    
    public func retrieveArea(withId objectId: ObjectId) throws -> Area? {
        
        let areaCollection = database["area"]
        let playerDoc = try areaCollection.findOne(matching: "_id" == objectId)
        
        if let document = playerDoc {
            return Area(document: document)
        } else {
            return nil
        }
        
    }
}

