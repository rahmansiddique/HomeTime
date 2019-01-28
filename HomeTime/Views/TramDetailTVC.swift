//
//  TramDetailTVC.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import UIKit

class TramDetailTVC: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    
    // MARK: - Methods - Overridden
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Cell Configuration Method
    func configCell(tram:Tram){
        destinationLabel.text = tram.destination!
        arrivalTimeLabel.text = tram.getCurrentTimeDifference()
    }
}
