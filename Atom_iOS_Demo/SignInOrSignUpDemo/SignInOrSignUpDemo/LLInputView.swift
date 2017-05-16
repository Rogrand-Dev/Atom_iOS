
import UIKit
//import Foundation

extension UIView {
    func addBorderBottom(size: CGFloat, color: UIColor) {
        
        let border = CAShapeLayer()
        border.strokeColor = color.cgColor
        border.fillColor = color.cgColor
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x:0, y:bounds.size.height - size))
        path.addLine(to:  CGPoint(x:bounds.size.width, y:bounds.size.height - size))
        border.path = path
        
        border.lineWidth = size
        border.lineCap = "square"
        border.lineJoin = kCALineJoinRound
        layer.addSublayer(border)
        
    }
}

@objc protocol LLInputViewDelegate: class {
    @objc optional func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
}

public class LLInputView: UIView {
    
    weak var delegate: LLInputViewDelegate?
    
    public var leftLabelWidth: CGFloat? {
        didSet {
            setupConstraints()
        }
    }
    public var rightViewWidth: CGFloat? {
        didSet {
            setupConstraints()
        }
    }
    
    public private(set) lazy var leftLabel: UILabel = UILabel().then { view in
        
        view.clipsToBounds = false
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
    }
    public private(set) lazy var textField: UITextField = UITextField().then { view in
        view.delegate = self
        view.clipsToBounds = false
        view.clearButtonMode = .whileEditing
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
    public private(set) lazy var rightView: UIView = UIView().then { view in
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupConstraints()
    }
    
    public func resignTextFieldFirstResponders() {
        textField.resignFirstResponder()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupConstraints() {
        self.removeConstraints(self.constraints)
        
        let leftW = leftLabelWidth ?? 0
        let rightW = rightViewWidth ?? 0
        
        var horFormat = ""
        var views: Dictionary<String, UIView> = [:]
        if leftLabelWidth != nil
        {
//            horFormat += "-[leftLabel(leftW)]-0"
            horFormat += "-[leftLabel"
            if let _ = leftLabelWidth {
                horFormat += "(leftW)"
            }
            horFormat += "]-0"
            views["leftLabel"] = leftLabel
        }
        
        horFormat += "-[textField]-"
        views["textField"] = textField
        
        if rightViewWidth != nil
        {
//            horFormat += "0-[rightView(rightW)]-"
            horFormat += "0-[rightView"
            if let _ = rightViewWidth {
                horFormat += "(rightW)"
            }
            horFormat += "]-"
            views["rightView"] = rightView
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0\(horFormat)0-|",
            options: [NSLayoutFormatOptions.alignAllTop, NSLayoutFormatOptions.alignAllBottom],
            metrics: ["leftW":leftW, "rightW":rightW],
            views: views)
        )
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-1-[textField]-1-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["textField":textField]))
    }
    
}

extension LLInputView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return delegate?.textFieldShouldReturn?(textField) ?? true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
    }
}


