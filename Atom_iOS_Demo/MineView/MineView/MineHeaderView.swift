//
//  MineHeaderView.swift
//  MineView
//
//  Created by 刘岭 on 2017/5/31.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class MineHeaderView: UIView {

    private lazy var logoImageView: UIImageView = UIImageView.init().then { (logoImageView) in
        
        logoImageView.image = #imageLiteral(resourceName: "icon_maoyan_logo")
        logoImageView.clipsToBounds = true
        logoImageView.layer.borderWidth = 1
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.layer.borderColor = UIColor.white.cgColor
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }
    
    private lazy var textLab: UILabel = UILabel.init().then { (textLab) in
        
        textLab.text = "立即登录"
        textLab.numberOfLines = 1
        textLab.textAlignment = .left
        textLab.textColor = UIColor.white
        textLab.font = UIFont.boldSystemFont(ofSize: 14)
        textLab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLab)
    }
    
    private lazy var nameLab: UILabel = UILabel.init().then { (nameLab) in
        
        nameLab.text = ""
        nameLab.numberOfLines = 1
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.white
        nameLab.font = UIFont.boldSystemFont(ofSize: 14)
        nameLab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLab)
    }
    
    private lazy var gradeLab: UILabelPadding = UILabelPadding.init().then { (gradeLab) in
       
        gradeLab.paddingTop = 4
        gradeLab.paddingLeft = 8
        gradeLab.paddingRight = 8
        gradeLab.paddingBottom = 4
        gradeLab.layer.borderWidth = 0.5
        gradeLab.layer.borderColor = UIColor.white.cgColor
        
        gradeLab.text = ""
        gradeLab.numberOfLines = 1
        gradeLab.textAlignment = .left
        gradeLab.textColor = UIColor.white
        gradeLab.font = UIFont.boldSystemFont(ofSize: 10)
        gradeLab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gradeLab)
    }
    
    private lazy var disclosureIndicator: UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_account_navigationBar_back")).then { (disclosureIndicator) in
        disclosureIndicator.sizeToFit()
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        // a用来控制在x轴方向上的缩放,d用来控制在y轴方向上的缩放
        // abcd共同控制旋转
        // tx用来控制在x轴方向上的平移,ty用来控制在y轴方向上的平移
        disclosureIndicator.transform = CGAffineTransform.init(a: CGFloat(cos(Double.pi)) * 0.7, b: CGFloat(sin(Double.pi)), c: -CGFloat(sin(Double.pi)), d:  CGFloat(cos(Double.pi)) * 0.7, tx: 0, ty: 0)
        
        self.addSubview(disclosureIndicator)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
        textLab.isHidden = false
        nameLab.isHidden = true
        gradeLab.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        logoImageView.layer.cornerRadius = logoImageView.bounds.size.height / 2
    }
    
    public func setHeader(personInfo: (logo: UIImage, title: String, grade: String)?) {
        if let personInfo = personInfo {
            
            textLab.isHidden = true
            nameLab.isHidden = false
            gradeLab.isHidden = false
            nameLab.text = personInfo.title
            gradeLab.text = personInfo.grade
            logoImageView.image = personInfo.logo
            
        } else {

            textLab.isHidden = false
            nameLab.isHidden = true
            gradeLab.isHidden = true
            logoImageView.image = #imageLiteral(resourceName: "icon_maoyan_logo")
        }
    }
    
    @objc private func touch() {
       let protocolImplementer = self.getProtocolImplementer(PushViewControllerProtocol.self)
        if self.textLab.isHidden {
            protocolImplementer?.pushTo?(viewControllerName: "个人信息")
        } else {
            protocolImplementer?.pushTo?(viewControllerName: "登录")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradeLab.layer.cornerRadius = gradeLab.bounds.size.height / 2
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.touch)))
        
        let margin: CGFloat = 10
        
        self.addConstraint(NSLayoutConstraint.init(item: disclosureIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: disclosureIndicator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -margin))
        
        self.addConstraint(NSLayoutConstraint.init(item: logoImageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: margin))
        self.addConstraint(NSLayoutConstraint.init(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: margin))
        logoImageView.addConstraint(NSLayoutConstraint.init(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: logoImageView, attribute: .height, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: textLab, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: textLab, attribute: .leading, relatedBy: .equal, toItem: logoImageView, attribute: .trailing, multiplier: 1.0, constant: margin))
        
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: nameLab, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: nameLab, attribute: .leading, relatedBy: .equal, toItem: logoImageView, attribute: .trailing, multiplier: 1.0, constant: margin))
        
        self.addConstraint(NSLayoutConstraint.init(item: nameLab, attribute: .bottom, relatedBy: .equal, toItem: gradeLab, attribute: .top, multiplier: 1.0, constant: -margin/2))

        self.addConstraint(NSLayoutConstraint.init(item: gradeLab, attribute: .leading, relatedBy: .equal, toItem: nameLab, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: gradeLab, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
       
        
    }

}
