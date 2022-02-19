//
//  CollectionViewController.swift
//  RiktamTaskYelp

//  Created by Prabhu Patil on 18/02/22.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var searchByArray:[String] = ["Food", "Restaurants"]
    var showMoreCells:Bool = false
    var networkManager = NetworkManager()
    var venues: [Venue] = []
    let CPLatitude: Double = 40.782483
    let CPLongitude: Double = -73.963540

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        networkManager.fetchData(latitude: CPLatitude, longitude: CPLongitude, category: "food", limit: 50, sortBy: "distance", locale: "en_US") {
            (response, error) in
            if let response = response {
                self.venues = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UI Setup
extension CollectionViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white

        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthHeightConstant: CGFloat = 130.0
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.headerReferenceSize = CGSize(width: 150, height: 50)
        layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
        
        return layout
    }
}

// MARK: - UICollectionViewDelegate & Data Source
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
           return searchByArray.count
        }
        else if section == 1 {

            if (showMoreCells) {
                return venues.count
            }
            else {
                return 4
            }
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    
        if (indexPath.section == 0) {
            cell.restaurantName.text = searchByArray[indexPath.item]
            cell.locationName.text = ""
        }
        else {
            if (!showMoreCells) {
                if (indexPath.row == 3) {
                    cell.restaurantName.text = "View all "
                    cell.locationName.text = " "
                }
                else {
                if ((venues.count) != 0) {
                    cell.restaurantName.text = venues[indexPath.item].name?.maxLength(length: 11)
                    cell.locationName.text = venues[indexPath.row].address?.maxLength(length: 11)
                }
                else {
                    cell.restaurantName.text = " "
                    cell.locationName.text = " "
    
                }

                }
            }
            else {
                if ((venues.count) != 0) {
                    cell.restaurantName.text = venues[indexPath.item].name?.maxLength(length: 11)
                    cell.locationName.text = venues[indexPath.row].address?.maxLength(length: 11)
                }
                else {
                    cell.restaurantName.text = " "
                    cell.locationName.text = " "

                }

            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let rootVC = ListView()
            let navVc = UINavigationController(rootViewController: rootVC)

            presentInFullScreen(navVc, animated: true, completion: nil)
        }
        if (indexPath.row == 3) {
            showMoreCells = true
            collectionView.reloadData()
        }
    }
}

extension UIViewController {
  func presentInFullScreen(_ viewController: UIViewController,
                           animated: Bool,
                           completion: (() -> Void)? = nil) {
    viewController.modalPresentationStyle = .fullScreen
    present(viewController, animated: animated, completion: completion)
  }
}

extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           )
       }
       return  str
   }
}
