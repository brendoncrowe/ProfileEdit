//
//  ImageFromAPIHelper.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/2/23.
//

import UIKit


struct ImageFromAPIHelper {
    
    static func getImage(from urlString: String, completion: @escaping (Result<UIImage, AppError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(image))
            }
        }
    }
}
