//
//  LevelManager.swift
//  Matematrics
//
//  Created by William Tempone on 18/04/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//
import CoreData

class SettingsManager {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext:NSManagedObjectContext
    var entity: NSEntityDescription
    
    init() {
        managedContext = self.appDelegate.managedObjectContext!
        entity =  NSEntityDescription.entityForName("Settings",
            inManagedObjectContext:
            managedContext)!
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func saveSettings(settings: myStructs.mySettingsModel) {
        var model:NSManagedObject
        
        let request = NSFetchRequest()
        request.entity = entity
        
        //request.predicate = NSPredicate(format: "(level = %@)", "\(level.level)")
        var error: NSError?
        var results: [AnyObject]?
        do {
            results = try managedContext.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        if results?.count > 0 {
            model = results?.first as! NSManagedObject
            //println(model.valueForKey("level"))
        } else {
            model = NSManagedObject(entity: entity,
                insertIntoManagedObjectContext:managedContext)
        }
        print("tutorial:")
        print(model.valueForKey("tutorial"))
        print("sounds:")
        print(model.valueForKey("sounds"))
        print("music:")
        print(model.valueForKey("music"))
        
        model.setValue(settings.tutorial, forKey: "tutorial")
        model.setValue(settings.sounds, forKey: "sounds")
        model.setValue(settings.music, forKey: "music")
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func readSettings() -> myStructs.mySettingsModel {
        var model:NSManagedObject
        
        let request = NSFetchRequest()
        request.entity = entity
        
        var error: NSError?
        var results: [AnyObject]?
        do {
            results = try managedContext.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        let returnModel = myStructs.mySettingsModel()
        if results?.count > 0 {
            model = results?.first as! NSManagedObject
            returnModel.tutorial = model.valueForKey("tutorial") as! Bool
            returnModel.sounds = model.valueForKey("sounds") as! Bool
            returnModel.music = model.valueForKey("music") as! Bool
        } else {
            self.saveSettings(returnModel)
        }
        return returnModel
    }
    
}
