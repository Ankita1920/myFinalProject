//
//  DatabaseAccess.swift
//  MyFinalProject
//
//  Created by Ankita Mondal on 12/02/24.
//
import Foundation
import CouchbaseLiteSwift

class DatabaseAccess {
    static let shared = DatabaseAccess()
    let database: Database
    let collection: Collection
    
    init() {
        // Replace with your Couchbase Lite Swift initialization code
        do {
            database = try Database(name: "SingleCharacterDataModel")
            collection = try database.createCollection(name: "SingleCharacterDataModel")
        } catch {
            fatalError("Failed to initialize Couchbase Lite: \(error)")
        }
    }
    
}
