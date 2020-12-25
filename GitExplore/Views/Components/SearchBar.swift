//
//  SearchBar.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import UIKit

protocol SearchBarDelegate: class {
    func updateSearchBarHeight(with height: CGFloat)
    func showRepositoryDetails(for repository: RepositoryDetails)
}

class SearchBar: UIView {
    
    // MARK: Public properties
    
    weak var delegate: SearchBarDelegate?
    
    
    // MARK: Private properties
    
    private var searchOperationQueue = OperationQueue()
    private var searchViewModel: RepositorySearchViewModel?
    private let searchResultTableViewHeight: CGFloat = 200
    private var defaultHeight: CGFloat = 50
    
    
    // MARK: UI controls
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = NSLocalizedString(LocalizationKeys.search_placeholder, comment: "Seach bar placeholder text")
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = UIColor.black.withAlphaComponent(0.7)
        return indicatorView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.infinity, height: 20))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = self.headerView
        tableView.rowHeight = 25
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    // MARK: Lifecycle methods
    
    convenience init(seachViewModel: RepositorySearchViewModel, defaultHeight: CGFloat) {
        self.init()
        self.searchViewModel = seachViewModel
        self.defaultHeight = defaultHeight
        self.configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    
    // MARK: Public methods
    
    func endEditing() {
        self.searchBar.text = ""
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func clearSearchResults() {
        self.endEditing()
        self.searchViewModel?.clearSearchResults()
        self.removeSearchResultTableViewIfNeeded()
    }
    
    // MARK: Private methods
    
    private func configureView() {
        self.addSubview(self.searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.searchBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.searchBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.searchBar.heightAnchor.constraint(equalToConstant: self.defaultHeight)
        ])
        
        self.searchBar.addSubview(self.activityIndicatorView)
        NSLayoutConstraint.activate([
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor, constant: 0),
            self.activityIndicatorView.rightAnchor.constraint(equalTo: self.searchBar.rightAnchor, constant: -40),
            self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 20),
            self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureSearchResultTableView() {
        guard let searchedRepositories = self.searchViewModel?.searchedRepositories,
              !searchedRepositories.isEmpty else {
            self.removeSearchResultTableViewIfNeeded()
            return
        }
        self.addSearchResultTableView()
    }
    
    private func addSearchResultTableView() {
        guard self.searchResultTableView.superview == nil else {
            self.searchResultTableView.reloadData()
            return
        }
        
        self.addSubview(self.searchResultTableView)
        NSLayoutConstraint.activate([
            self.searchResultTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            self.searchResultTableView.leftAnchor.constraint(equalTo: self.searchBar.leftAnchor, constant: 13),
            self.searchResultTableView.rightAnchor.constraint(equalTo: self.searchBar.rightAnchor, constant: -13),
            self.searchResultTableView.heightAnchor.constraint(equalToConstant: self.searchResultTableViewHeight)
        ])
        self.searchResultTableView.reloadData()
        self.bringSubviewToFront(self.searchBar)
        
        let updatedHeight = self.bounds.height + self.searchResultTableViewHeight
        self.delegate?.updateSearchBarHeight(with: updatedHeight)
    }
    
    private func removeSearchResultTableViewIfNeeded() {
        if self.searchResultTableView.superview != nil {
            self.searchResultTableView.removeFromSuperview()
            self.sendSubviewToBack(self.searchBar)
            self.delegate?.updateSearchBarHeight(with: self.defaultHeight)
        }
    }
    
    private func searchRepositories(with keyword: String) {
        
        // Cancel existing serarch operation, if any
        if let viewModel = self.searchViewModel,
           viewModel.isSearchInProgress {
            self.searchOperationQueue.cancelAllOperations()
        }
        
        // Start search operation
        if !self.activityIndicatorView.isAnimating {
            self.activityIndicatorView.startAnimating()
        }
        
        let searchOperation = BlockOperation(block: {
            self.searchViewModel?.searchRepositories(with: keyword) { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    guard let strongSelf = self else { return }
                    strongSelf.activityIndicatorView.stopAnimating()
                    strongSelf.configureSearchResultTableView()
                }
            }
        })
        self.searchOperationQueue.addOperation(searchOperation)
    }
}


// MARK: Table view data source methods

extension SearchBar: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchedRepositories = self.searchViewModel?.searchedRepositories else { return 0 }
        return searchedRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchedRepositories = self.searchViewModel?.searchedRepositories else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        let repositoryDetails = searchedRepositories[indexPath.row]
        cell.textLabel?.textColor = .blue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell.textLabel?.text = "\(repositoryDetails.name) by \(repositoryDetails.owner.name)"
        return cell
    }
}

// MARK: Table view delegate methods

extension SearchBar: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchedRepositories = self.searchViewModel?.searchedRepositories else { return }
        
        self.removeSearchResultTableViewIfNeeded()
        self.clearSearchResults()
        
        let gitRepositoryDetails = searchedRepositories[indexPath.row]
        let repositoryDetails = RepositoryDetails(
            author: gitRepositoryDetails.owner.name,
            name: gitRepositoryDetails.name,
            languageColor: "",
            url: gitRepositoryDetails.url,
            description: gitRepositoryDetails.description ?? "",
            language: "",
            stars: String(gitRepositoryDetails.stars),
            currentPeriodStars: "",
            forks: "",
            avatar: gitRepositoryDetails.owner.avatarUrl,
            builtBy: [])
        self.delegate?.showRepositoryDetails(for: repositoryDetails)
    }
}


// MARK: Search bar delegate methods

extension SearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Empty searchText means, tapping on the search bar clear button
        // If such is the case, clean the search results
        if searchText.isEmpty,
           let searchedRepositories = self.searchViewModel?.searchedRepositories,
           !searchedRepositories.isEmpty {
            
            self.removeSearchResultTableViewIfNeeded()
            self.clearSearchResults()
            return
        }
        
        // Prevent search query for invalid search keywords like whitespaces, periods, etc
        let characterSet = CharacterSet(charactersIn: " ")
        let trimmedSearchText = searchText.trimmingCharacters(in: characterSet)
        
        guard !trimmedSearchText.isEmpty else { return }
        self.searchRepositories(with: trimmedSearchText)
    }
}

