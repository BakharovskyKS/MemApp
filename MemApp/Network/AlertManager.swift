//
//  AlertManager.swift
//  MemApp
//
//  Created by Кирилл Бахаровский on 9/27/24.
//

import Foundation
import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    func simpleAlertWithTF(title: String, message: String, titleSaveButton: String, viewController: UIViewController, completion: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        
        let save = UIAlertAction(title: titleSaveButton, style: .default) { [weak alert] _ in
            if let textField = alert?.textFields?.first, let text = textField.text, !text.isEmpty {
                completion(text)
            } else {
                self.showMessagePrompt("Please enter the name of the meme", viewController: viewController)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showMessagePrompt(_ message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
