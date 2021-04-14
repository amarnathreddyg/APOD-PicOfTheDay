//
//  APIClient.swift
//  Sample
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import Foundation

protocol APIClient {
    static func getPicOfTheDay(with completion: @escaping (PicOfTheDay) -> ())
}

class ApodAPIClient: APIClient {
    static let apiUrl = "https://api.nasa.gov/planetary/apod?api_key="
    static let apiKey = "zeLqXkCb0FfVHceYBSaIg5v8xBd0OQA69qZKApDX"
    
    static func getPicOfTheDay(with completion: @escaping (PicOfTheDay) -> ()) {
        let urlString = "\(apiUrl)\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                guard let unwrappedData = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let apodData = try decoder.decode(Apod.self, from: unwrappedData)
                    completion(apodData)
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
}

