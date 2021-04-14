//
//  APODViewModel.swift
//  Sample
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import UIKit
enum APIError {
    case noInternet
}

class APODViewModel {
    
    private var isNetworkAvailable:Bool = NetworkStatus.shared.isOn
    private var apodModel:PicOfTheDay?
    var image:UIImage?
    var description:String?
    var title:String?
    
    func getApodDataFromAPI(with completion: @escaping (APIError?) -> ())  {
        
        //Load cahed data first
        if let cashedData:ApodEntity = DataBaseHelper.shared.fetchAPOD() {
            self.title = cashedData.title
            self.description = cashedData.explanation
            if let imageData = cashedData.image {
                self.image = UIImage(data: imageData)
            }
            completion(nil)
        }

        guard NetworkStatus.shared.isOn else {
            completion(.noInternet)
            return
        }
        
        ApodAPIClient.getPicOfTheDay { (apodData) in
            self.apodModel = apodData
            self.title = apodData.title
            self.description = apodData.description

            ImageDownloader.downloadImage(at: apodData.imageUrl) { (isSuccess, imageData) in
                if isSuccess, let data = imageData {
                    self.image = UIImage(data: data)
                    //store data using Core Data
                    DataBaseHelper.shared.saveAPOD(podData: apodData, imageData: data)
                    completion(nil)
                }
            }
        }
    }
}
