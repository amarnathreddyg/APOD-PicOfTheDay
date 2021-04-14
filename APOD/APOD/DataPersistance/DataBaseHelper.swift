//
//  DataBaseHelper.swift
//  APOD
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
        
        //first delete existing records before save
        deleteAllRecords()
        
        //add the new Entry
        let entity = ApodEntity(context: context)
        entity.explanation = podData.description
        entity.title = podData.title
        entity.date = podData.date
        entity.image = imageData
        
        do {
            try context.save()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func fetchAPODEntries() -> [ApodEntity]? {
        var entities:[ApodEntity]? = nil
        let fetchRequest = ApodEntity.dataFetchRequest()
        do {
            entities = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(error)")
        }
        return entities
    }
    
    func deleteAllRecords() {
        let fetchRequest = ApodEntity.dataFetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            for entity in entities {
                context.delete(entity)
            }
        } catch let error as NSError {
            print("\(error)")
        }
    }
}
