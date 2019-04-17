//
//  cardCopyTableViewCell.swift
//  hearthstoneWiki
//
//  Created by Eduardo Ribeiro on 17/04/19.
//  Copyright © 2019 Eduardo Ribeiro. All rights reserved.
//

import UIKit

class cardCopyTableViewCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardRarityLabel: UILabel!
    @IBOutlet weak var cardImageRarity: UIImageView!
    @IBOutlet weak var numberOfCopies: UILabel!
    
    var card: Card?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
