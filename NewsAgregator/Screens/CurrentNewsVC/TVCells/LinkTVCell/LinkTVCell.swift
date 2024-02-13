//
//  LinkTVCell.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit

class LinkTVCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var linkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        linkBtn.layer.cornerRadius = 16
    }
    
}
