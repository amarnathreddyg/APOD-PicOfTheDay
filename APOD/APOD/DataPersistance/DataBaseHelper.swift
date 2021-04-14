//
//  DataBaseHelper.swift
//  Sample
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import UIKit
import Foundation

class DataBaseHelper {
    static let shared = DataBaseHelper()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveAPOD(podData: PicOfTheDay, imageData:Data) {
        let entity = ApodEntity(context: context)
        entity.explanation = podData.description
        entity.title = podData.title
        entity.image = imageData
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAPOD() -> ApodEntity? {
        var entities:[ApodEntity]? = nil
        let fetchRequest = ApodEntity.dataFetchRequest()
        do {
            entities = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return entities?.last
    }
}
