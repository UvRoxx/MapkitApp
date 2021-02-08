//
//  SaveLoadData.swift
//  MapkitApp
//
//  Created by UTKARSH VARMA on 2021-02-07.
//


import CoreData
import UIKit

let context = ((UIApplication.shared.delegate)as!AppDelegate).persistentContainer.viewContext
let request:NSFetchRequest<SavedLocations> = SavedLocations.fetchRequest()
var savedLocations = [SavedLocations]()
struct SaveLoadData{
    
    func saveInfo(name:String,info:String,lat:Double,lng:Double)->String?{
        let newLocation = SavedLocations(context: context)
        newLocation.locationName = name
        newLocation.locationInfo = info
        newLocation.locationLat  = lat
        newLocation.locationLng  = lng
        savedLocations.append(newLocation)
        do{
            try context.save()
            return nil
        }
        catch{
            return error.localizedDescription
        }
        
    }
    
    func loadInfo(completion:(String?,[SavedLocations]?)->Void){
        do{
            savedLocations = try context.fetch(request)
            completion(nil,savedLocations)
        }catch{
            completion(error.localizedDescription,nil)
        }
        
    }
    func delInfo(deleteIndex:Int,completion:(String?,[SavedLocations]?)->Void){
        
        do {
            context.delete(savedLocations[deleteIndex])
            savedLocations.remove(at: deleteIndex)
            try context.save()
            completion(nil,savedLocations)
        }catch{
            completion(error.localizedDescription,nil)
        }
        
    }
    
    func saveLoadAlert(alerttitle:String,alertMessage:String,alertButtonTitle:String)->UIAlertController{
        let alert = UIAlertController(title:alerttitle, message:alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertButtonTitle, style: .default, handler: { (_) in
        }))
        return alert
        
    }
    
}
