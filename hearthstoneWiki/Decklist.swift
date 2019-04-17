//
//  Decklist.swift
//  hearthstoneWiki
//
//  Created by Eduardo Ribeiro on 17/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import Foundation

struct CardCopy {
    let name: String
    let cost: Int
    let oracleText: String
    let rarity: String
    let type: String
    let imagePath: String
    var numberOfCopies: Int
}

struct Decklist {
    static var standard: Decklist = Decklist()
    var list: [String: CardCopy]
    
    private init(){
        list = [ : ]
    }
    
    mutating func insertCard(card: Card) {
        guard let _ =  self.list[card.name] else {
            let newCard = CardCopy(name: card.name, cost: card.cost, oracleText: card.oracleText, rarity: card.rarity, type: card.type, imagePath: card.imagePathBig, numberOfCopies: 1)
            self.list[card.name] = newCard
            return
        }
        if self.list[card.name]!.numberOfCopies < 4 {
            self.list[card.name]?.numberOfCopies += 1
        }
    }
}
