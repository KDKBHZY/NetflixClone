//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-19.
//

import Foundation
import UIKit
import CoreData
class DataPersistenceManager{
    
    enum DataBaseError:Error{
        case failedToSaveData
        case failedToFetchData
        case failedToDelete
    }
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model:Title, completion:@escaping(Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.overview = model.overview
        item.original_name = model.original_name
        item.poster_path = model.poster_path
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToSaveData))
        }
       
    }
    
    
    func getTitlesFromDB(completion: @escaping(Result<[TitleItem],Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DataBaseError.failedToFetchData))
            
        }
    }
    
    func deleteTitle(model:TitleItem, completion:@escaping((Result<Void,Error>) -> Void)){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
}
