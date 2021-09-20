//
//  CommonFuncs.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 29.08.2021.
//

import UIKit

func loadDefaultSettings() -> [SettingsProtocol]{
    var result: [SettingsProtocol] = []
    for type in CardShape.allCases {
        result.append(SettingsRecord(title: String(describing: type), type: .shape, status: false))
    }
    for color in CardColor.allCases {
        result.append(SettingsRecord(title: String(describing: color), type: .color, status: false))
    }
    for back in CardBack.allCases {
        result.append(SettingsRecord(title: String(describing: back), type: .back, status: false))
    }
    return result
}

func getDefaultNumberOfPairsOfCards() -> Int {
    return 8
}

func getColorByText(_ colorText: String) -> UIColor {
    switch colorText {
    case "black":
        return .black
    case "red":
        return .red
    case "green":
        return .green
    case "gray":
        return .gray
    case "brown":
        return .brown
    case "yellow":
        return .yellow
    case "purple":
        return .purple
    case "orange":
        return .orange
    default:
        return .white
    }
}

func getSymbolForSelect(with status: Bool) -> String {
    return status ? "\u{25C9}" : "\u{25CB}"
}

