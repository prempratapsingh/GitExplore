//
//  RepositoryDetailsViewController.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {
    
    // MARK: Private properties
    
    var repositoryDetails: RepositoryDetails? {
        didSet {
            self.showRepositoryDetails()
        }
    }
    
    
    // MARK: Intializier
    
    convenience init(repositoryDetails: RepositoryDetails) {
        self.init()
        self.repositoryDetails = repositoryDetails
    }
    
    
    // MARK: UI controls
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString(LocalizationKeys.back_button_title, comment: "Back button title label"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .systemGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .systemBlue
        return label
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private var urlLinkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapOnRepositoryLink), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    
    // MARK: Private methods
    
    private func configureView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.backButton)
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20)
        ])
        
        self.view.addSubview(self.avatarImage)
        NSLayoutConstraint.activate([
            self.avatarImage.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 50),
            self.avatarImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 150),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.avatarImage.bottomAnchor, constant: 20),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ])
        
        self.view.addSubview(self.authorLabel)
        NSLayoutConstraint.activate([
            self.authorLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.authorLabel.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor, constant: 0)
        ])
        
        self.view.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 50),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24)
        ])
        
        self.view.addSubview(self.urlLinkButton)
        NSLayoutConstraint.activate([
            self.urlLinkButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
            self.urlLinkButton.leftAnchor.constraint(equalTo: self.descriptionLabel.leftAnchor, constant: 0),
            self.urlLinkButton.rightAnchor.constraint(equalTo: self.descriptionLabel.rightAnchor, constant: 0)
        ])
        
        self.showRepositoryDetails()
    }
    
    private func showRepositoryDetails() {
        guard let details = self.repositoryDetails else { return }
        self.titleLabel.text = details.name
        let authorBy = NSLocalizedString(LocalizationKeys.by_author, comment: "Label text for author")
        self.authorLabel.text = "\(authorBy) \(details.author)"
        self.descriptionLabel.text = details.description
        
        if let imageURL = URL(string: details.avatar) {
            self.avatarImage.load(url: imageURL)
        }
        
        self.urlLinkButton.setTitle(details.url, for: .normal)
    }
    
    @objc private func didTapOnBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapOnRepositoryLink() {
        guard let details = self.repositoryDetails,
              let repositoryLinkURL = URL(string: details.url) else { return }
        if UIApplication.shared.canOpenURL(repositoryLinkURL) {
            UIApplication.shared.open(repositoryLinkURL)
        }
    }
}


// MARK: Unit testing helpers

extension RepositoryDetailsViewController {
    var repositoryName: String {
        return self.titleLabel.text ?? ""
    }
    
    var authorName: String {
        return self.authorLabel.text ?? ""
    }
    
    var descriptionText: String {
        return self.descriptionLabel.text ?? ""
    }
}
