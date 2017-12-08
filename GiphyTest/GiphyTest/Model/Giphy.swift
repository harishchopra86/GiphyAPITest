//
//  Giphy.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-06.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import Foundation

class Giphy {
    public private(set) var id:String!
    public private(set) var url:String!
    public private(set) var isFavourite:Bool!
    
    init(id:String, url:String, isFavourite:Bool) {
        self.id = id
        self.url = url
        self.isFavourite = isFavourite
    }
    
    func setFavouriteValue(isFavourite:Bool) {
        self.isFavourite = isFavourite
    }
}
