//
//  PersonInfoViewController.swift
//  MineView
//
//  Created by 刘岭 on 2017/6/5.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class PersonInfoViewController: BaseViewController {
    
    static let normalCellH: CGFloat = 40

    lazy var contentView: UIScrollView = UIScrollView().then { (contentView) in
        contentView.alwaysBounceVertical = true
        contentView.alwaysBounceHorizontal = false
        contentView.showsVerticalScrollIndicator = true
        contentView.showsHorizontalScrollIndicator = false
        contentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contentView)
    }
    
    lazy var firstNormalBlockView: CellBlockView = CellBlockView.init().then { (firstNormalBlockView) in
        firstNormalBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(firstNormalBlockView)
    }
    
    lazy var secondNormalBlockView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (secondNormalBlockView) in
        secondNormalBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(secondNormalBlockView)
    }
    
    lazy var finalNormalBlockView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (finalNormalBlockView) in
        finalNormalBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(finalNormalBlockView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViews()
        setupViews()
    }
    
    private func setupViews() {
        // 常规样式右指示文字
        func disclosuresLabel(_ text: String) -> UILabel {
            let disclosureLab = UILabel.init()
            disclosureLab.text = text
            disclosureLab.isHighlighted = false
            disclosureLab.textAlignment = .right
            disclosureLab.font = UIFont.systemFont(ofSize: 12)
            disclosureLab.highlightedTextColor = themeColor
            disclosureLab.textColor = UIColor.init(white: 0.7, alpha: 1.0)
            disclosureLab.translatesAutoresizingMaskIntoConstraints = false
            return disclosureLab
        }
        // 空白样式右指示文字
        func disclosuresBlankLabel() -> UILabel {
            let disclosureLab = disclosuresLabel("去填写")
            disclosureLab.isHighlighted = true
            return disclosureLab
        }
        
        let avatarH: CGFloat = 66
        let avatarImgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarH-8, height: avatarH-8))
        avatarImgV.image = #imageLiteral(resourceName: "icon_subject")
        avatarImgV.contentMode = .scaleAspectFit
        avatarImgV.clipsToBounds = true
//        avatarImgV.layer.cornerRadius = avatarImgV.bounds.size.height/2
        avatarImgV.translatesAutoresizingMaskIntoConstraints = false
        
        let avatar = CellBlockView.CellInfo.init(title: "头像", cellHeight: avatarH, avatarImgV) { [weak self] in
            self?.pushTo(viewControllerName: "头像")
        }
        let nickname = CellBlockView.CellInfo.init(title: "昵称", cellHeight: PersonInfoViewController.normalCellH, disclosuresLabel("雷地")) { [weak self] in
            self?.pushTo(viewControllerName: "昵称")
        }
        let gender = CellBlockView.CellInfo.init(title: "性别", cellHeight: PersonInfoViewController.normalCellH, disclosuresBlankLabel()) { [weak self] in
            self?.pushTo(viewControllerName: "性别")
        }
        let birthday = CellBlockView.CellInfo.init(title: "生日", cellHeight: PersonInfoViewController.normalCellH, disclosuresBlankLabel()) { [weak self] in
            self?.pushTo(viewControllerName: "生日")
        }
        var city = CellBlockView.CellInfo.init(title: "所在城市", cellHeight: PersonInfoViewController.normalCellH, disclosuresLabel("城市")) { [weak self] in
            self?.pushTo(viewControllerName: "所在城市")
        }
        city.needIndicator = false
        firstNormalBlockView.cellInfos = [avatar, nickname, gender, birthday, city]
        
        let liveStatus = CellBlockView.CellInfo.init(title: "生活状态", disclosuresBlankLabel()) { [weak self] in
            self?.pushTo(viewControllerName: "生活状态")
        }
        let industry = CellBlockView.CellInfo.init(title: "从事行业", disclosuresBlankLabel()) { [weak self] in
            self?.pushTo(viewControllerName: "从事行业")
        }
        let hobbies = CellBlockView.CellInfo.init(title: "兴趣爱好", disclosuresBlankLabel()) { [weak self] in
            self?.pushTo(viewControllerName: "兴趣爱好")
        }
        let signature = CellBlockView.CellInfo.init(title: "个性签名", disclosuresBlankLabel()) { [weak self] in
            self?.pushTo(viewControllerName: "个性签名")
        }
        secondNormalBlockView.cellInfos = [liveStatus, industry, hobbies, signature]
        
        finalNormalBlockView.cellInfos = [CellBlockView.CellInfo.init(title: "收货地址", action: { [weak self] in
            self?.pushTo(viewControllerName: "收货地址")
        })]
    }
    
    private func layoutViews() {
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["contentView":contentView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["contentView":contentView]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[firstNormalBlockView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["firstNormalBlockView":firstNormalBlockView]))
        contentView.addConstraint(NSLayoutConstraint.init(item: firstNormalBlockView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        let blockMargin: CGFloat = 10
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-blockMargin-[firstNormalBlockView]-blockMargin-[secondNormalBlockView]-blockMargin-[finalNormalBlockView]-(>=8)-|",
            options: [.alignAllLeft, .alignAllRight],
            metrics: ["blockMargin":blockMargin],
            views: ["firstNormalBlockView":firstNormalBlockView,
                    "secondNormalBlockView":secondNormalBlockView,
                    "finalNormalBlockView":finalNormalBlockView]
        ))
    }
}

extension PersonInfoViewController: PushViewControllerProtocol {
    
    func pushTo(viewControllerName: String) {
        print(viewControllerName)
    }
    
    func pushTo(viewController: UIViewController) {
        self.pushViewController(viewController)
    }
    
    
}
