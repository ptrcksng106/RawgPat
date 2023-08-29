//
//  GameTableViewCell.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 22/08/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet var ratingGame: UILabel!
    @IBOutlet var dateGame: UILabel!
    @IBOutlet var titleGame: UILabel!
    @IBOutlet var imageGame: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageGame.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
