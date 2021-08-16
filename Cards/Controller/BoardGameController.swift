//
//  BoardGameController.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

class BoardGameController: UIViewController {

    // количество пар уникальных карточек
    var cardsPairsCounts = 8
    // сущность "Игра"
    lazy var game: Game = getNewGame()
    lazy var startButtonView = getStartButtonView()
    lazy var flipButtonView = getFlipButtonView()
    lazy var boardGameView = getBoardGameView()
    
    // размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    // предельные размеры размещения карточки
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    // игральные карточки
    var cardViews = [UIView]()
    private var flippedCards = [UIView]()
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }
    
    private func getStartButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
        
        button.center.x = view.center.x
        
        // привязка к Safe Area, через окно приложения
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        button.frame.origin.y = topPadding
        
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
        // подключаем обработчик
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func getFlipButtonView() -> UIButton {
        let margin: CGFloat = 10
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        button.frame.origin.x = margin
        
        // привязка к Safe Area, через окно приложения
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        button.frame.origin.y = topPadding
        
        button.setTitle("<>", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
        // подключаем обработчик
        button.addAction(UIAction(handler: { _ in
            let flippedCount = (self.cardViews as! [FlippableView]).filter({ $0.isFlipped }).count
            let isFlipped = flippedCount < self.cardViews.count
            for card in self.cardViews {
                (card as! FlippableView).isFlipped = isFlipped
            }
            self.flippedCards = []
        }), for: .touchUpInside)
        
        return button
    }
    
    private func getBoardGameView() -> UIView {
        // отступ от ближайших элементов
        let margin: CGFloat = 10
        let boardView = UIView()
        
        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        
        // расчет ширины
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        // расчет высоты с учетом нижнего отступа
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        // стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    private func addOrRemoveCard(_ card: FlippableView) {
        // добавляем или удаляем карточку
        if card.isFlipped {
            flippedCards.append(card)
        } else {
            if let cardIndex = flippedCards.firstIndex(of: card) {
                flippedCards.remove(at: cardIndex)
            }
        }
    }
    
    private func checkCards() {
        // если перевернуто 2 карточки
        if flippedCards.count == 2 {
            // получаем карточки из данных модели
            let firstCard = game.cards[flippedCards.first!.tag]
            let secondCard = game.cards[flippedCards.last!.tag]
            
            // если карточки одинаковые
            if game.checkCards(firstCard, secondCard) {
                // сперва анимировано скрываем их
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    flippedCards.first!.layer.opacity = 0
                    flippedCards.last!.layer.opacity = 0
                // после чего удаляем из иерархии
                }, completion: { [self] _ in
                    flippedCards.first!.removeFromSuperview()
                    flippedCards.last!.removeFromSuperview()
                    flippedCards = []
                })
            } else {
                // переворачиваем карточки рубашкой вверх
                for card in flippedCards {
                    (card as! FlippableView).flip()
                }
            }
        }
    }
    
    private func getCardBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        // добавляем всем картам обработчик переворота
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                // переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                // добавляем или удаляем карточку в/из перевернутых
                addOrRemoveCard(flippedCard)
                // проверяем карты
                checkCards()
            }
        }
        return cardViews
    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        // удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        for card in cardViews {
            let randomX = Int.random(in: 0...cardMaxXCoordinate)
            let randomY = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomX, y: randomY)
            boardGameView.addSubview(card)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(startButtonView)
        view.addSubview(flipButtonView)
        view.addSubview(boardGameView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game"
        view.backgroundColor = .lightGray
    }
    
    @objc
    func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }

}
