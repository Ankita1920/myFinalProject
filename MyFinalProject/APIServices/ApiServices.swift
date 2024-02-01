//
//  ApiServices.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
//
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
    private init() {}

    func fetchSingleCharacterData(completion: @escaping (APIResult<[SingleCharactersDataModel]>) -> Void) {
        AF.request("https://rickandmortyapi.com/api/character",
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil)
            .validate()
            .responseDecodable(of: [SingleCharactersDataModel].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    // Handle the request failure
                    let dataError = DataError.network(error)
                    completion(.failure(dataError))
                    print("Alamofire request error: \(error)")
                }
            }
    }
}
