//
//  ShapeTableViewCell.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 21.08.2021.
//

import UIKit

class ShapeTableViewCell: UITableViewCell {

    static let identifier = String(describing: ShapeTableViewCell.self)
    
    var setting: SettingsProtocol? {
        didSet {
            if let status = setting?.status {
                selectedIndicatorView.backgroundColor = status ? .green : .white
            }
        }
    }
    
    lazy var selectedIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isOpaque = false
        return view
    }()
    
    lazy var rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isOpaque = false
        return view
    }()
    
    lazy var shapeView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: frame.size))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(selectedIndicatorView)
        addSubview(leftView)
        addSubview(shapeView)
        addSubview(rightView)
        
        NSLayoutConstraint.activate([
            selectedIndicatorView.topAnchor.constraint(equalTo: topAnchor),
            selectedIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedIndicatorView.widthAnchor.constraint(equalToConstant: 5),
            leftView.topAnchor.constraint(equalTo: topAnchor),
            leftView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftView.leadingAnchor.constraint(equalTo: selectedIndicatorView.trailingAnchor),
            leftView.trailingAnchor.constraint(equalTo: shapeView.leadingAnchor),
            shapeView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            shapeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            shapeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            shapeView.widthAnchor.constraint(equalToConstant: 60),
            rightView.topAnchor.constraint(equalTo: topAnchor),
            rightView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightView.leadingAnchor.constraint(equalTo: shapeView.trailingAnchor),
            rightView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = setting?.title {
            
            for sub in shapeView.subviews {
                sub.removeFromSuperview()
            }
            
            let width = shapeView.frame.width - 10
            let height = shapeView.frame.height - 10
            let shape = UIView(frame: CGRect(x: 5, y: 5, width: width, height: height))
            shapeView.addSubview(shape)
            
            switch title {
            case "circle":
                let layer = CircleShape(size: shape.frame.size, fillColor: UIColor.black.cgColor)
                shape.layer.addSublayer(layer)
            case "cross":
                let layer = CrossShape(size: shape.frame.size, fillColor: UIColor.black.cgColor)
                shape.layer.addSublayer(layer)
            case "square":
                let layer = SquareShape(size: shape.frame.size, fillColor: UIColor.black.cgColor)
                shape.layer.addSublayer(layer)
            case "fill":
                let layer = FillShape(size: shape.frame.size, fillColor: UIColor.black.cgColor)
                shape.layer.addSublayer(layer)
            case "unpaintedCircle":
                let layer = UnpaintedCircleShape(size: shape.frame.size, fillColor: UIColor.black.cgColor)
                shape.layer.addSublayer(layer)
            default:
                break
            }
            
        }
        
    }

}
