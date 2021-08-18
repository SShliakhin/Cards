//
//  StartController.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 15.08.2021.
//

import UIKit

class StartController: UIViewController {
    
    // MARK: - Properties

    lazy var startButtonView : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Начать игру", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.addAction(UIAction(handler: {_ in
            self.navigationController?.pushViewController(BoardGameController(), animated: true)
        }), for: .touchUpInside)
        return button
    }()
    lazy var settingsButtonView : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Настройки", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.addAction(UIAction(handler: {_ in
            self.navigationController?.pushViewController(SettingsController(), animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var miniBoardGameView : UIView = {
        let board = UIView()
        board.translatesAutoresizingMaskIntoConstraints = false
        board.backgroundColor = .lightGray
        board.layer.cornerRadius = 10
        return board
    }()
    
    var cardViews = [UIView]()
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cards"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCards()
    }
    
    // MARK: -  Custom methods
    
    private func setupViews() {
        view.addSubview(startButtonView)
        view.addSubview(settingsButtonView)
        view.addSubview(miniBoardGameView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            startButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3 / 4),
            startButtonView.heightAnchor.constraint(equalToConstant: 30),
            
            settingsButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3 / 4),
            settingsButtonView.heightAnchor.constraint(equalToConstant: 30),
            
            miniBoardGameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            miniBoardGameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            miniBoardGameView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            settingsButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20 ),
            startButtonView.bottomAnchor.constraint(equalTo: settingsButtonView.topAnchor, constant: -10),
            miniBoardGameView.bottomAnchor.constraint(equalTo: startButtonView.topAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCards() {
        // определяем размер карточки
        let minSide = min(miniBoardGameView.bounds.width, miniBoardGameView.bounds.height)
        let widthCard = minSide / 2
        let heightCard = widthCard / 3 * 4
        
        guard widthCard != cardViews.first?.bounds.width else {
            return
        }
        
        // размеры изменились
        // удаляем старые карточки
        cardViews.forEach{ card in
            card.removeFromSuperview()
        }
        cardViews = []
        
        // создаем новые карточки
        let cardViewFactory = CardViewFactory()
        let cardOne = cardViewFactory.get(CardType.circle , withSize: CGSize(width: widthCard, height: heightCard), andColor: CardColor.green)
        let cardTwo = cardViewFactory.get(CardType.square , withSize: CGSize(width: widthCard, height: heightCard), andColor: CardColor.red)
        // добавляем на поле
        miniBoardGameView.addSubview(cardOne)
        miniBoardGameView.addSubview(cardTwo)
        // и в массив
        cardViews.append(cardOne)
        cardViews.append(cardTwo)
        // определяем координаты origin
        let marginX = (miniBoardGameView.bounds.width - widthCard * 1.5) / 2
        cardOne.frame.origin.x = marginX
        cardTwo.frame.origin.x = marginX + widthCard * 0.5
        
        if heightCard * 1.5 <= miniBoardGameView.bounds.height {
            cardOne.frame.origin.y = (miniBoardGameView.bounds.height - heightCard * 1.5) / 2
            cardTwo.frame.origin.y = cardOne.frame.origin.y + heightCard * 0.5
        } else {
            cardOne.frame.origin.y = 0
            cardTwo.frame.origin.y = miniBoardGameView.bounds.height - heightCard
        }
    }

}
