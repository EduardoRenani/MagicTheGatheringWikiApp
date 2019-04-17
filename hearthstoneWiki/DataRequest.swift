//
//  DataRequest.swift
//  hearthstoneWiki
//
//  Created by Eduardo Ribeiro on 12/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import Foundation


struct Card {
    var name: String
    var type: String
    var cost: Int
    var rarity: String
    var imagePathSmall: String
    var imagePathBig: String
    var oracleText: String
    var numberOfCopies: Int = 0
    
    init?(fromDictionary dictionary: [String: Any]) {
        guard
            let name = dictionary["name"] as? String,
            let cost = dictionary["cmc"] as? Int,
            let type = dictionary["type_line"] as? String,
            let rarity = dictionary["rarity"] as? String,
            let oracleText = dictionary["oracle_text"] as? String,
            let imageURL = dictionary["image_uris"] as? [String: String],
            let imagePathSmall = imageURL["border_crop"],
            let imagePathBig = imageURL["border_crop"]
        else{
            return nil
        }
        self.name = name
        self.cost = cost
        self.oracleText = oracleText
        self.type = type
        self.rarity = rarity
        self.imagePathSmall = imagePathSmall
        self.imagePathBig = imagePathBig
    }
    
    init?(name: String, type: String, cost: Int, rarity: String, imagePath: String, oracleText: String, numberOfCopies: Int) {
        self.name = name
        self.type = type
        self.cost = cost
        self.rarity = rarity
        self.imagePathSmall = imagePath
        self.imagePathBig = imagePath
        self.oracleText = oracleText
        self.numberOfCopies = numberOfCopies
    }
    
}

struct DataService {
    
    private static let endpointPath = "https://api.scryfall.com"
    
    private static var cardsByColorEndpoint: URL? {
        return URL(string: "\(endpointPath)/cards/search?q=c:")
    }

    
    static func getCardsByName(cardName: String, completionHandler completion: @escaping ([Card]?) -> Void) {
        guard let cardsEndpoint = URL(string: "\(endpointPath)/cards/search?q=name:\(cardName)") else {
            completion(nil)
            return
        }
        print(cardsEndpoint)
        let urlSession = URLSession.shared
        
        _ = urlSession.dataTask(with: cardsEndpoint) { (data, response, error) in
            guard
                let error = error
            else {
                guard
                    let unwrappedData = data,
                    let dataJson = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments),
                    let json = dataJson as? [String: Any],
                    let resData = json["data"] as? [[String:Any]]
                else {
                    completion(nil)
                    return
                }
                
                let cards = resData.compactMap( {
                    Card(fromDictionary: $0)
                })
                completion(cards)
                return
                
            }
            
            print(error.localizedDescription)
            completion(nil)
            return
            
        }.resume()
        
    }
    
    static func getAllCards(completionHandler completion: @escaping ([Card]?) -> Void) {
        guard let cardsEndpoint = URL(string: "\(endpointPath)/cards") else{fatalError()}
        
        let urlSession = URLSession.shared
        
        _ = urlSession.dataTask(with: cardsEndpoint) { (data, response, error) in
            guard
                let error = error
                else {
                    guard
                        let unwrappedData = data,
                        let dataJson = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments),
                        let json = dataJson as? [String: Any],
                        let resData = json["data"] as? [[String:Any]]
                        else {
                            print(response.debugDescription)
                            completion(nil)
                            return
                    }
                    
                    let cards = resData.compactMap( {
                        Card(fromDictionary: $0)
                    })
                    completion(cards)
                    return
                    
            }
            
            print(error.localizedDescription)
            completion(nil)
            return
            
            }.resume()
        
    }

    
}

