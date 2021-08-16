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
        return button
    }()
    lazy var settingsButtonView : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Настройки", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main screen"
        startButtonView.addAction(UIAction(handler: {_ in
            self.navigationController?.pushViewController(BoardGameController(), animated: true)
        }), for: .touchUpInside)
        settingsButtonView.addAction(UIAction(handler: {_ in
            self.navigationController?.pushViewController(SettingsController(), animated: true)
        }), for: .touchUpInside)
    }
    
    // MARK: -  Custom methods
    
    private func setupViews() {
        view.addSubview(startButtonView)
        view.addSubview(settingsButtonView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            startButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3 / 4),
            startButtonView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            startButtonView.heightAnchor.constraint(equalToConstant: 50),
            settingsButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3 / 4),
            settingsButtonView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 50 ),
            settingsButtonView.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
