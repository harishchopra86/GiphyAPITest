//
//  ViewController.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-06.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
   
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var gifTableVw: UITableView!
   // Variables
    var arrGiphyImages = [Giphy]()
    var offset = 0
    var searchString = ""
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifTableVw.addInfiniteScrolling {
            if self.isSearching {
                ApiService.sharedInstance.searchGifs(withOffset: self.offset, withSearchStr: self.searchString) { (arrGiphy) in
                    if let unwrappedArrGiphy = arrGiphy {
                        self.offset = self.offset + unwrappedArrGiphy.count
                        self.arrGiphyImages.append(contentsOf: unwrappedArrGiphy)
                        DispatchQueue.main.async {
                            self.gifTableVw.infiniteScrollingView.stopAnimating()
                            self.gifTableVw.reloadData()
                        }
                    }
                }
            }
            else {
                ApiService.sharedInstance.downloadTrendingGifs(withOffset: self.offset) { (arrGiphy) in
                    APP_DELEGATE.hideloadingView()
                    if let unwrappedArrGiphy = arrGiphy {
                        self.offset = self.offset + unwrappedArrGiphy.count
                        self.arrGiphyImages.append(contentsOf: unwrappedArrGiphy)
                    }
                    DispatchQueue.main.async {
                        self.gifTableVw.infiniteScrollingView.stopAnimating()

                        self.gifTableVw.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isSearching {
            searchGifsFromAPI()
        }
        else {
            fetchTrendingGifsFromAPI()
        }
    }
    
    func fetchTrendingGifsFromAPI() {
        self.offset = 0
        self.arrGiphyImages.removeAll()

        APP_DELEGATE.showLoadingView()
        ApiService.sharedInstance.downloadTrendingGifs(withOffset: offset) { (arrGiphy) in
            APP_DELEGATE.hideloadingView()
            if let unwrappedArrGiphy = arrGiphy {
                self.offset = self.offset + unwrappedArrGiphy.count
                self.arrGiphyImages.append(contentsOf: unwrappedArrGiphy)
            }
            DispatchQueue.main.async {
                self.gifTableVw.reloadData()
            }
        }
    }
    
    func searchGifsFromAPI() {
        self.offset = 0
        self.arrGiphyImages.removeAll()
        
        APP_DELEGATE.showLoadingView()
        ApiService.sharedInstance.searchGifs(withOffset: offset, withSearchStr: searchString) { (arrGiphy) in
            APP_DELEGATE.hideloadingView()
            if let unwrappedArrGiphy = arrGiphy {
                if unwrappedArrGiphy.count > 0 {
                    self.offset = self.offset + unwrappedArrGiphy.count
                    self.arrGiphyImages.append(contentsOf: unwrappedArrGiphy)
                }
                else {
                    DispatchQueue.main.async {
                        UtilityMethods.showAlertFromVC(viewController: self, title: "Alert!", msg: "No GIFs found for your search, try searching something else.", completionHandler: {
                            self.gifSearchBar.becomeFirstResponder()
                        })
                    }
                }
                DispatchQueue.main.async {
                    self.gifTableVw.reloadData()
                }
            }
        }
        
    }
    
    @objc func favouriteBtntapped(_ sender: CustomButton) {
        let giphy = arrGiphyImages[sender.indexPath.row]
        if giphy.isFavourite {
            if let fetchedFavourite = CoreDataManager.sharedInstance.fetchGiphyFromDatabaseWithId(id: giphy.id) {
                CoreDataManager.sharedInstance.deleteFavouriteFromDatabase(favourite: fetchedFavourite, completion: { (success) in
                    if success {
                        self.updateGiphyIsFavourite(isFavourite: false, giphy: giphy, indexPath: sender.indexPath)
                    }
                })
            }
            else {
                self.updateGiphyIsFavourite(isFavourite: false, giphy: giphy, indexPath: sender.indexPath)
            }
        } else {
            CoreDataManager.sharedInstance.saveGiphyToDatabase(giphy: giphy, completion: { (success) in
                if success {
                    self.updateGiphyIsFavourite(isFavourite: true, giphy: giphy, indexPath: sender.indexPath)
                }
            })
        }
    }
    
    func updateGiphyIsFavourite(isFavourite:Bool, giphy:Giphy, indexPath:IndexPath) {
        giphy.setFavouriteValue(isFavourite: isFavourite)
        DispatchQueue.main.async {
            self.gifTableVw.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGiphyImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GifTableViewCell", for: indexPath) as? GifTableViewCell {
            cell.configureCell(giphy: arrGiphyImages[indexPath.row], indexPath: indexPath)
            return cell
        }
        return GifTableViewCell()
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.isSearching = false
        fetchTrendingGifsFromAPI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchString = searchBar.text!
        self.isSearching = true
        searchGifsFromAPI()
    }
}


