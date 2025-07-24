//
//  ViewController+Extension.swift
//  NetworkProject
//
//  Created by Reimos on 7/24/25.
//

import UIKit

extension UIViewController {
    // 닫기 버튼만 있는 alert
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let cancel = UIAlertAction(title: "닫기", style: .cancel)
        
        alert.addAction(cancel)

        present(alert, animated: true)
    }
}
