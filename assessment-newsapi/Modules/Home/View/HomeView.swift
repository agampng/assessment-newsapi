//
//  HomeView.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import UIKit

class HomeView: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Properties
    var presenter: HomePresenter?
    private var category: Category = .all
    private var searchQuery: String?
    private var page: Int = 1
    private var hasNextPage: Bool = true
    private var listNews: [Article?] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchBar.placeholder = "Type to search from NewsAPI"
        return sc
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Headline News"
        loadNews(category: category, page: 1, q: searchQuery)
        setup(tableView)
        setup(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
    }
}

extension HomeView {
    internal func loadNews(category: Category, page: Int, q: String?) {
        guard let presenter else { return }
        showLoading(true)
        searchController.dismiss(animated: true)
        
        Task {
            let news = await presenter.getHeadlineNews(category: category, page: page, q: q)
            switch news {
            case .success(let data):
                guard let articles = data.articles else { return }
                hasNextPage = !articles.isEmpty
                if page == 1 {
                    listNews = articles
                } else {
                    listNews.append(contentsOf: articles)
                }
            case .failure(let failure):
                listNews = []
                let alert = UIAlertController(title: "Error", message: failure.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            showLoading(false)
        }
    }
    
    internal func loadNextNews() {
        page += 1
        loadNews(category: category, page: page, q: searchQuery)
    }
    
    internal func setup(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl(_:)), for: .valueChanged)
        tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    internal func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewsCategoryCVC.nib, forCellWithReuseIdentifier: NewsCategoryCVC.identifier)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }
    
    func showLoading(_ show: Bool) {
        if show {
            spinner.startAnimating()
            spinner.isHidden = false
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    @objc
    func handleRefreshControl(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            self.page = 1
            self.loadNews(category: self.category, page: self.page, q: self.searchQuery)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - UISearchBarDelegate
extension HomeView: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text
        page = 1
        loadNews(category: category, page: page, q: searchQuery)
    }
}

//MARK: - UITableViewDelegate
extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter, let navigationController, let url = URL(string: listNews[indexPath.row]?.url ?? "") else { return }
        presenter.showSafari(url: url, on: navigationController)
    }
}

//MARK: - UITableViewDataSource
extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listNews.isEmpty ? tableView.setEmptyMessage("No News Found") : tableView.restore()
        return listNews.count
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
        guard hasNextPage, (listNews.count - indexPath.row) < 2 else { return }
        loadNextNews()
    }
}

//MARK: - UICollectionViewDelegate
extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCategoryCVC.identifier, for: indexPath) as? NewsCategoryCVC else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = Category.allCases[indexPath.row].text
        cell.backgroundColor = cell.isSelected ? .blue : .clear
        cell.selectedBackgroundView?.backgroundColor = .blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        category = Category.allCases[indexPath.row]
        page = 1
        loadNews(category: category, page: page, q: searchQuery)
        tableView.setContentOffset(.zero, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.allCases.count
    }
}

