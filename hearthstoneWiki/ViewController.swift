//
//  ViewController.swift
//  hearthstoneWiki
//
//  Created by Eduardo Ribeiro on 12/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cardCellIdentifier = "cardIdentifier"
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        DataService.getAllCards() { (cards) in
            self.cards = cards ?? []
            print(self.cards)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let logoContainer = UIView(frame: CGRect(x: 0, y: -5, width: 300, height: 90))
        let imageView = UIImageView(frame: CGRect(x: 0, y: -5, width: 300, height: 90))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "magic")
        imageView.image = image
        logoContainer.addSubview(imageView)
        self.navBar.titleView?.removeFromSuperview()
        self.navBar.titleView = logoContainer
    }
}

// MARK: - TableView DataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DataService.getCardsByName(cardName: searchBar.text ?? "") {
            (cards) in
            self.cards = cards ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToDeck = UITableViewRowAction(style: .default, title: "Add") { (action, indexpath) in
            let cell = tableView.cellForRow(at: indexPath) as? cardsTableViewCell
            let cardData = cell?.card
            Decklist.standard.insertCard(card: cardData!)
        }
        addToDeck.backgroundColor = .green
        return [addToDeck]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cardCellIdentifier, for: indexPath) as? cardsTableViewCell else {return UITableViewCell()}
        
        let card = cards[indexPath.row]

        cell.cardNameLabel.text = card.name
        cell.cardRarityLabel.text = card.rarity
        cell.cardTypeLabel.text = card.type
        cell.cardImageView.image(fromUrl: card.imagePathSmall)
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
        let cell = tableView.cellForRow(at: didSelectRowAt) as? cardsTableViewCell
        let cardData = cell?.card
        performSegue(withIdentifier: "showDetails", sender: cardData)
    }
    
}


extension UIImageView {
    public func image(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let theTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)
                }
            }
        }
        theTask.resume()
    }
}

