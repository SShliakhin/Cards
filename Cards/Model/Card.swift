//
//  Card.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

// через тайпалиас создали типа класса Карта, который содержит только форму и цвет карты

// типы фигуры карт
enum CardShape: String, CaseIterable {
    case circle
    case cross
    case square
    case fill
    case unpaintedCircle
}
// цвета карт
enum CardColor: String, CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}
// тип рубашки
enum CardBack: String, CaseIterable {
    case circle
    case line
}
// игральная карточка
typealias Card = (shape: CardShape, color: CardColor, back: CardBack)
// игральная карточка на игровом поле
typealias CardCoordinate = (tag: Int, x: Int, y: Int)
// настройки для создания карточек
typealias CardSettings = (shapes: [CardShape], colors: [CardColor], backs: [CardBack])

// тип настройки и ключи для запоминания игральной карточки
enum SettingsType: String {
    case shape
    case color
    case back
}
// ключи для запоминания настройки
enum SettingKey: String {
    case title
    case type
    case status
}
// ключи для запоминания координаты карты и ее индекса
enum CoordinateKey: String {
    case tag
    case x
    case y 
}

protocol SettingsProtocol {
    var title: String { get set }
    var type: SettingsType { get set }
    var status: Bool { get set }
}
// запись настройки
struct SettingsRecord: SettingsProtocol {
    var title: String
    var type: SettingsType
    var status: Bool
}
