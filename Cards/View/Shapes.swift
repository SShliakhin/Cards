//
//  Shapes.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 12.08.2021.
//

import UIKit

protocol ShapeLayerProtocol: CAShapeLayer {
    // каждый слой будет вписан в игральную карту определенного размера и залит определенным цветом
    init(size: CGSize, fillColor: CGColor)
}

// MARK: - Shapes

// создание класса круга
class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        // вписывыаем круг в переданные размеры
        // радиус половина меньшей стороны
        let radius = min(size.width, size.height) / 2
        // центр по середине
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                radius: radius,
                                startAngle: 0,
                                endAngle: .pi * 2 ,
                                clockwise: true)
        path.close()
        // инициализируем созданный путь
        self.path = path.cgPath
        // изменим цвет
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// создание квадрата
class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        // меньшая из сторон будет стороной квадрата
        let side = min(size.width, size.height)
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: side, height: side))
        path.close()
        // инициализируем созданный путь
        self.path = path.cgPath
        // изменим цвет
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// создание креста
class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        // рисуме крест
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: size.height))

        // инициализируем созданный путь
        self.path = path.cgPath
        // изменим цвет
        self.strokeColor = fillColor
        // толщина линий
        self.lineWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// создание закрашенного слоя
class FillShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        // рисуем прямоугольник
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // инициализируем созданный путь
        self.path = path.cgPath
        // изменим цвет
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BackSides

// рубашка с кругами
class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        // рисуем 15 кругов
        for _ in 1...15 {
            // координаты очередного круга
            let randomX = Int.random(in: 0...Int(size.width))
            let randomY = Int.random(in: 0...Int(size.height))
            path.move(to: CGPoint(x: randomX, y: randomY))
            // очередной радиус
            let radius = Int.random(in: 5...15)
            // рисуем круг
            path.addArc(withCenter: CGPoint(x: randomX, y: randomY), radius: CGFloat(radius), startAngle: 0, endAngle: .pi * 2, clockwise: true)
        }
        // инициализируем созданный путь
        self.path = path.cgPath
        // изменим цвет
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// рубашка с линиями
class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        // рисуем 15 кругов
        for _ in 1...15 {
            // начальные координаты отрезка
            let start = CGPoint(x: Int.random(in: 0...Int(size.width)), y: Int.random(in: 0...Int(size.height)))
            let end = CGPoint(x: Int.random(in: 0...Int(size.width)), y: Int.random(in: 0...Int(size.height)))
            
            path.move(to: start)
            path.addLine(to: end)
        }
        // инициализируем созданный путь
        self.path = path.cgPath
        // изменим цвет
        self.strokeColor = fillColor
        self.lineWidth = 3
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ShapeLayerProtocol {
    // нельзя использовать пустой инициализатор
    init() {
        fatalError("inti() не может быть использован для создания экземпляра")
    }
}
