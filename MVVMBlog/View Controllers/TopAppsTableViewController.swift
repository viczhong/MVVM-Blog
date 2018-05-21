//
//  TopAppsTableViewController.swift
//  MVVMBlog
//
//  Created by Erica Millado on 6/16/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import UIKit

class TopAppsTableViewController: UITableViewController {
    
    //1 - 
    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModel()

        //2 - 
        viewModel.getApps() {
            
            //3 - 
            self.tableView.reloadData()
        }
    }

    func initializeViewModel() {
        viewModel = ViewModel(with: APIClient())
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsToDisplay(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.imageView?.image = nil
        cell.textLabel?.text = viewModel.appTitleToDisplay(for: indexPath)
        cell.detailTextLabel?.text = viewModel.genreToDisplay(for: indexPath)

        viewModel.imageToDisplay(for: indexPath) {
            cell.imageView?.image = $0
            cell.setNeedsLayout()
        }
        
        return cell
    }
}
