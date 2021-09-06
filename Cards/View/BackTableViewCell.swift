//
//  BackTableViewCell.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 21.08.2021.
//

import UIKit

class BackTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: BackTableViewCell.self)
    
    var setting : SettingsProtocol? {
        didSet {
            if let title = setting?.title {
                contentView.layer.sublayers?.removeAll()
                contentView.layer.masksToBounds = true
                if let status = setting?.status {
                    backgroundColor = status ? .lightGray : .white
                }
                switch title {
                case "line":
                    let layer = BackSideLine(size: contentView.bounds.size, fillColor: UIColor.black.cgColor)
                    contentView.layer.addSublayer(layer)
                case "circle":
                    let layer = BackSideCircle(size: contentView.bounds.size, fillColor: UIColor.black.cgColor)
                    contentView.layer.addSublayer(layer)
                default:
                    break
                }
            }
        }
    }

}
