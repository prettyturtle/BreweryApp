//
//  DataFetch.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import Foundation

struct FetchData {
    func fetch(page: Int, completionHandler: @escaping ([Brewery], Int) -> Void) {
        guard var component = URLComponents(string: "https://api.punkapi.com/v2/beers") else { return }
        let queryItem = URLQueryItem(name: "page", value: "\(page)")
        component.queryItems = [queryItem]
        guard let url = component.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            switch response.statusCode {
            case (200..<300):
                guard let data = data else { return }
                
                do {
                    let result = try JSONDecoder().decode([Brewery].self, from: data)
                    completionHandler(result, page+1)
                } catch {
                    print("do-catch { \(error.localizedDescription) }")
                }
            default:
                guard let error = error else { return }
                print("statusCode error { \(error.localizedDescription) }")
            }
        }
        .resume()
    }
}
