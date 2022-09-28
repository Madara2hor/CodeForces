//
//  NetworkLayer.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import Alamofire

enum ApiEndpoint: String {
    
    case contestList = "contest.list"
    case userInfo = "user.info"
    case topUsers = "user.ratedList"
}

enum AppError: Error {
    
    case noDataError
    case dataDecodingError
    case unknownError
    case customError(message: String?)
}

protocol NetworkServiceProtocol {
    
    func getContests(
        gym: Bool,
        completion: @escaping (Result<RequestResult<Contest>?, Error>) -> Void
    )
    func getUser(
        username: String,
        completion: @escaping (Result<RequestResult<User>?, Error>) -> Void
    )
    func getTopUsers(
        activeOnly: Bool,
        completion: @escaping (Result<RequestResult<User>?, Error>) -> Void
    )
}

class NetworkService: NetworkServiceProtocol {
    
    private enum Constants {
        
        static let gymKey: String = "gym"
        static let handlesKey: String = "handles"
        static let activeOnlyKey: String = "activeOnly"
    }
    
    private let apiKey: String = "ad7390d0ad53beb93317a60ec6e51743b53f6eab"
    private let apiURL: String = "http://codeforces.com/api/"
    private let apiSecret: String = "c1d9a1a42cab4419d6f14040eac4701ece37ee5a"
    
    func getContests(
        gym: Bool,
        completion: @escaping (Result<RequestResult<Contest>?, Error>) -> Void
    ) {
        let parameters = [Constants.gymKey: "\(gym)"]
        let urlString = getUrlString(endpoint: ApiEndpoint.contestList.rawValue, parameters: parameters)
        
        fetchData(type: RequestResult<Contest>.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getUser(
        username: String,
        completion: @escaping (Result<RequestResult<User>?, Error>) -> Void
    ) {
        let parameters = [Constants.handlesKey: username]
        let urlString = getUrlString(endpoint: ApiEndpoint.userInfo.rawValue, parameters: parameters)
        
        fetchData(type: RequestResult<User>.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getTopUsers(
        activeOnly: Bool,
        completion: @escaping (Result<RequestResult<User>?, Error>) -> Void
    ) {
        let parameters = [Constants.activeOnlyKey: "\(activeOnly)"]
        let urlString = getUrlString(endpoint: ApiEndpoint.topUsers.rawValue, parameters: parameters)
        
        fetchData(type: RequestResult<User>.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getHashedUrlString(endpoint: String, parameters: [String: String]) -> String {
        let time = Date().millisecondsSince1970
        let apiSig = Int.random(in: 100000...999999)
        var parametersString = String()
        
        for (key, value) in parameters {
            parametersString += "\(key)=\(value)&"
        }
        
        let hash = "\(apiSig)/\(endpoint)?apiKey=\(apiKey)&\(parametersString)time=\(time)#\(apiSecret)".sha512
        let hashedUrlString = "\(apiURL)\(endpoint)?\(parametersString)apiKey=\(apiKey)&time=\(time)&apiSig=\(apiSig)\(hash)"
        
        return hashedUrlString
    }
    
    func getUrlString(endpoint: String, parameters: [String: String]) -> String {
        var parametersString = String()
        
        for (key, value) in parameters {
            parametersString += "\(key)=\(value)&"
        }
        
        let hashedUrlString = "\(apiURL)\(endpoint)?\(parametersString)"
        
        return hashedUrlString
    }
    
    func fetchData<T: Decodable>(
        type: T.Type = T.self,
        urlString: String,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        AF.request(urlString).responseDecodable(of: T.self) { response in
            do {
                guard let data = response.data else {
                    completion(.failure(AppError.noDataError))
                    return
                }
                
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decodedData))
            } catch {
                guard let error = response.error else {
                    completion(.failure(AppError.dataDecodingError))
                    return
                }
                
                completion(.failure(error))
            }
        }
    }
}
