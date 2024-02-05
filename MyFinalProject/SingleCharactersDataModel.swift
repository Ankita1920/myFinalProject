//
//  SingleCharactersDataModel.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
//

import Foundation

// MARK: - SingleCharactersDataModel
struct SingleCharactersDataModel: Codable {
    let id: Int
   let name, status, species, type: String
    let gender: String
    let origin, location: LocationForSingleCharacters
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct LocationForSingleCharacters: Codable {
    let name: String
    let url: String
}

