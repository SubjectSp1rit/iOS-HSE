//
//  ViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 28.10.2024.
//

import UIKit

final class WishMakerViewController: UIViewController {
    // MARK: - Constants
    private let wishMakerView = WishMakerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView(to: wishMakerView)
    }
    // MARK: - Private methods
// This method violates YAGNI, but it's necessary for working with the model in the future according to MVC architecture
//    private func updateView(with data: MODELNAME) {
//        wishMakerView.configure(with: data)
//    }
    
    private func setView(to otherView: WishMakerView) {
        view.addSubview(otherView)
        otherView.setWidth(view.frame.width)
        otherView.setHeight(view.frame.height)
    }
}
