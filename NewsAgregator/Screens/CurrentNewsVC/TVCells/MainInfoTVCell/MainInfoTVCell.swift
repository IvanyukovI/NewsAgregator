//
//  MainInfoTVCell.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit
import SDWebImage

class MainInfoTVCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
   
    var str = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        cellView.layer.cornerRadius = 16
        imgView.layer.cornerRadius = 16
    }
    
    func set(autor: [String], date: String, img: String ) {
        autor.forEach { txt in
            str = str + txt
        }
        autorLabel.text = str == "" ? "Author unknown" : str
        dateLabel.text = date
        if let url = URL(string: img) {
            imgView.sd_setImage(with: url)
            imgView.isHidden = false
        } else {
            imgView.isHidden = true
        }
    }

}
