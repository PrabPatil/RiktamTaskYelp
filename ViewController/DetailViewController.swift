//
//  DetailViewController.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 18/02/22.
//

import UIKit

class DetailViewController: UIViewController {

    let restaurantDetails: Venue
    
    let restaurantImage : LazyLoading = {
        let image = LazyLoading()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Image")
        image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true

        image.clipsToBounds = true
        return image
    }()
    
    let restaurantName : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let restaurantAddress : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userRating : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let restaurantPrice : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let restaurantContactNumber : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
    
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
//        view.backgroundColor = UIColor(red: 232/255, green: 245/255, blue: 253/255, alpha: 1)
        return view
    }()

    init(_ restaurants: Venue) {
        self.restaurantDetails = restaurants
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewConstraints()
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    
    func setupViewConstraints () {
        //set up scroll view
        view.addSubview(scrollView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            ])
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])

        // set up text view and image
        let textStackView = UIStackView(arrangedSubviews: [restaurantName, restaurantAddress, userRating, restaurantPrice, restaurantContactNumber])
        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.distribution = .fill
        textStackView.spacing = 20
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStackView)
        contentView.addSubview(restaurantImage)
        contentView.addSubview(restaurantContactNumber)
        
        NSLayoutConstraint.activate([
            restaurantImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            restaurantImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            restaurantImage.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -20),
            restaurantContactNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            restaurantContactNumber.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            restaurantContactNumber.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 20),
            contentView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1),
            restaurantContactNumber.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        setUpView()
    }

    private func setUpView() {
        
        restaurantName.text = restaurantDetails.name
        restaurantContactNumber.text = "Contact : \((restaurantDetails.display_phone)!)"
        restaurantAddress.text = "Address : \((restaurantDetails.address) ?? "")"
        restaurantPrice.text = "Price : \((restaurantDetails.price) ?? "")"
        userRating.text = "Ratings : \((restaurantDetails.rating?.description)!)"
        
        guard let urlImage = URL(string: restaurantDetails.image_url ?? "No Image") else { return  }
        self.restaurantImage.loadImage(fromURL:urlImage , placeHolderImage: " ")

    }
}
