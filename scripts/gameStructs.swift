//
//  gameStructs.swift
//  Matematrics
//
//  Created by William Tempone on 25/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import Foundation



//
//  Estatisticas.swift
//  Matematrics
//
//  Created by William Tempone on 17/01/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import Foundation
enum enumChances  {
    case Bad, Reguar,  Good, Great, None
}

enum enumTypeMensage  {
    case Text, Star, Bonus, Erro, Loading
}
enum enumTypePanel  {
    case Win, Over, Paused
}

enum enumTypePanelConfirm  {
    case ReloadGame, QuitGame
}

enum enumAnswer {
    case Correct, Wrong, None
}

class Try {
    var result: enumAnswer = enumAnswer.None
    var numBlocks: Int = 0
    var answerString : String = ""
    var bonus : Int = 0
    var best: Bool = false
    var totalBlocks: Int = 0
}
class Statistics {
    
    var answers = 0
    var answersCorrect = 0
    var answersWrong = 0
    var maxBlocksAnswer = 0
    var chances = enumChances.None
    var previousChances = enumChances.None
    var previousAnswer = enumAnswer.None
    var sequenceCorrect = 0
    var sequenceToBonus = 0
    var sequenceWrong = 0
    var trys:[Try] = []
    func clear () {
        answers = 0
        answersCorrect = 0
        answersWrong = 0
        maxBlocksAnswer = 0
        chances = enumChances.None
        previousAnswer = enumAnswer.None
        sequenceCorrect = 0
        sequenceWrong = 0
        trys = []
    }
    
}
enum myDirection {
    case down
    case up
}

struct myStructs {
    enum myDesctiptioType {
        case image
        case text
    }
    enum myBlockType {
        case number
        case signal
    }

    struct myDesctiptionItem {
        let type: myDesctiptioType
        let text: String
    }

    class myLevelModel {
        var fase: Int = 0	//Quantidade de blocos por linha
        var level: Int = 0	//Quantidade de blocos por linha
        var locked: Bool = true	//Quantidade de blocos por linha
        var lockedBefore: Bool = true	//Quantidade de blocos por linha
        var stars: Int = 0	//Quantidade de blocos por linha
        var starsBefore: Int = 0	//Quantidade de blocos por linha
    }
    class mySettingsModel {
        var tutorial: Bool = true	//Sons de interação do Jogo Ativos
        var sounds: Bool = true	//Sons de interação do Jogo Ativos
        var music: Bool = true	//Musica do jogo ativa
    }
    class myLevel {

        var fase: Int = 0	//Quantidade de blocos por linha
        var level: Int = 0	//Quantidade de blocos por linha
        var locked: Bool = true	//Quantidade de blocos por linha
        var description: String = ""	//Descriçao do nivel
        var descriptionFase: String = ""	//Descriçao do nivel
        var validaMultiplo: Int = 0	//Quantidade de blocos por linha
        var numBlocks: Int = 0	//Quantidade de blocos por linha
        var checkpointVelocity:Int = 0	//Quantidade de acertos para incremento de velocidade
        var checkpointBonus:Int = 0     //Quantidade de acertos para incremento de Bonus
        var checkpointLevel:Int = 0 	//Quantidade de blocos do nivel
        var checkpointLevel2:Int = 0 	//Quantidade de blocos do nivel
        var checkpointLevel3:Int = 0 	//Quantidade de blocos do nivel
        var checkpointTimer:Int = 0	//Tempo do jogo
        var timerBlocks:Double = 0			//Tempo inicial para geraáao dos blocos
        var random:Bool	 = true		//Posiáoes de Blocos Randomicas
        var inGameBlocks:String = ""  // valores dos blocos que farao parte do jogo
        var borders:Bool = true
        var guides:Bool = true
        // Vadaçao de faixas de numero
        var validaConjunto: Bool = false
        var numeroInicial: Int = 0
        var numeroFinal: Int = 0
        var posicional:Bool = false
        var messagemValidacaoConjunto: String = ""
        var blocksLine:Bool = false
        var dynamic:Bool = false

    }
    class myLevels {
        var cols:Int, rows:Int
        var matrix:[myLevel]
        
        
        init(cols:Int, rows:Int) {
            self.cols = cols
            self.rows = rows
            matrix = Array(count:cols*rows, repeatedValue:myLevel())
        }
        
        subscript(col:Int, row:Int) -> myLevel {
            get {
                return matrix[cols * row + col]
            }
            set {
                matrix[cols * row + col] = newValue	
            }
        }
        
        func colCount() -> Int {
            return self.cols
        }
        
        func rowCount() -> Int {
            return self.rows
        }
    }

}