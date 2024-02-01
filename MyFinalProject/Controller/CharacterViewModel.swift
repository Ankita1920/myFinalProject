//
//  CharacterViewModel.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 01/02/24.
//
import Foundation

class CharacterViewModel {
    var characters: [SingleCharactersDataModel] = []

    func fetchCharacters(completion: @escaping () -> Void) {
        APIManager.shared.fetchSingleCharacterData { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                completion()
            case .failure(let error):
                print("Failed to fetch characters: \(error)")
            }
        }
    }
}

// Other view models as needed

