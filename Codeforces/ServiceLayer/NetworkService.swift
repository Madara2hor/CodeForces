//
//  NetworkLayer.swift
//  Twitter
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    var apiURL: String { get }
    var apiKey: String { get }
    var apiSecret: String { get }
    func getContests(gym: Bool, completion: @escaping (Result<RequestResult<Contest>?, Error>) -> Void)
    func getUser(user: String, completion: @escaping (Result<RequestResult<User>?, Error>) -> Void)
    func getTopUsers(activeOnly: Bool, completion: @escaping (Result<RequestResult<User>?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    var apiKey: String = "ad7390d0ad53beb93317a60ec6e51743b53f6eab"
    var apiURL: String = "http://codeforces.com/api/"
    var apiSecret: String = "c1d9a1a42cab4419d6f14040eac4701ece37ee5a"
    
    func getContests(gym: Bool, completion: @escaping (Result<RequestResult<Contest>?, Error>) -> Void) {
        let parameters = ["gym": "\(gym)"]
        let urlString = getHashedUrlString(endpoint: apiEndpoint.contestList.rawValue, parameters: parameters)
        
        print(urlString)
        fetchData(type: RequestResult<Contest>.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getUser(user: String, completion: @escaping (Result<RequestResult<User>?, Error>) -> Void) {
        let parameters = ["handles": "\(user)"]
        let urlString = getHashedUrlString(endpoint: apiEndpoint.userInfo.rawValue, parameters: parameters)
        
        print(urlString)
        fetchData(type: RequestResult<User>.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getTopUsers(activeOnly: Bool, completion: @escaping (Result<RequestResult<User>?, Error>) -> Void) {
        let parameters = ["activeOnly": "\(activeOnly)"]
        let urlString = getUrlString(endpoint: apiEndpoint.topUsers.rawValue, parameters: parameters)
        
        print(urlString)
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
    
    func fetchData<T: Decodable>(type: T.Type = T.self, urlString: String, completion: @escaping (Result<T?, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}

enum apiEndpoint: String {
    case contestList = "contest.list"
    case userInfo = "user.info"
    case topUsers = "user.ratedList"
    
}
