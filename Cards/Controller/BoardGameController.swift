//
//  BoardGameController.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

class BoardGameController: UIViewController {
    // MARK: - Properties
    // сущность "Игра"
    lazy var game: Game = getNewGame()
    // игральные карточки
    var cardViews = [UIView]()
    // перевернутые карточки
    private var flippedCards = [UIView]()
    // поле для игры
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
    // количество переворотов
    var flipsCount = 0 {
        didSet {
            // запоминаем в моделе
            game.flipsCount = flipsCount
            // обновляем на экране
            title = "Flips: \(flipsCount)"
        }
    }
    lazy var gameStorage: GameStorageProtocol = GameStorage()

    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view.addSubview(boardGameView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flips: XXX"
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.prefersLargeTitles = false
        let flipButton = UIBarButtonItem(image: UIImage(systemName: "doc.on.doc")!,
                                          style: .plain,
                                          target: self,
                                          action: #selector(actionAllFlip))
        navigationItem.rightBarButtonItem = flipButton

        let flipsCount = gameStorage.loadFlipsCount()
        if flipsCount > 0 {
            start()
        } else {
            startNewGame()
        }
    }

    // MARK: - Custom methods
    private func getBoardGameView() -> UIView {
        // отступ от ближайших элементов
        let margin: CGFloat = 10
        let boardView = UIView()

        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + (navigationController?.navigationBar.frame.height ?? 0) / 2 + margin

        // расчет ширины
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        // расчет высоты с учетом нижнего отступа
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding

        // стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = .brown

        return boardView
    }

    private func getSettings() -> CardSettings {
        let gameSettings = gameStorage.loadSettings().filter({$0.status})
        var arrayShapes = [CardShape]()
        var arrayColors = [CardColor]()
        var arrayBacks = [CardBack]()
        for setting in gameSettings {
            switch setting.type {
            case .back:
                if let value = CardBack(rawValue: setting.title) {
                    arrayBacks.append(value)
                }
            case .color:
                if let value = CardColor(rawValue: setting.title) {
                    arrayColors.append(value)
                }
            case .shape:
                if let value = CardShape(rawValue: setting.title) {
                    arrayShapes.append(value)
                }
            }
        }
        return (shapes: arrayShapes, colors: arrayColors, backs: arrayBacks)
    }

    private func getNewGame(withNewCard isNew: Bool = true) -> Game {
        let game = Game()
        if isNew {
            // на основании сохраненных настроек
            game.cardsCount = gameStorage.loadNumberOfPairsOfCards()
            let gameSettings: CardSettings = getSettings()
            game.generateCardsBy(shapes: gameSettings.shapes, colors: gameSettings.colors, backs: gameSettings.backs)
            gameStorage.saveCards(game.cards)
        } else {
            game.cards = gameStorage.loadCards()
            game.cardsCount = game.cards.count
        }
        return game
    }

    private func start() {

        let alertController = UIAlertController(
            title: "Continue previous game?",
            message: nil, preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.startNewGame()
        })
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.continueOldGame()
        })
        self.present(alertController, animated: true, completion: nil)
    }

    private func startNewGame() {
        self.game = self.getNewGame()
        let cards = self.getCardBy(modelData: self.game.cards)
        self.placeCardsOnBoard(cards)

        self.flipsCount = 0
    }

    private func continueOldGame() {
        game = getNewGame(withNewCard: false)
        let cards = getCardBy(modelData: game.cards)

        var coordinates = gameStorage.loadCardCoordinates()
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        for card in cardViews {
            if let index = coordinates.firstIndex(where: { $0.tag == card.tag }) {
                card.frame.origin = CGPoint(x: coordinates[index].x, y: coordinates[index].y)
                boardGameView.addSubview(card)
                if let card = card as? FlippableView {
                    card.isFlipped = coordinates[index].flipped == 1 ? true : false
                }
                coordinates.remove(at: index)
            }
        }

        // если перевернута только одна карточка, то помещаем ее в массив flippedCards
        if let cards = self.boardGameView.subviews as? [FlippableView] {
            let flippedCards = cards.filter {$0.isFlipped}
            if flippedCards.count == 1 {
                let card = flippedCards.first!
                self.flippedCards.append(card)
                card.superview?.bringSubviewToFront(card)
            }
        }

        self.flipsCount = gameStorage.loadFlipsCount()
    }

    private func getCardBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(
                modelCard.shape,
                withSize: cardSize,
                andColor: modelCard.color,
                andBack: modelCard.back
            )
            cardOne.tag = index
            cardViews.append(cardOne)
            let cardTwo = cardViewFactory.get(
                modelCard.shape,
                withSize: cardSize,
                andColor: modelCard.color,
                andBack: modelCard.back
            )
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        // добавляем всем картам обработчик переворота
        for card in cardViews {
            if let card = card as? FlippableView {
                card.flipCompletionHandler = { [self] flippedCard in
                    // переносим карточку вверх иерархии
                    flippedCard.superview?.bringSubviewToFront(flippedCard)

                    // добавляем или удаляем карточку в/из перевернутых
                    addOrRemoveCard(flippedCard)
                    // проверяем карты
                    checkCards()
                }
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
        saveGame()
    }

    private func addOrRemoveCard(_ card: FlippableView) {
        // добавляем или удаляем карточку
        if card.isFlipped {
            flippedCards.append(card)
            flipsCount += 1
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
                    // проверяем окончание игры
                    checkGameOver()
                })
            } else {
                // переворачиваем карточки рубашкой вверх
                for card in flippedCards {
                    if let card = card as? FlippableView {
                        card.flip()
                    }
                }
            }
        } else {
            saveGame()
        }
    }

    private func checkGameOver() {
        guard boardGameView.subviews.count == 0 else {
            // сохраняем состояние игры
            saveGame()
            return
        }
        let alertController = UIAlertController(
            title: "Game over",
            message: "You done \(flipsCount) flips",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "New game",
                                                style: .default) { _ in
            self.startNewGame()
        })
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel) { _ in
            self.resetGame()
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alertController, animated: true, completion: nil)
    }

    private func saveGame() {
        var cardCoordinates = [CardCoordinate]()
        for card in boardGameView.subviews {
            if let card = card as? FlippableView {
                cardCoordinates.append(
                    (tag: card.tag,
                     x: Int(card.frame.origin.x),
                     y: Int(card.frame.origin.y),
                     flipped: card.isFlipped ? 1 : 0)
                )
            }
        }
        gameStorage.saveCardCoordinates(cardCoordinates)
        gameStorage.saveFlipsCount(flipsCount)
    }

    private func resetGame() {
        gameStorage.saveCards([Card]())
        gameStorage.saveCardCoordinates([CardCoordinate]())
        gameStorage.saveFlipsCount(0)
    }

    // MARK: - Actions
    @objc
    private func actionAllFlip() {
        guard let cards = self.boardGameView.subviews as? [FlippableView] else { return }
        let flippedCount = cards.filter({ $0.isFlipped}).count
        let isFlipped = flippedCount < self.boardGameView.subviews.count
        for card in self.boardGameView.subviews {
            if let card = card as? FlippableView {
                card.isFlipped = isFlipped
            }
        }
        self.flippedCards = []
    }
}
