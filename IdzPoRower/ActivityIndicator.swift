//
//  ActivityIndicator.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 12/11/2020.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        hidesWhenStopped = true
        style = .whiteLarge
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(on view: UIView) {
        view.addSubview(self)
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func bringToFrontAndStartAnimating() {
        superview?.bringSubviewToFront(self)
        startAnimating()
    }
}
