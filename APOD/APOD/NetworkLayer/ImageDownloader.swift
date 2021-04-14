//
//  ImageDownloader.swift
//  Sample
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import UIKit

class ImageDownloader {
    
    static func downloadImage(at urlString: String, completion: @escaping (Bool, Data?) -> ()) {
        let url = URL(string: urlString)
        guard let url_ = url else { return }
        let request = URLRequest(url: url_)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                return
            }
            completion(true, data)
        }
        task.resume()
    }
}
