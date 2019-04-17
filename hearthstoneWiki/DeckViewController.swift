//
//  DeckViewController.swift
//  hearthstoneWiki
//
//  Created by Enrique Dutra on 17/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import UIKit

class DeckViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    private let cardCellIdentifier = "cardIdentifier"
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let logoContainer = UIView(frame: CGRect(x: 0, y: -5, width: 300, height: 90))
        let imageView = UIImageView(frame: CGRect(x: 0, y: -5, width: 300, height: 90))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "magic")
        imageView.image = image
        logoContainer.addSubview(imageView)
        self.navBar.titleView?.removeFromSuperview()
        self.navBar.titleView = logoContainer
        
        super.viewWillAppear(animated)
        let _cards = Decklist.standard.list.values
        cards = _cards.compactMap( {
            Card(name:  $0.name, type: $0.type, cost: $0.cost, rarity: $0.rarity, imagePath: $0.imagePath, oracleText: $0.oracleText, numberOfCopies: $0.numberOfCopies)
        })
        tableView.reloadData()
    }

}

extension DeckViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToDeck = UITableViewRowAction(style: .default, title: "Add") { (action, indexpath) in
            let cell = tableView.cellForRow(at: indexPath) as? cardsTableViewCell
            let cardData = cell?.card
            Decklist.standard.insertCard(card: cardData!)
        }
        addToDeck.backgroundColor = UIColor(displayP3Red: 239/255, green: 143/255, blue: 40/255, alpha: 255/255)
        
        return [addToDeck]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cardCellIdentifier, for: indexPath) as? cardCopyTableViewCell else {return UITableViewCell()}
        
        let card = cards[indexPath.row]
        
        cell.cardNameLabel.text = card.name
        cell.cardRarityLabel.text = card.rarity
        cell.cardTypeLabel.text = card.type
        cell.cardImageView.image(fromUrl: card.imagePathSmall)
        //cell.numberOfCopies.text = "\(card.numberOfCopies)x"
        cell.card = card
        
        switch card.rarity {
        case "common":
            cell.cardImageRarity.image = UIImage(named: "logo-black")
        case "uncommon":
            cell.cardImageRarity.image = UIImage(named: "logo-blue")
        case "rare":
            cell.cardImageRarity.image = UIImage(named: "logo-yellow")
        case "mythic":
            cell.cardImageRarity.image = UIImage(named: "logo_orange")
        default:
            cell.cardImageRarity.image = UIImage(named: "logo-black")
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let param = sender as? Card
            guard let nextViewController = segue.destination as? DetailSceneViewController else {fatalError()}
            nextViewController.card = param
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt : IndexPath) {
        let cell = tableView.cellForRow(at: didSelectRowAt) as? cardCopyTableViewCell
        let cardData = cell?.card
        performSegue(withIdentifier: "showDetails", sender: cardData)
    }
    
}

