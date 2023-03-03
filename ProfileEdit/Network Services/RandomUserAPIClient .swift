//
//  RandomUserAPIClient .swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/2/23.
//

import Foundation


struct RandomUserAPIClient {
    
    static func getUsers(completion: @escaping (Result<[User], AppError>) -> ()) {
        let endpoint = "https://randomuser.me/api/?results=24"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { result in
            switch result {
            case .failure(let appError):
                print(appError.description)
            case .success(let data):
                do {
                   let userResults = try JSONDecoder().decode(RandomUser.self, from: data)
                    let users = userResults.results
                    completion(.success(users))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
