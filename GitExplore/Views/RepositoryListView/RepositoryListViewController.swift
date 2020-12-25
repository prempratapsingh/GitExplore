//
//  RepositoryListViewController.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 24/12/20.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    // MARK: Public properties
    
    var viewModel: RepositoryListViewModel!
    
    
    // MARK: UI controls
    
    private lazy var repositorySearchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        return searchBar
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.text = NSLocalizedString(LocalizationKeys.repositoryList_title, comment: "Title label text for repository list view")
        return label
    }()
    
    private lazy var segmentedControlItems: [String] = {
        let trendingPeriods: [TrendingPeriod] = [.daily, .weekly,. monthly]
        return trendingPeriods.map{ $0.label }
    }()
    
    private lazy var periodSelectionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: self.segmentedControlItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = .systemGray
        segmentedControl.selectedSegmentTintColor = .systemGray3
        segmentedControl.addTarget(self, action: #selector(didChangePeriodSelection), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var repositoryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: RepositoryListTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    // MARK: Initializer
    
    convenience init(viewModel: RepositoryListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.getTrendingRepositories()
    }
    
    
    // MARK: Private methods
    
    private func configureView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.repositorySearchBar)
        NSLayoutConstraint.activate([
            self.repositorySearchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.repositorySearchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            self.repositorySearchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -24),
            self.repositorySearchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.repositorySearchBar.bottomAnchor, constant: 30),
            self.titleLabel.leftAnchor.constraint(equalTo: self.repositorySearchBar.leftAnchor, constant: 0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.repositorySearchBar.rightAnchor, constant: 0)
        ])
        
        self.view.addSubview(self.periodSelectionSegmentedControl)
        NSLayoutConstraint.activate([
            self.periodSelectionSegmentedControl.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            self.periodSelectionSegmentedControl.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            self.periodSelectionSegmentedControl.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 0),
            self.periodSelectionSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        self.periodSelectionSegmentedControl.selectedSegmentIndex = 0
        
        self.view.addSubview(self.repositoryListTableView)
        NSLayoutConstraint.activate([
            self.repositoryListTableView.topAnchor.constraint(equalTo: self.periodSelectionSegmentedControl.bottomAnchor, constant: 16),
            self.repositoryListTableView.leftAnchor.constraint(equalTo: self.periodSelectionSegmentedControl.leftAnchor, constant: 0),
            self.repositoryListTableView.rightAnchor.constraint(equalTo: self.periodSelectionSegmentedControl.rightAnchor, constant: 0),
            self.repositoryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    /// Calls view model for loading list of trending repositories based on the given trending period - daily, weekly or monthly
    private func getTrendingRepositories(for period: TrendingPeriod = .daily) {
        self.showProgressView()
        self.viewModel.getTrendingRepositories(for: period) { [weak self] didLoadRepositories in
            DispatchQueue.main.async {
                guard didLoadRepositories,
                      let strongSelf = self else {
                    self?.showAlertView(with: NSLocalizedString(LocalizationKeys.alert_error, comment: "Alert view title text"),
                                        message: NSLocalizedString(LocalizationKeys.error_repositoriesLoad, comment: "Alert view message text"))
                    return
                }
                strongSelf.hideProgressView()
                strongSelf.repositoryListTableView.reloadData()
            }
        }
    }
    
    @objc
    private func didChangePeriodSelection() {
        let selectedSegment = self.periodSelectionSegmentedControl.selectedSegmentIndex
        guard let period = TrendingPeriod(rawValue: selectedSegment) else { return }
        self.getTrendingRepositories(for: period)
    }
}


// MARK: Table view data source methods

extension RepositoryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.trendingRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !self.viewModel.trendingRepositories.isEmpty,
              let cell = tableView.dequeueReusableCell(
                withIdentifier: RepositoryListTableViewCell.identifier,
                for: indexPath) as? RepositoryListTableViewCell else {
            return RepositoryListTableViewCell()
        }
        cell.respositoryDetails = self.viewModel.trendingRepositories[indexPath.row]
        return cell
    }
}

// MARK: Table view delegate methods

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryDetails = self.viewModel.trendingRepositories[indexPath.row]
        self.presentRepositoryDetailsViewController(for: repositoryDetails)
    }
    
    private func presentRepositoryDetailsViewController(for repositoryDetails: RepositoryDetails) {
        let repositoryDetailsViewController = RepositoryDetailsViewController(repositoryDetails: repositoryDetails)
        repositoryDetailsViewController.modalPresentationStyle = .overCurrentContext
        self.present(repositoryDetailsViewController, animated: true)
    }
}

