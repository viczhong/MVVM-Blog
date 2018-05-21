//
//  ViewModel.swift
//  MVVMBlog
//
//  Created by Erica Millado on 6/16/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import UIKit

//1 - Setup my viewModel that inherits from NSObject
class ViewModel: NSObject {
    enum UseCase {
        case test, actual
    }
    //2 - Create an apiClient property that we can use to call on our API call
    var apiClient = APIClient.manager
    
    //3 - Define an apps property that will hold the data from the iTunes RSS top 100 free apps feed
    //This array is marked an optional (?) because we might not get back data from the iTunes API
    var apps: [NSDictionary]?
    
    //4 - This function is what directly accesses the apiClient to make the API call
    func getApps(completion: @escaping () -> Void) {
        //5 - call on the apiClient to fetch the apps
        apiClient.fetchAppList { (arrayOfAppsDictionaries) in
            
            //6 - Put this block on the main queue because our completion handler is where the data display code will happen and we don't want to block any UI code.
            DispatchQueue.main.async {
                
                //7 - assign our local apps array to our returned json
                self.apps = arrayOfAppsDictionaries
                
                //8 - call our completion handler because it is in this completion that we will reload data in our view controller tableview
                completion()
            }
        }
    }
    
    // MARK: - values to display in our table view controller
    //9 -
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return apps?.count ?? 0
    }
    
    //10 -
    func appTitleToDisplay(for indexPath: IndexPath) -> String {
        return apps?[indexPath.row].value(forKeyPath: "name") as? String ?? ""
    }
    
    //11 -
    func genreToDisplay(for indexPath: IndexPath) -> String {
        let genres = apps?[indexPath.row].value(forKeyPath: "genres") as? [NSDictionary]
        return genres?[0].value(forKeyPath: "name") as? String ?? ""
    }

    func imageToDisplay(for indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {

        guard let urlString = apps?[indexPath.row].value(forKeyPath: "artworkUrl100") as? String else {
            return
        }

        apiClient.fetchImage(imageURL: urlString) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
