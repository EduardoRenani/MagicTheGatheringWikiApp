//
//  DataRequest.swift
//  hearthstoneWiki
//
//  Created by Eduardo Ribeiro on 12/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import Foundation


struct Card {
    let name: String
    let type: String
//    let cost: Int
    let rarity: String
    let imagePathSmall: String
    let imagePathBig: String
    
    init?(fromDictionary dictionary: [String: Any]) {
        guard
            let name = dictionary["name"] as? String,
            //let colors = dictionary["colors"] as? [String],
            let type = dictionary["type_line"] as? String,
            let rarity = dictionary["rarity"] as? String,
            let imageURL = dictionary["image_uris"] as? [String: String],
            let imagePathSmall = imageURL["border_crop"],
            let imagePathBig = imageURL["border_crop"]
        else{
            return nil
        }
        self.name = name
        //self.colors = colors
        self.type = type
        self.rarity = rarity
        self.imagePathSmall = imagePathSmall
        self.imagePathBig = imagePathBig
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

