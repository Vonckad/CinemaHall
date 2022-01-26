//
//  ViewController.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 23.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main, tv
    }
    
    var filmModel: [Results] = []
    var tvModel: [ResultsTv] = []
    
    var collectionView: UICollectionView! = nil
    let loader: ServiceProtocol = Service()
    
    var dataSource: UICollectionViewDiffableDataSource<SectionKind, AnyHashable>! = nil
    
    static let titleElementKind = "title-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vonkad"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        configureHierarchy()
        
        loader.getDataFilms(urlString: loader.urlFilms) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.filmModel = model.results
                    self.reloadData()
                case .failure(_):
                    fatalError("error load")
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
                    fatalError("error load tv")
                }
            }
        }
    }
}

extension ViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

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
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
        collectionView.register(FilmCell.self, forCellWithReuseIdentifier: FilmCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: ViewController.titleElementKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionKind, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCell.reuseIdentifier, for: indexPath) as! FilmCell
            
            let section = SectionKind(rawValue: indexPath.section)!
            
            switch section {
            case .tv:
                let dat = model as! ResultsTv
                cell.addData(title: dat.name, data: dat.first_air_date)
                return cell
            case .main:
                let dat = model as! Results
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
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, AnyHashable>()
        
        SectionKind.allCases.forEach { (sectionKind) in
            switch sectionKind {
            case .main:
                snapshot.appendSections([.main])
                snapshot.appendItems(filmModel)
            case .tv:
                snapshot.appendSections([.tv])
                snapshot.appendItems(tvModel)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

