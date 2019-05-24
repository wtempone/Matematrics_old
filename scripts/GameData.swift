class RegLevel: NSObject, NSCoding {
//    let score:Int;
//    let dateOfScore:NSDate;
    let level: Int;      // Número do nivel
    let locked: Bool;      // Número do nivel
    let stars: Int;      // Número do nivel
//    let numBlocks: Int;   //Quantidade de blocos por linha
//    let checkpointVelocity: Int; //Quantidade de acertos para incremento de velocidade
//    let checkpointBonus: Int;    //Quantidade de acertos para incremento de Bonus
//    let checkpointLevel: Int;    //Quantidade de blocos do nivel
//    let checkpointTimer: Int;    //Tempo do jogo
//    let timerBlocks: Int;         //Tempo inicial para geraáao dos blocos
//    let random: Boll;          //Posiáoes de Blocos Randomicas
//    let inGameBlocks: String; // valores dos blocos que farao parte do jogo
//    let borders: Boll;
//    let guides: Boll;

    init(level:Int, locked:Bool, stars: Int) {
        self.level = level;
        self.locked = locked;
        self.stars = stars;
    }
    
    required init(coder: NSCoder) {
        self.level = coder.decodeObjectForKey("level")! as Int;
        self.locked = coder.decodeObjectForKey("locked")! as Bool;
        self.stars = coder.decodeObjectForKey("stars")! as Int;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.level, forKey: "level")
        coder.encodeObject(self.locked, forKey: "locked")
        coder.encodeObject(self.stars, forKey: "stars")
    }
}

class LevelManager {
    var levels:Array<RegLevel> = [];
    
    init() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if !fileManager.fileExistsAtPath(path) {
            // create an empty file if it doesn't exist
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
            }
        }
        
        if let rawData = NSData(contentsOfFile: path) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject
            var levelArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData)
            self.levels = levelArray as? [RegLevel] ?? [];
        }
    }
    
    func save() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.levels);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist");
        
        saveData.writeToFile(path, atomically: true);
    }
}