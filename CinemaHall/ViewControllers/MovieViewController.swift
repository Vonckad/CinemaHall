//
//  MovieViewController.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 26.01.22.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {
    
    let id: Int
    let isFilm: Bool
    init(id: Int, isFilm: Bool) {
        self.id = id
        self.isFilm = isFilm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scrollView: UIScrollView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var overviewLabel: UILabel!
    var imageView: UIImageView!
    var backgroundView: UIView!
    var castLabel: UILabel!
    var castCollectionView: UICollectionView!
    
    let loader: ServiceProtocol = Service()
    var castsModel: [ResultCastFilm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()
        if isFilm {
            DispatchQueue.global().async {
                self.loader.loadFilm(id: self.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            self.reloadData(dataFilm: data)
                        case .failure(_):
                            fatalError("error load film id = \(self.id)")
                        }
                    }
                }
                self.loader.loadCastFilm(id: self.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            self.reloadCasts(casts: data)
                        case .failure(_):
                            fatalError("error load cast for film id = \(self.id)")
                        }
                    }
                }
            }
        } else {
            DispatchQueue.global().async {
                self.loader.loadTv(id: self.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            self.reloadData(dataTv: data)
                        case .failure(_):
                            fatalError("error load film id = \(self.id)")
                        }
                    }
                }
                self.loader.loadCastTv(id: self.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            self.reloadCasts(casts: data)
                        case .failure(_):
                            fatalError("error load cast for film id = \(self.id)")
                        }
                    }
                }
            }
        }
    }
}
//MARK: - configure content
extension MovieViewController {
    private func reloadData(dataFilm: Results? = nil, dataTv: ResultsTv? = nil) {
        if let dataFilm = dataFilm {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(dataFilm.poster_path)")!
            KF.url(url)
                .fade(duration: 1)
                .set(to: imageView)
            self.setText(title: dataFilm.title, description: dataFilm.release_date, overview: dataFilm.overview)
        } else if let dataTv = dataTv {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(dataTv.poster_path!)")!
            KF.url(url)
                .fade(duration: 1)
                .set(to: imageView)
            self.setText(title: dataTv.name, description: dataTv.first_air_date, overview: dataTv.overview)
        }
    }
    
    private func reloadCasts(casts: CastFilmModel) {
        castsModel = casts.cast
        castCollectionView.reloadData()
    }
    
    private func setText(title: String, description: String, overview: String) {
        nameLabel.text = title
        descriptionLabel.text = description
        overviewLabel.text = overview
    }
}

// MARK: - set up view hierarchy
extension MovieViewController {
    fileprivate func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .init(red: 18/255, green: 19/255, blue: 25/255, alpha: 1)
        
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 40.0)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .headline)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center
        
        overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .lightGray
        overviewLabel.textAlignment = .justified
        
        castLabel = UILabel()
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castLabel.text = "Cast"
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 140)
        flowLayout.scrollDirection = .horizontal
        castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        castCollectionView.isPagingEnabled = true
        castCollectionView.showsHorizontalScrollIndicator = false
        castCollectionView.backgroundColor = .init(red: 18/255, green: 19/255, blue: 25/255, alpha: 1)
        castCollectionView.register(FilmCell.self, forCellWithReuseIdentifier: "CastCell")
        castCollectionView.dataSource = self
        castCollectionView.delegate = self

        self.view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(overviewLabel)
        scrollView.addSubview(castLabel)
        scrollView.addSubview(castCollectionView)
        
        imageView.kf.indicatorType = .activity
        
        // configure constraints
        let topImageViewConstrain = view.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 44)
        topImageViewConstrain.priority = .init(rawValue: 900)
        
        NSLayoutConstraint.activate([
            
            topImageViewConstrain,
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            descriptionLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 350),
            nameLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: castCollectionView.bottomAnchor),//
            scrollView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            scrollView.rightAnchor.constraint(equalTo: overviewLabel.rightAnchor, constant: 8),
            
            castLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            castLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            
            castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 8),
            castCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: castCollectionView.trailingAnchor),
            castCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! FilmCell
        guard let castName = castsModel[indexPath.row].name else { return cell }
        guard let castPhoto = castsModel[indexPath.row].profile_path else { return cell }
        guard let castCharacter = castsModel[indexPath.row].character else { return cell }
        cell.imageView.kf.indicatorType = .activity
       
        let imView = cell.imageView
        imView.layer.cornerRadius = 50
        imView.clipsToBounds = true
        imView.contentMode = .scaleAspectFill
        
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(castPhoto)")!
        KF.url(url)
            .fade(duration: 1)
            .set(to: imView)
        cell.titleLabel.numberOfLines = 1
        cell.titleLabel.text = castName
        cell.categoryLabel.text = castCharacter
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This will cancel all unfinished downloading task when the cell disappearing.
        (cell as! FilmCell).imageView.kf.cancelDownloadTask()
    }
}
