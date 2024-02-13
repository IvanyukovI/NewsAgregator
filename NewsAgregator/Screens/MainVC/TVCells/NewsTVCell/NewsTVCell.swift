//
//  NewsTVCell.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit
import SDWebImage

class NewsTVCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var ddescriptionLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    var str = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        cellView.layer.cornerRadius = 16
        imageV.layer.cornerRadius = 16
    }
    
    func set(name: String, autor: [String], date: String, text: String, imgUrl: String) {
        str = ""
        nameLabel.text = name
        autor.forEach { txt in
            str = str + txt
        }
        autorLabel.text = str == "" ? "Author unknown" : str
        ddescriptionLabel.text = text
        dataLabel.text = date
        if let url = URL(string: imgUrl) {
            imageV.sd_setImage(with: url)
            imageV.isHidden = false
        } else {
            imageV.isHidden = true
        }
    }

}
