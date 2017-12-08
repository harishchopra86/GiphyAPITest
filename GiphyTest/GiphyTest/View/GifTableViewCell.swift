//
//  GifTableViewCell.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-07.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import UIKit
import Kingfisher

class GifTableViewCell: UITableViewCell {

    @IBOutlet weak var gifImgVw: UIImageView!
    @IBOutlet weak var favouriteBtn: CustomButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteBtn.addTarget(HomeVC(), action:#selector(HomeVC.favouriteBtntapped) , for: .touchUpInside)

    }

    func configureCell(giphy:Giphy, indexPath:IndexPath) {
        let imageUrl = URL(string: giphy.url)
        gifImgVw.kf.setImage(with: imageUrl)
        favouriteBtn.indexPath = indexPath
        if giphy.isFavourite {
            favouriteBtn.backgroundColor = UIColor.red
        } else {
            favouriteBtn.backgroundColor = UIColor.lightGray
        }
    }
    
}
 
