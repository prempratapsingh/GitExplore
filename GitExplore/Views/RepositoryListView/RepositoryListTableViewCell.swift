//
//  RepositoryListTableViewCell.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import UIKit

class RepositoryListTableViewCell: UITableViewCell {
    
    // MARK: Public properties
    
    static let identifier = "RepositoryListTableViewCell"
    
    var respositoryDetails: RepositoryDetails? {
        didSet {
            self.showRepositoryDetails()
        }
    }
    
    
    // MARK: UI controls
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var starCountLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private  lazy var starImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star.fill",
                              withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        image.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return image
    }()
    
    private lazy var starCountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.starImage, self.starCountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
   
    // MARK: Lifecycle methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureView()
    }
    
    
    // MARK: Private methods
    
    private func configureView() {
        self.selectionStyle = .none
        
        self.addSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24)
        ])
        
        self.addSubview(self.authorLabel)
        NSLayoutConstraint.activate([
            self.authorLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            self.authorLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor, constant: 0),
            self.authorLabel.rightAnchor.constraint(equalTo: self.nameLabel.rightAnchor, constant: 0)
        ])
        
        self.addSubview(self.starCountStackView)
        NSLayoutConstraint.activate([
            self.starCountStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.starCountStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            self.starCountStackView.widthAnchor.constraint(equalToConstant: 80),
            self.starCountStackView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func showRepositoryDetails() {
        guard let details = self.respositoryDetails else { return }
        self.nameLabel.text = details.name
        let authorBy = NSLocalizedString(LocalizationKeys.by_author, comment: "Label text for author")
        self.authorLabel.text = "\(authorBy) \(details.author)"
        self.starCountLabel.text = details.stars
    }
}
