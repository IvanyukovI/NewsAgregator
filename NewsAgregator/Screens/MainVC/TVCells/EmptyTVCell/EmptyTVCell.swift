//
//  EmptyTVCell.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit

class EmptyTVCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        cellView.layer.cornerRadius = 16
    }
    
}
