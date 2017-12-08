//
//  ApiService.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-06.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiService {
    static let sharedInstance = ApiService()
    
    func downloadTrendingGifs(withOffset offset:Int, completion:@escaping CompletionHandlerAPI) {
        
        Alamofire.request(URL_TRENDING(offset), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON(completionHandler: { (responseJSON) in
            
            if responseJSON.result.error == nil {
                guard let data = responseJSON.data else {return}
                self.parseGifData(data: data, completion: completion)
            }
            else {
                completion(nil)
                debugPrint(responseJSON.result.error as Any)
            }
        })
    }
    
    func searchGifs(withOffset offset:Int,withSearchStr searchStr:String, completion:@escaping CompletionHandlerAPI) {
        
        Alamofire.request(URL_SEARCH(searchStr, offset), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON(completionHandler: { (responseJSON) in
            
            if responseJSON.result.error == nil {
                guard let data = responseJSON.data else {return}
                self.parseGifData(data: data, completion: completion)
            }
            else {
                completion(nil)
                debugPrint(responseJSON.result.error as Any)
            }
        })
    }
    
    func parseGifData(data:Data, completion:@escaping CompletionHandlerAPI) {
        let json = try! JSON(data:data)
        let arrData = json["data"].arrayValue
        var arrGiphyImages = [Giphy]()
        
        if arrData.count > 0 {
            for item in arrData {
                let id = item["id"].stringValue
                
                let fetchedFavourite = CoreDataManager.sharedInstance.fetchGiphyFromDatabaseWithId(id: id)
                var isFavourite = false
                if let favourite = fetchedFavourite {
                    isFavourite = true;
                }
                
                guard let dictImages = item["images"].dictionary else {return}
                guard let image = dictImages["fixed_height"]?.dictionary else {return}
                guard let imageUrl = image["url"]?.stringValue else {return}
                arrGiphyImages.append(Giphy(id: id, url: imageUrl, isFavourite: isFavourite))
            }
        }
        completion(arrGiphyImages)
    }
    
}

