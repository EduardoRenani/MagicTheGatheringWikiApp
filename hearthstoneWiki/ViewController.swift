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
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        DataService.getCardsByName(cardName: searchText) {
//            (cards) in
//            print(searchText)
//            self.cards = cards ?? []
//            print(cards)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DataService.getCardsByName(cardName: searchBar.text ?? "") {
            (cards) in
            //print(searchBar.text)
            self.cards = cards ?? []
            print(cards)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
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
            cell.cardRarityLabel.textColor = UIColor(displayP3Red: 33/255, green: 33/255, blue: 33/255, alpha: 255/255)
        case "uncommon":
            cell.cardRarityLabel.textColor = UIColor(displayP3Red: 185/255, green: 220/255, blue: 270/255, alpha: 255/255)
        case "rare":
            cell.cardRarityLabel.textColor = UIColor(displayP3Red: 230/255, green: 205/255, blue: 140/255, alpha: 255/255)
        case "mythic":
            cell.cardRarityLabel.textColor = UIColor(displayP3Red: 245/255, green: 145/255, blue: 5/255, alpha: 255/255)
        default:
           cell.cardRarityLabel.textColor = UIColor(displayP3Red: 185/255, green: 220/255, blue: 270/255, alpha: 255/255)
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

