//
//  NetworkManager.swift
//  MemApp
//
//  Created by Кирилл Бахаровский on 9/27/24.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getImageOfUrl(url: String, json: Automeme, completion: @escaping (Data)-> Void) {
        
        let parameters = "template_id=\(json.template_id)&username=\(json.username)&password=\(json.password)&text0=\(json.text0)"
        print(parameters)
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any],
               let data = responseJSON["data"] as? [String: Any],
               let imageUrlString = data["url"] as? String,
               let imageUrl = URL(string: imageUrlString) {
                if let imageData = try? Data(contentsOf: imageUrl){
                    completion(imageData)
                }
            }
        }.resume()
    }
    
    func getMemes(completion: @escaping ([Meme]?) -> Void) {
        let url = "https://api.imgflip.com/get_memes"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка при получении данных: \(error?.localizedDescription ?? "No data")")
                completion(nil)
                return
            }
            
            if let memeResponse = try? JSONDecoder().decode(MemeResponse.self, from: data) {
                completion(memeResponse.data.memes)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
