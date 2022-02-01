//
//  ViewController.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 23.01.22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main, tv
    }
    
    var filmModel: [Results] = []
    var tvModel: [ResultsTv] = []
    
    var bookmarkFilm: [Int] = []
    var bookmarkTv: [Int] = []
    
    var collectionView: UICollectionView! = nil
    let loader: ServiceProtocol = Service()
    
    var actView = UIActivityIndicatorView()
    
    var dataSource: UICollectionViewDiffableDataSource<SectionKind, AnyHashable>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<SectionKind, AnyHashable>! = nil
    
    static let titleElementKind = "title-element-kind"
    private var urlPoster = "https://image.tmdb.org/t/p/original/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vonkad"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isOpaque = true
        view.backgroundColor = .init(red: 18/255, green: 19/255, blue: 25/255, alpha: 1)
        configureHierarchy()
        loadData()
    }
}

extension ViewController {
    private func loadData() {
        loader.getDataFilms(urlString: loader.urlFilms) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.filmModel = model.results
                    self.reloadData()
                case .failure(_):
                    self.createAlertView(title: "Сбой загрузки фильмов!", massage: "Проверьте подключение к интернету")
                }
            }
        }
        
        loader.getDataTv(urlString: loader.tvUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.tvModel = model.results
                    self.reloadData()
                case .failure(_):
                    self.createAlertView(title: "Сбой загрузки сериалов!", massage: "Проверьте подключение к интернету")
                }
            }
        }
    }
}

//MARK: - create collectionView
extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.orthogonalScrollingBehavior = .paging
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .init(red: 18/255, green: 19/255, blue: 25/255, alpha: 1)
        collectionView.delegate = self
        collectionView.register(FilmCell.self, forCellWithReuseIdentifier: FilmCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: ViewController.titleElementKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        actView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        actView.startAnimating()
        view.addSubview(actView)
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionKind, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCell.reuseIdentifier, for: indexPath) as! FilmCell
            cell.imageView.kf.indicatorType = .activity
            let imageView = cell.imageView
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true
            let section = SectionKind(rawValue: indexPath.section)!
            
            switch section {
            case .tv:
                let dat = model as! ResultsTv
                
                let urlString = self.urlPoster + (dat.poster_path ?? "")
                guard let url = URL(string: urlString) else {
                    cell.addData(title: dat.name, data: dat.first_air_date ?? "")
                    return cell
                }
                KF.url(url)
                    .fade(duration: 1)
                    .set(to: imageView)
                cell.addData(title: dat.name, data: dat.first_air_date ?? "")
                return cell
            case .main:
                let dat = model as! Results
                
                let urlString = self.urlPoster + dat.poster_path
                let url = URL(string: urlString)!
                KF.url(url)
                    .fade(duration: 1)
                    .set(to: imageView)
                cell.addData(title: dat.title, data: dat.release_date)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, index) in
            let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: index) as! TitleSupplementaryView
            
            let section = SectionKind(rawValue: index.section)!
            
            switch section {
            case .tv:
                supplementary.label.text = "Популярные сериалы"
                return supplementary
            case .main:
                supplementary.label.text = "Популярные фильмы"
                return supplementary
            }
        }
    }
    
    private func reloadData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<SectionKind, AnyHashable>()
        
        SectionKind.allCases.forEach { (sectionKind) in
            switch sectionKind {
            case .main:
                currentSnapshot.appendSections([.main])
                currentSnapshot.appendItems(filmModel)
            case .tv:
                currentSnapshot.appendSections([.tv])
                currentSnapshot.appendItems(tvModel)
            }
        }

        dataSource.apply(currentSnapshot, animatingDifferences: false)
        self.actView.stopAnimating()
        self.actView.isHidden = true
    }
}

//MARK: - createAlertView
extension ViewController {
    private func createAlertView(title: String, massage: String) {
        let allert = UIAlertController.init(title: title, message: massage, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Обновить", style: .default) { _ in
            self.loadData()
        }
        
        allert.addAction(reloadAction)
        present(allert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = SectionKind(rawValue: indexPath.section)!
        
        switch section {
        case .tv:
            guard let tv = self.dataSource.itemIdentifier(for: indexPath) as? ResultsTv else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            let detailViewController = MovieViewController(id: tv.id, isFilm: false)
            detailViewController.delegate = self
            for makr in bookmarkTv {
                if makr == tv.id {
                    detailViewController.isAddBookMark = true
                }
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
        case .main:
            guard let film = self.dataSource.itemIdentifier(for: indexPath) as? Results else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            let detailViewController = MovieViewController(id: film.id, isFilm: true)
            detailViewController.delegate = self
            for makr in bookmarkFilm {
                if makr == film.id {
                    detailViewController.isAddBookMark = true
                }
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This will cancel all unfinished downloading task when the cell disappearing.
        (cell as! FilmCell).imageView.kf.cancelDownloadTask()
    }
    
    
    
}

//MARK: - MovieViewControllerDelegate
extension ViewController: MovieViewControllerDelegate {
    func addBookmark(_ id: Int, isFilm: Bool) {
        isFilm ? bookmarkFilm.append(id) : bookmarkTv.append(id)
    }
    func removeBookmark(_ id: Int, isFilm: Bool) {
        if isFilm {
            bookmarkFilm = bookmarkFilm.filter{$0 != id}
        } else {
            bookmarkTv = bookmarkTv.filter{$0 != id}
        }
    }
}

