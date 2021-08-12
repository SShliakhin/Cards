//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol: CAShapeLayer {
    // каждый слой будет вписан в игральную карту определенного размера и залит определенным цветом
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    // нельзя использовать пустой инициализатор
    init() {
        fatalError("inti() не может быть использован для создания экземпляра")
    }
}

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

// реализация переворота карты
protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class CardView <ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    // цвет фигуры
    var color: UIColor!
    // радиус закругления бордюра
    var cornerRadius = 20
    
    // точка привязки
    private var anchorPoint = CGPoint(x: 0, y: 0)
    private var startTouchPoint: CGPoint!
    
    // реализация протокола переворота
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    func flip() {
        // определяем, между какими представлениями осуществить переход
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        // запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: { _ in
            self.flipCompletionHandler?(self)
        })
        isFlipped = !isFlipped
    }
    
    // внутренний отступ представления
    private let margin: Int = 10
    
    // представление с лицевой стороны карты
    lazy var frontSideView: UIView = self.getFrontSideView()
    // представление с обратной стороны карты
    lazy var backSideView: UIView = self.getBackSideView()
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    
    override func draw(_ rect: CGRect) {
        //  удаляем добавленные ранее дочерние вью
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        // добавляем новые
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        
        // сохраняем исходные координаты
        startTouchPoint = frame.origin
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // flip() // переворачивается всегда
        // переворачивается если только был клик
        if self.frame.origin == startTouchPoint {
            flip()
        }
        // анимировано возвращаем карточку в исходную позицию
//        UIView.animate(withDuration: 0.5) {
//            self.frame.origin = self.startTouchPoint
//
//            // переворачиваем представление на 180 градусов
//            if self.transform.isIdentity {
//                self.transform = CGAffineTransform(rotationAngle: .pi)
//            } else {
//                self.transform = .identity
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        let shapeView = UIView(frame: CGRect(x: margin, y: margin,
                                             width: Int(self.bounds.width) - margin * 2,
                                             height: Int(self.bounds.height) - margin * 2))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        // выбор случайного узора для рубашки
        switch ["cicle", "line"].randomElement() {
        case "cicle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
}

extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String(describing: Self.self)
        }
        return String(describing: Self.self) + " -> " + next.responderChain()
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        // круг
        //view.layer.addSublayer(CircleShape(size: CGSize(width: 150, height: 200), fillColor: UIColor.gray.cgColor))
        // квадрат
        //view.layer.addSublayer(SquareShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.red.cgColor))
        // крест
        //view.layer.addSublayer(CrossShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
        // закрашенный слой
        //view.layer.addSublayer(FillShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.yellow.cgColor))
        // рубашка с кругами
        //view.layer.addSublayer(BackSideLine(size: CGSize(width: 200, height: 150), fillColor: UIColor.black.cgColor))
        // первая карта
        let firstCardView = CardView<CircleShape>(frame: CGRect(x: 10, y: 10, width: 120, height: 150), color: .red)
        self.view.addSubview(firstCardView)
        firstCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
        
        // вторая карта
        let secondCardView = CardView<CircleShape>(frame: CGRect(x: 200, y: 10, width: 120, height: 150), color: .red)
        self.view.addSubview(secondCardView)
        secondCardView.isFlipped = true
        secondCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
