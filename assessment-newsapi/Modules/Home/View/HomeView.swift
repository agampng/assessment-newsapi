//
//  HomeView.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import UIKit

class HomeView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: HomePresenter?
    private var category: Category = .all
    private var page: Int = 1
    private var listNews: [Article?] = [] {
        didSet {
            print("didset")
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .dark
        print("wjwkwk")
        self.title = "Headline News"
        loadNews(category: category, page: 1)
        setup(tableView)
        setup(collectionView)
    }
}

extension HomeView {
    internal func loadNews(category: Category, page: Int) {
        guard let presenter else { return }
        Task {
            let news = await presenter.getHeadlineNews(category: category, page: page)
            switch news {
            case .success(let data):
                guard let articles = data.articles else { return }
//                print(success)
                if page == 1 {
                    listNews = articles
                } else {
                    listNews.append(contentsOf: articles)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    internal func loadNextNews() {
        page += 1
        loadNews(category: category, page: page)
    }
    
    internal func setup(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
//        tableView.refreshControl?.addTarget(self,
//                                            action: #selector(handleRefreshControl(_:)),
//                                            for: .valueChanged)
        tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    internal func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewsCategoryCVC.nib, forCellWithReuseIdentifier: NewsCategoryCVC.identifier)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        if let viewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            viewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
    }
}

extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self), for: indexPath) as? NewsTableViewCell,
              let data = listNews[indexPath.row]
        else { return UITableViewCell() }
        
        cell.setupData(data)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (listNews.count - indexPath.row) < 2 {
            print("start fetch")
            loadNextNews()
        }
    }
}
    


extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCategoryCVC.identifier, for: indexPath) as? NewsCategoryCVC else {
                return UICollectionViewCell()
            }

        cell.titleLabel.text = Category.allCases[indexPath.row].text
        cell.backgroundColor = cell.isSelected ? .blue : .clear
        cell.selectedBackgroundView?.backgroundColor = .blue
        
        print(cell.isSelected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        category = Category.allCases[indexPath.row]
        loadNews(category: category, page: 1)
        tableView.setContentOffset(.zero, animated: true)
    }
}

