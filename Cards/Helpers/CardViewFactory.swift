//
//  CardViewFactory.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

class CardViewFactory {
    func get(_ shape: CardShape, withSize size: CGSize, andColor color: CardColor, andBack back: CardBack) -> UIView {
        // на основе размера определяем фрейм
        let frame = CGRect(origin: .zero, size: size)
        // определяем UI - цвет на основе цвета модели
        let viewColor = getViewColorBy(modelColor: color)
        
        // генерируем и возвращаем карточку
        switch shape {
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor, back: back)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor, back: back)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor, back: back)
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor, back: back)
        case .unpaintedCircle:
            return CardView<UnpaintedCircleShape>(frame: frame, color: viewColor, back: back)
        }
    }
    
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .black:
            return .black
        case .red:
            return .red
        case .green:
            return .green
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}
