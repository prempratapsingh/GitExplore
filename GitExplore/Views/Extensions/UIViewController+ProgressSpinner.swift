//
//  UIViewController+ProgressView.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import UIKit

// MARK: Progress indicator view

extension UIViewController {
    
    /// Shows default progress indicator view
    func showProgressView() {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = .systemBlue
        indicatorView.backgroundColor = .white
        indicatorView.tag = 100
        
        self.view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            indicatorView.widthAnchor.constraint(equalToConstant: 75),
            indicatorView.heightAnchor.constraint(equalToConstant: 75)
        ])
        indicatorView.startAnimating()
    }
    
    // Removes progress indicator view, if it exists
    func hideProgressView() {
        guard let indicatorView = self.view.subviews.first(where: {$0.tag == 100}) else { return }
        indicatorView.removeFromSuperview()
    }
}


// MARK: Alert views

extension UIViewController {
    
    /// Presents alert view with the given title and message values
    func showAlertView(with title: String, message: String) {
        let alertControlller = UIAlertController(title: title,
                                                 message: message,
                                                 preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString(LocalizationKeys.alert_ok, comment: "Label text for ok button"),
                                         style: .cancel)
        alertControlller.addAction(alertAction)
        self.present(alertControlller, animated: true)
    }
}
