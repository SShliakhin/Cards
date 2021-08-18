//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        self.view = getRootView()
        self.view.addSubview(getBoardGameView())
        
//        print("view size")
//        print(self.view.bounds.size)
//        print(self.view.frame.size)
    }
}

func getRootView() -> UIView {
    let view = UIView()
    view.backgroundColor = .white
    return view
}

func getLabelView() -> UIView {
    let label = UILabel()
    label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
    label.text = "Hello World!"
    label.textColor = .black
    return label
}

private func getBoardGameView() -> UIView {
    // отступ от ближайших элементов
    let margin: CGFloat = 10
    let boardView = UIView()
    
    boardView.frame.origin.x = margin
    
    let window = UIApplication.shared.windows[0]
    let topPadding = window.safeAreaInsets.top
    //boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
    boardView.frame.origin.y = //view.safeAreaInsets.top + margin
        topPadding + margin
    
    // расчет ширины
    boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
    
    print(UIScreen.main.bounds.size)
    
    // расчет высоты с учетом нижнего отступа
    let bottomPadding = window.safeAreaInsets.bottom
    boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
    
    // стиль игрового поля
    boardView.layer.cornerRadius = 5
    //boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
    boardView.backgroundColor = .brown
    
    return boardView
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
