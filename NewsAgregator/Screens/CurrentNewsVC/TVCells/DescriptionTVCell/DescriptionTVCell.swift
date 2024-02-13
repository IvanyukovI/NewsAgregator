//
//  DescriptionTVCell.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit

class DescriptionTVCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        cellView.layer.cornerRadius = 16
    }
    
    func set(descr: String) {
        descriptionLabel.text = descr
    }
    
}
