//
//  UtilityMethods.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-07.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import UIKit

class UtilityMethods: NSObject {

    
    class func showAlertFromVC(viewController:UIViewController, title: String, msg: String, completionHandler:@escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                completionHandler()
            }
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showYesNoAlertFromVC(viewController:UIViewController, title: String, msg: String, completionHandler:@escaping (_ clickedButtonIndex:Int) -> ()) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                completionHandler(0)
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                completionHandler(1)
            }
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
