//
//  Constants.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-06.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import UIKit

// Completion Handlers
typealias CompletionHandlerAPI = (_ arrGifs:[Giphy]?) -> ()
typealias CompletionHandlerDatabase = (_ Success: Bool) -> ()
typealias CompletionHandlerDatabaseWithFavourites = (_ arrfavourites:[Favourites]?) -> ()


// Class Constants
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

//URL Constants
let API_KEY_GIPHY = "qLmAfipCXCYSokMJM1n1wvEHrYfAA5B6"
let BASE_URL = "https://api.giphy.com/v1/"
let URL_SEARCH:(String,Int) -> String = {searchString, offset in return String(format: "%@%@%@%@%@%@%d%@", BASE_URL, "gifs/search?api_key=", API_KEY_GIPHY,"&q=",searchString,"&limit=25&offset=", offset, "&rating=G&lang=en")}
let URL_TRENDING:(Int) -> String = {offset in return String(format: "%@%@%@%@%d%@", BASE_URL, "gifs/trending?api_key=", API_KEY_GIPHY,"&limit=25&offset=",offset,"&rating=G&lang=en")}

//Headers

let HEADER = [
    "Content-Type":"application/json; charset=utf-8",
]

//Other Constants

let SCREEN_WIDTH = UIScreen.main.bounds.width
