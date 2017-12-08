//
//  GifCollectionViewCell.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-07.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImgVw: UIImageView!
    @IBOutlet weak var favouriteBtn: CustomButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteBtn.addTarget(FavouritesVC(), action:#selector(FavouritesVC.favouriteBtntapped) , for: .touchUpInside)
        
    }

    func configureCell(favouriteGif:Favourites, indexPath:IndexPath) {
        let imageUrl = URL(string: favouriteGif.url!)
        gifImgVw.kf.setImage(with: imageUrl)
        favouriteBtn.indexPath = indexPath
        favouriteBtn.backgroundColor = UIColor.red
    }
    
    
}
