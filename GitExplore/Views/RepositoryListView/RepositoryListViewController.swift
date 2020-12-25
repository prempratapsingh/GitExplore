//
//  RepositoryListViewController.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 24/12/20.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    // MARK: UI controls
    
    private lazy var repositorySearchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        return searchBar
    }()
    
    private lazy var periodSelectionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Daily", "Weekly", "Monthly"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = .systemGray
        segmentedControl.selectedSegmentTintColor = .systemGray3
        segmentedControl.addTarget(self, action: #selector(didChangePeriodSelection), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var repositoryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray2
        return tableView
    }()
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    
    // MARK: Private methods
    
    private func configureView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.repositorySearchBar)
        NSLayoutConstraint.activate([
            self.repositorySearchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.repositorySearchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            self.repositorySearchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -24),
            self.repositorySearchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(self.periodSelectionSegmentedControl)
        NSLayoutConstraint.activate([
            self.periodSelectionSegmentedControl.topAnchor.constraint(equalTo: self.repositorySearchBar.bottomAnchor, constant: 20),
            self.periodSelectionSegmentedControl.leftAnchor.constraint(equalTo: self.repositorySearchBar.leftAnchor, constant: 0),
            self.periodSelectionSegmentedControl.rightAnchor.constraint(equalTo: self.repositorySearchBar.rightAnchor, constant: 0),
            self.periodSelectionSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.view.addSubview(self.repositoryListTableView)
        NSLayoutConstraint.activate([
            self.repositoryListTableView.topAnchor.constraint(equalTo: self.periodSelectionSegmentedControl.bottomAnchor, constant: 16),
            self.repositoryListTableView.leftAnchor.constraint(equalTo: self.periodSelectionSegmentedControl.leftAnchor, constant: 0),
            self.repositoryListTableView.rightAnchor.constraint(equalTo: self.periodSelectionSegmentedControl.rightAnchor, constant: 0),
            self.repositoryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    @objc
    private func didChangePeriodSelection() {
        print(self.periodSelectionSegmentedControl.selectedSegmentIndex)
    }
}

