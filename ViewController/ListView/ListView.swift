//
//  ListView.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 18/02/22.
//

import UIKit
import Network
import CoreData

class ListView: UITableViewController {

    // MARK: - Properties/ Variables
    let wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    let cellMonitor = NWPathMonitor(requiredInterfaceType:.cellular)
    let searchController = UISearchController(searchResultsController: nil)
    // Central Park, NYC coordinates
    let CPLatitude: Double = 40.782483
    let CPLongitude: Double = -73.963540
    var networkManager = NetworkManager()
    var venues: [Venue] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        setupTableView()
        setupSearchBar()
        setupNavigation()
        networkManager.fetchData(latitude: CPLatitude, longitude: CPLongitude, category: "food", limit: 50, sortBy: "distance", locale: "en_US") {
            (response, error) in
            if let response = response {
                self.venues = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        wifiMonitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                //Core data
                let appDel = (UIApplication.shared.delegate) as! AppDelegate
                let offlineData = appDel.coreDataObject.fetchData()
                self.venues = offlineData as! [Venue]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let queue = DispatchQueue (label: "wifiMonitor")
        wifiMonitor.start(queue: queue)
        
        cellMonitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                //Core data
            }
        }
        let cellQueue = DispatchQueue (label: "cellMonitor")
        cellMonitor.start(queue: cellQueue)

    }
    func setupTableView () {
        tableView.register(ListViewCell.self, forCellReuseIdentifier: "YelpCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200;
        //tableView.backgroundView  = noDataLabel
        tableView.tableFooterView = UIView()
        tableView.backgroundView?.isHidden = true
    }

    func setupSearchBar () {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
       // searchController.searchBar.text = dataManager.searchString
    }
    
    func setupNavigation() {
        //self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Food / Restaurants"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked(sender:)))

    }
    
   @objc func cancelClicked(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YelpCell", for: indexPath)  as? ListViewCell else {
            return UITableViewCell()
        }
        
        if ((venues.count) != 0) {
            cell.titleLabel.text = venues[indexPath.row].name
            cell.detailLabel.text = venues[indexPath.row].price

            let imagepath = URL(string: venues[indexPath.row].image_url!)!
            cell.restaurantImageView.loadImage(fromURL: imagepath, placeHolderImage: "PreviewImage")
        }
        else {
            cell.titleLabel.text = "No Data"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = DetailViewController(venues[indexPath.row])
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}


// MARK: - UISearchBarDelegate
extension ListView : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let pretext = searchBar.text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if searchBar.text == pretext {
                let searchText = searchBar.text?.removingWhitespaces() ?? "SFO"
                self.networkManager.fetchDataOnSearchQuery(searchQuery:searchText) {
                    (response, error) in
                    if let response = response {
                        self.venues = response
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }

        searchBar.resignFirstResponder()
        searchController.dismiss(animated: true, completion: nil)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func scrollToTop() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
