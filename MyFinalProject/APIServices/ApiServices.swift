//
//  ApiServices.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
import Foundation
import Alamofire

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

enum APIResult<T> {
    case success(T)
    case failure(DataError)
}

final class APIManager {
    static let shared = APIManager()
    private init(){}
    
    func fetchAllCharacters(completion: @escaping (APIResult<AllCharactersDataModel>) -> Void) {
        AF.request("https://rickandmortyapi.com/api/character")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data),
                       let charactersDataModel = try? JSONDecoder().decode(AllCharactersDataModel.self, from: jsonData) {
                        completion(.success(charactersDataModel))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure(let error):
                    let dataError = DataError.network(error)
                    completion(.failure(dataError))
                    print("Alamofire request error: \(error)")
                }
            }
    }
}
