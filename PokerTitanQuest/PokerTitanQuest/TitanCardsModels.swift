//
//  CardsModels.swift
//  PokerTitanQuest
//
//  Created by PokerTitanQuest on 2024/11/5.
//

import Foundation

class TitanCardsModels {
    
    func getCards() -> [TitanCards] {
        
        var GenerateArrayNumbers = [Int]()
        var generatedCardsArray = [TitanCards]()
        
        while GenerateArrayNumbers.count < 8 {
            let randomNumber = Int(arc4random_uniform(8) + 1)
            
            if !GenerateArrayNumbers.contains(randomNumber) {
                GenerateArrayNumbers.append(randomNumber)
                
                let cardOne = TitanCards()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                let cardTwo = TitanCards()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
        }
        
        generatedCardsArray.shuffle()
        
        return generatedCardsArray
    }
    
}
