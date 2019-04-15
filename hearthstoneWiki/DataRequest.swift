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
//    let colors: [String]
//    let cost: Int
    let rarity: String
//    let imagePath: URL
    
    init?(fromDictionary dictionary: [String: Any]) {
        guard
            let name = dictionary["name"] as? String,
            //let colors = dictionary["colors"] as? [String],
            //let cost = dictionary["cmc"] as? Int,
            let rarity = dictionary["rarity"] as? String
            //let imageURL = dictionary["imageUrl"] as? String,
            //let imagePath = URL(string: imageURL)
        else{
            return nil
        }
        self.name = name
        //self.colors = colors
        //self.cost = cost
        self.rarity = rarity
        //self.imagePath = imagePath
    }
    
}

struct DataService {
    
    private static let endpointPath = "https://api.scryfall.com"
    
    private static var cardsByColorEndpoint: URL? {
        return URL(string: "\(endpointPath)/cards/search?q=c:")
    }
    
    static func getCardsByColor(cardColor: String, completionHandler completion: @escaping ([Card]?) -> Void) {
        let _cardsEndpoint = cardsByColorEndpoint
        guard let cardsEndpoint = _cardsEndpoint?.appendingPathExtension(String(cardColor.prefix(0))) else {
            completion(nil)
            return
        }

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
    
}

