//
//  MovieViewController.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 26.01.22.
//

import UIKit

class MovieViewController: UIViewController {

    let name: String
    let data: String
    let navigationTitle: String
    
    init(name: String, data: String, navigationTitle: String) {
        self.name = name
        self.data = data
        self.navigationTitle = navigationTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emojiLabel: UILabel!
    var emojiDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up view hierarchy
        
        self.view.backgroundColor = .systemBackground
        
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 60.0)
        emojiLabel.numberOfLines = 0
        self.emojiLabel = emojiLabel
        
        let emojiDescription = UILabel()
        emojiDescription.translatesAutoresizingMaskIntoConstraints = false
        emojiDescription.font = .preferredFont(forTextStyle: .headline)
        emojiDescription.numberOfLines = 0
        self.emojiDescription = emojiDescription
        
        self.view.addSubview(emojiLabel)
        self.view.addSubview(emojiDescription)
        
        // configure constraints
        
        NSLayoutConstraint.activate([
            // vertical:
            emojiLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            emojiLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            emojiLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            emojiDescription.topAnchor.constraint(equalToSystemSpacingBelow: emojiLabel.bottomAnchor, multiplier: 1.0),
            // horizontal:
            emojiLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emojiDescription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emojiDescription.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.readableContentGuide.leadingAnchor)
        ])
        
        // configure content
        
        emojiLabel.text = name
        emojiDescription.text = data
        navigationItem.title = navigationTitle
    }
}
