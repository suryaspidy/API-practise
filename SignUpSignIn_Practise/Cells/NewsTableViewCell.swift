//
//  NewsTableViewCell.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 25/05/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageArea: UIImageView!
    @IBOutlet weak var titleArea: UILabel!
    @IBOutlet weak var autherNameArea: UILabel!
    @IBOutlet weak var timeArea: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
