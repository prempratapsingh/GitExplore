//
//  SearchBar.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import UIKit

class SearchBar: UIView {
    
    // MARK: Properties
    
    
    // MARK: UI controls
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search...".localizedCapitalized
        return searchBar
    }()
    
    
    // MARK: Lifecycle methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    
    // MARK: Private methods
    
    private func configureView() {
        self.addSubview(self.searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.searchBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.searchBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
    }
}
