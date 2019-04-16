//
//  cardsTableViewCell.swift
//  hearthstoneWiki
//
//  Created by Enrique Dutra on 13/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import UIKit

class cardsTableViewCell: UITableViewCell {

    @IBOutlet weak var rarityImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardRarityLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
