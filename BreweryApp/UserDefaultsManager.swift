//
//  UserDefaultsManager.swift
//  BreweryApp
//
//  Created by yc on 2022/03/01.
//

import Foundation

struct UserDefaultsManager {
    func getBreweryList() -> [Brewery] {
        guard let data = UserDefaults().data(forKey: "BreweryList"),
              let breweryList = try? PropertyListDecoder().decode([Brewery].self, from: data) else { return [] }
        
        return breweryList
    }
    func saveBrewery(brewery: Brewery) -> Bool {
        var breweryList = getBreweryList()
        if breweryList.firstIndex(where: { $0.id == brewery.id }) == nil {
            breweryList.insert(brewery, at: 0)
            guard let encodedBreweryList = try? PropertyListEncoder().encode(breweryList) else { return false }
            UserDefaults().setValue(encodedBreweryList, forKey: "BreweryList")
            return true
        } else {
            return false
        }
    }
    func removeBrewery(brewery: Brewery) {
        var likedBreweryList = getBreweryList()
        if let index = likedBreweryList.firstIndex(where: { $0.id == brewery.id }) {
            likedBreweryList.remove(at: index)
            guard let encodedBreweryList = try? PropertyListEncoder().encode(likedBreweryList) else { return }
            UserDefaults().setValue(encodedBreweryList, forKey: "BreweryList")
        }
    }
//    func removeAll() {
//        var breweryList = getBreweryList()
//        breweryList = []
//        UserDefaults().setValue(breweryList, forKey: "BreweryList")
//    }
    func isInLikedBreweryList(brewery: Brewery) -> Bool {
        let likedBreweryList = getBreweryList()
        if likedBreweryList.firstIndex(where: { $0.id == brewery.id }) == nil {
            return false
        } else {
            return true
        }
    }
}
