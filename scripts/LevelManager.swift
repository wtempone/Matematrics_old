//
//  LevelManager.swift
//  Matematrics
//
//  Created by William Tempone on 18/04/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//
import CoreData

class LevelManager {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext:NSManagedObjectContext
    var entity: NSEntityDescription
    
    init() {
        managedContext = self.appDelegate.managedObjectContext!
        entity =  NSEntityDescription.entityForName("Level",
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
    
    func saveLevel(level: myStructs.myLevelModel) {
        var model:NSManagedObject
        
        let request = NSFetchRequest()
        request.entity = entity
        
        request.predicate = NSPredicate(format: "(level = %@)", "\(level.level)")
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
        print("fase:")
        print(model.valueForKey("fase"))
        print("level:")
        print(model.valueForKey("level"))
        print("before:")
        print(model.valueForKey("lockedBefore"))
        print(model.valueForKey("starsBefore"))
        print("now:")
        print(model.valueForKey("locked"))
        print(model.valueForKey("stars"))
        
        model.setValue(level.fase, forKey: "fase")
        model.setValue(level.level, forKey: "level")
        model.setValue(model.valueForKey("locked"), forKey: "lockedBefore")
        model.setValue(model.valueForKey("stars"), forKey: "starsBefore")
        model.setValue(level.locked, forKey: "locked")
        model.setValue(level.stars, forKey: "stars")
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func readLevel(fase: Int, level: Int) -> myStructs.myLevelModel {
        var model:NSManagedObject
        
        let request = NSFetchRequest()
        request.entity = entity
        
        request.predicate = NSPredicate(format: "fase = %@ and level = %@", argumentArray: ["\(fase)","\(level)"])
        var error: NSError?
        var results: [AnyObject]?
        do {
            results = try managedContext.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        let returnModel = myStructs.myLevelModel()
        if results?.count > 0 {
            model = results?.first as! NSManagedObject
            returnModel.fase = model.valueForKey("fase") as! Int
            returnModel.level = model.valueForKey("level") as! Int
            returnModel.locked = model.valueForKey("locked") as! Bool
            returnModel.lockedBefore = model.valueForKey("lockedBefore") as? Bool ?? true
            returnModel.stars = model.valueForKey("stars") as! Int
            returnModel.starsBefore = model.valueForKey("starsBefore") as? Int ?? 0
        }
        return returnModel
    }
    
    func readLevelOriginal(fase: Int, level: Int) -> myStructs.myLevel {
        var exist = false
        let myLevel = myStructs.myLevel()
        let GameDataPath:NSString = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist")!
        let fases:NSArray = NSArray(contentsOfFile: GameDataPath as String)!
        for faseOriginal in fases {
            let indFase = faseOriginal.objectForKey("fase") as! Int
            if indFase == fase {
                let descriptionfase = faseOriginal.objectForKey("description") as! String
                let levels = faseOriginal.objectForKey("levels") as! NSArray
                for levelOriginal in levels {
                    let indLevel = levelOriginal.objectForKey("level") as! Int
                    if indLevel == level {
                        myLevel.fase = indFase
                        myLevel.level = indLevel
                        myLevel.description = levelOriginal.objectForKey("description") as! String
                        myLevel.descriptionFase = descriptionfase
                        myLevel.validaMultiplo = levelOriginal.objectForKey("validaMultiplo") as! Int
                        myLevel.locked = levelOriginal.objectForKey("locked") as! Bool
                        myLevel.numBlocks = levelOriginal.objectForKey("numBlocks") as! Int
                        myLevel.checkpointVelocity = levelOriginal.objectForKey("checkpointVelocity") as! Int
                        myLevel.checkpointBonus = levelOriginal.objectForKey("checkpointBonus") as! Int
                        myLevel.checkpointLevel = levelOriginal.objectForKey("checkpointLevel") as! Int
                        myLevel.checkpointLevel2 = levelOriginal.objectForKey("checkpointLevel2") as! Int
                        myLevel.checkpointLevel3 = levelOriginal.objectForKey("checkpointLevel3") as! Int
                        myLevel.checkpointTimer = levelOriginal.objectForKey("checkpointTimer") as! Int
                        myLevel.timerBlocks = levelOriginal.objectForKey("timerBlocks") as! Double
                        myLevel.random = levelOriginal.objectForKey("random") as! Bool
                        myLevel.inGameBlocks = levelOriginal.objectForKey("inGameBlocks") as! String
                        myLevel.borders = levelOriginal.objectForKey("borders") as! Bool
                        myLevel.guides = levelOriginal.objectForKey("guides") as! Bool
                        myLevel.validaConjunto = levelOriginal.objectForKey("validaConjunto") as! Bool
                        myLevel.numeroInicial = levelOriginal.objectForKey("numeroInicial") as! Int
                        myLevel.numeroFinal = levelOriginal.objectForKey("numeroFinal") as! Int
                        myLevel.posicional = levelOriginal.objectForKey("posicional") as! Bool
                        myLevel.messagemValidacaoConjunto = levelOriginal.objectForKey("messagemValidacaoConjunto") as! String
                        myLevel.blocksLine = levelOriginal.objectForKey("blocksLine") as! Bool
                        myLevel.dynamic = levelOriginal.objectForKey("dynamic") as! Bool
                        exist = true
                        break
                    }
                }
            }
            if exist {break}
        }
        return myLevel
    }

    
}
