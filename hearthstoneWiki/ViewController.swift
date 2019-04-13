//
//  ViewController.swift
//  hearthstoneWiki
//
//  Created by Eduardo Ribeiro on 12/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cardCellIdentifier = "cardIdentifier"
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        DataService.getCardsByColor(cardColor: "white") { (cards) in
            self.cards = cards ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView DataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCellIdentifier, for: indexPath)
        
        let card = cards[indexPath.row]

        cell.textLabel?.text = card.name
        cell.detailTextLabel?.text = card.rarity
        
        print(card.name)
        print(card.rarity)
        print(card.imagePath)
        print(card.colors)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
