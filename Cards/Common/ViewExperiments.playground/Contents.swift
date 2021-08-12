//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        
        setupsViews()
        
    }
    
    // создание представлений сцены
    private func setupsViews() {
        self.view = getRootView()
        let redView = getRedView()
        let greenView = getGreenView()
        let whiteView = getWhiteView()
        let pinkView = getPinkView()
        
        print(#line, redView.frame)
        print(redView.bounds)
        
        redView.transform = CGAffineTransform(rotationAngle: .pi / 3)
        
        print(redView.frame)
        print(#line, redView.bounds)
        
        set(view: greenView, toCenterOfView: redView)
        whiteView.center = greenView.center
        
        self.view.addSubview(redView)
        redView.addSubview(greenView)
        redView.addSubview(whiteView)
        self.view.addSubview(pinkView)
    }
    
    // создание корневого вью
    private func getRootView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }
    
    // создание красного представления сцены
    private func getRedView() -> UIView {
        let view = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }
    
    // создание зеленого представления сцены
    private func getGreenView() -> UIView {
        let frame = CGRect(x: 100, y: 100, width: 180, height: 180)
        let view = UIView(frame: frame)
        view.backgroundColor = .green
        return view
    }
    
    // создание белого представления сцены
    private func getWhiteView() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }
    
    private func getPinkView() -> UIView {
        let view = UIView(frame: CGRect(x: 50, y: 300, width: 100, height: 100))
        view.backgroundColor = .systemPink
        
        // толщина слоя
        view.layer.borderWidth = 5
        // цвет границ
        view.layer.borderColor = UIColor.yellow.cgColor
        // скругление углов
        view.layer.cornerRadius = 10
        // видимость тени
        /*
         Значение свойства shadowOpacity изменяется от 0.0 (тень не видна), до 1.0 (тень полностью видна). Вы можете указать любое промежуточное значение с плавающей точкой.
         */
        view.layer.shadowOpacity = 0.95
        // радиус размытия тени
        /*
         Увеличение значения свойства shadowRadius делает тень более размытой и менее заметной. Меньший радиус делает тень более заметной, более сфокусированной, с четкими выделенными границами. Значение 0 полностью убирает размытие.
         */
        view.layer.shadowRadius = 20
        // смещение тени
        view.layer.shadowOffset = CGSize(width: 10, height: 20)
        // цвет тени
        view.layer.shadowColor = UIColor.white.cgColor
        // прозрачность слоя
        /*
         Как и в случае с shadowOpacity, значение может изменяться от 0.0 (слой полностью прозрачен и не виден) до 1.0 (слой непрозрачен).
         */
        view.layer.opacity = 0.7
        // цвет фона
        //view.layer.backgroundColor = UIColor.black.cgColor
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        layer.cornerRadius = 10
        view.layer.addSublayer(layer)
        
        // поворот
        //view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        //view.transform = CGAffineTransform(rotationAngle: .pi/4).inverted()
        // растяжение
        //view.transform = CGAffineTransform(scaleX: 1.5, y: 0.7)
        // смещение
        //view.transform = CGAffineTransform(translationX: 100, y: 5)
        // множественное преобразование
        //view.transform = CGAffineTransform(rotationAngle: .pi / 3).scaledBy(x: 2, y: 0.8).translatedBy(x: 50, y: 50)
        print(view.frame)
        print(view.bounds)
        view.bounds.origin = CGPoint(x: -10, y: -10)
        print(view.bounds)
        
        return view
    }
    
    private func set(view moveView: UIView, toCenterOfView baseView: UIView) {
        
        moveView.center = CGPoint(x: baseView.bounds.midX, y: baseView.bounds.midY)
        
//        // размеры вложенного представления
//        let moveViewWidth = moveView.frame.width
//        let moveViewHeight = moveView.frame.height
//        // размеры родительского представления
//        let baseViewWidth = baseView.bounds.width
//        let baseViewHeight = baseView.bounds.height
//
//        // вычисление и изменение координат
//        let newX = (baseViewWidth - moveViewWidth) / 2
//        let newY = (baseViewHeight - moveViewHeight) / 2
//        moveView.frame.origin = CGPoint(x: newX, y: newY)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
