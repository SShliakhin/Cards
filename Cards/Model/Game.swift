//
//  Game.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

class Game {
    // количество пар уникальных карточек
    var cardCount = 0
    // массив карточек
    var cards = [Card]()
    
    // генерация массива случайных карт
    func generatedCards() {
        var cards = [Card]()
        for _ in 0...cardCount {
            let randomElement = (type: CardType.allCases.randomElement()!,
                                 color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        return firstCard == secondCard
    }
}
