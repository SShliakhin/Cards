//
//  Game.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

class Game {
    // генерирует необходимое количество карт - необходимо установить количество пар - возвращает массив карт
    // сравнивает карты, возвращает true если одинаковые
    // генерирует специальный набор карт по настройкам
    
    // количество пар уникальных карточек
    var cardsCount = 0
    // массив карточек
    var cards = [Card]()
    // количество переворотов
    var flipsCount = 0
    
    // генерация массива случайных карт
    func generateCards() {
        var cards = [Card]()
        for _ in 0..<cardsCount {
            let randomElement = (shape: CardShape.allCases.randomElement()!,
                                 color: CardColor.allCases.randomElement()!,
                                 back: CardBack.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    func generateCardsBy(shapes: [CardShape], colors: [CardColor], backs: [CardBack]) {
        var cards = [Card]()
        for _ in 0..<cardsCount {
            let randomElement = (shape: shapes.isEmpty ? CardShape.allCases.randomElement()! : shapes.randomElement()!,
                                 color: colors.isEmpty ? CardColor.allCases.randomElement()! : colors.randomElement()!,
                                 back: backs.isEmpty ? CardBack.allCases.randomElement()! : backs.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        return firstCard.color == secondCard.color && firstCard.shape == secondCard.shape
    }
}
