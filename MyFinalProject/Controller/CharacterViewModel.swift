//
//  CharacterViewModel.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 01/02/24.
import Foundation

class CharacterViewModel {
    var characters: [Character] = [] 

    func fetchCharacters(completion: @escaping (Swift.Result<[Character], Error>) -> Void) {
        APIManager.shared.fetchAllCharacters { [weak self] result in
            switch result {
            case .success(let allCharactersData):
                self?.characters = allCharactersData.results
                completion(.success(allCharactersData.results))
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch characters: \(error)")
            }
        }
    }
}

// Other view models as needed

