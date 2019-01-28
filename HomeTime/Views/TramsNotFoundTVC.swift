//
//  TramsNotFoundTVC.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import UIKit

class TramsNotFoundTVC: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    
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
    func configCell(message:String){
        messageLabel.text = message
    }
    
}
