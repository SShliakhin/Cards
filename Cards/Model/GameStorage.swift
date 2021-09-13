//
//  GameStorage.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 19.08.2021.
//

import Foundation

protocol GameStorageProtocol {
    func loadSettings() -> [SettingsProtocol]
    func saveSettings(_ settings: [SettingsProtocol])
    func loadCards() -> [Card]
    func saveCards(_ cards: [Card])
    func loadCardCoordinates() -> [CardCoordinate]
    func saveCardCoordinates(_ cards: [CardCoordinate])
    func loadFlipsCount() -> Int
    func saveFlipsCount(_ count: Int)
}

class GameStorage: GameStorageProtocol {
    
    private var storage = UserDefaults.standard
    
    var storageSettingsKey: String = "settings"
    var storageCardsKey: String = "cards"
    var storageCardCoordinatesKey: String = "cardCoordinates"
    var storageFlipsCount: String = "flipsCount"
    
    func loadSettings() -> [SettingsProtocol] {
        var result: [SettingsProtocol] = []
        let settingsFromStorage = storage.array(forKey: storageSettingsKey) as? [[String: String]] ?? []
        for setting in settingsFromStorage {
            guard let title = setting[SettingKey.title.rawValue],
                  let typeRaw = setting[SettingKey.type.rawValue],
                  let statusRaw = setting[SettingKey.status.rawValue],
                  let type = SettingsType(rawValue: typeRaw) else {
                continue
            }
            //let type = SettingsType(rawValue: typeRaw) //getTypeByText(typeRaw)
            let status = statusRaw == "true" ? true : false
            
            result.append(SettingsRecord(title: title, type: type, status: status))
        }
        
        if result.isEmpty {
            result = loadDefaultSettings()
        }
        
        return result
    }
    
    func saveSettings(_ settings: [SettingsProtocol]) {
        var arrayForStorage: [[String: String]] = []
        settings.forEach { setting in
            var newElementForStorage = [String: String]()
            newElementForStorage[SettingKey.title.rawValue] = setting.title
            newElementForStorage[SettingKey.type.rawValue] = setting.type.rawValue
            newElementForStorage[SettingKey.status.rawValue] = setting.status ? "true" : "false"
            
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageSettingsKey)
    }
    
    func loadCards() -> [Card] {
        var result: [Card] = []
        let cardsFromStorage = storage.array(forKey: storageCardsKey) as? [[String: String]] ?? []
        for card in cardsFromStorage {
            guard let shapeRaw = card[SettingsType.shape.rawValue],
                  let shape = CardShape(rawValue: shapeRaw),
                  let colorRaw = card[SettingsType.color.rawValue],
                  let color = CardColor(rawValue: colorRaw),
                  let backRaw = card[SettingsType.back.rawValue],
                  let back = CardBack(rawValue: backRaw) else {
                continue
            }
            result.append((shape: shape, color: color, back: back))
        }
        return result
    }
    
    func saveCards(_ cards: [Card]) {
        var arrayForStorage: [[String: String]] = []
        cards.forEach { card in
            var newElementForStorage = [String: String]()
            newElementForStorage[SettingsType.shape.rawValue] = card.shape.rawValue
            newElementForStorage[SettingsType.color.rawValue] = card.color.rawValue
            newElementForStorage[SettingsType.back.rawValue] = card.back.rawValue
            
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageCardsKey)
    }
    
    func loadCardCoordinates() -> [CardCoordinate] {
        var result: [CardCoordinate] = []
        let cardCoordinatesFromStorage = storage.array(forKey: storageCardCoordinatesKey) as? [[String: Int]] ?? []
        for coordinate in cardCoordinatesFromStorage {
            guard let tag = coordinate[CoordinateKey.tag.rawValue],
                  let x = coordinate[CoordinateKey.x.rawValue],
                  let y = coordinate[CoordinateKey.y.rawValue],
                  let flipped = coordinate[CoordinateKey.flipped.rawValue] else {
                continue
            }
            result.append((tag: tag, x: x, y: y, flipped: flipped))
        }
        return result
    }
    
    func saveCardCoordinates(_ cardCoordinates: [CardCoordinate]) {
        var arrayForStorage: [[String: Int]] = []
        cardCoordinates.forEach { coordinate in
            var newElementForStorage = [String: Int]()
            newElementForStorage[CoordinateKey.tag.rawValue] = coordinate.tag
            newElementForStorage[CoordinateKey.x.rawValue] = coordinate.x
            newElementForStorage[CoordinateKey.y.rawValue] = coordinate.y
            newElementForStorage[CoordinateKey.flipped.rawValue] = coordinate.flipped
            
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageCardCoordinatesKey)
    }
    
    func loadFlipsCount() -> Int {
        return storage.integer(forKey: storageFlipsCount)
    }
    
    func saveFlipsCount(_ count: Int) {
        storage.set(count, forKey: storageFlipsCount)
    }
    
}
