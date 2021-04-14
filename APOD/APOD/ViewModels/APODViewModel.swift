//
//  APODViewModel.swift
//  APOD
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import UIKit
enum APIError {
    case noInternet
}

class APODViewModel {
    
    private var isNetworkAvailable:Bool = NetworkStatus.shared.isOn
    var image:UIImage?
    var description:String?
    var title:String?
    var date:String?
    
    func getApodDataFromAPI(with completion: @escaping (String?) -> ())  {
        
        //Load cahed data first
        let today = todaysDate()
        let cashedData = DataBaseHelper.shared.fetchAPODEntries() ?? []
        let isNetworkAvailable = NetworkStatus.shared.isOn

        var cashedEntity:ApodEntity?
        if cashedData.count > 0 {
            if let todayPOD = cashedData.filter({ $0.date == today}).last {
                cashedEntity = todayPOD
                loadData(with: todayPOD)
                completion(nil)
            } else  {
                cashedEntity = cashedData.last
                loadData(with: cashedEntity)
                if isNetworkAvailable == false {
                    completion("We are not connected to the internet, showing you the last image we have.")
                } else {
                    completion(nil)
                }
            }
        }
        
        if cashedEntity == nil && isNetworkAvailable == false {
            completion("No Internet connection")
            return
        }
                
        ApodAPIClient.getPicOfTheDay(for: today) { (apodData) in
            self.title = apodData.title
            self.description = apodData.description
            self.date = apodData.date

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
    
    func loadData(with entity:ApodEntity?) {
        if let podData = entity {
            self.title = podData.title
            self.description = podData.explanation
            self.date = podData.date
            if let imageData = podData.image {
                self.image = UIImage(data: imageData)
            }
        }
    }
    
    func todaysDate() -> String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: todaysDate)
    }
}
