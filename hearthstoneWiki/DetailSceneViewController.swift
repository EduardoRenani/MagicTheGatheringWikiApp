//
//  detailSceneViewController.swift
//  hearthstoneWiki
//
//  Created by Enrique Dutra on 16/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import UIKit

class DetailSceneViewController: UIViewController {

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true) {
            return
        }
    }
    
    //@IBOutlet weak var cardRarityLabel: UILabel!
    //@IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
//    @IBOutlet weak var pageTitleLabel: UINavigationItem!
    var card: Card?
    override func viewDidLoad() {
        super.viewDidLoad()
        //cardNameLabel.text = card?.name
        //cardRarityLabel.text = card?.rarity
        cardImageView.image(fromUrl: card!.imagePathBig)
    }


}
