import Foundation

public class TurnOffScreenshots {
    static func turnOff(on window: UIWindow?) {
            guard let window = window else { return }

            let field = UITextField()
            let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height))

            let image = UIImageView(image: UIImage(named: "whiteImage"))
            image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            field.isSecureTextEntry = true

            window.addSubview(field)
            view.addSubview(image)

            window.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.last!.addSublayer(window.layer)

            field.leftView = view
            field.leftViewMode = .always
        }

}