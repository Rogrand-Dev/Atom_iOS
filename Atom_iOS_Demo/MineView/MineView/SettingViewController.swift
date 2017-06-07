//
//  SettingViewController.swift
//  MineView
//
//  Created by 刘岭 on 2017/6/5.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
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
    
    lazy var cacheView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (cacheView) in
        cacheView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cacheView)
    }
    
    lazy var otherView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (otherView) in
        otherView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(otherView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        layoutViews()
        setupViews()
        getCache()
    }
    
    func clearCache() {
        let disclosureLab = self.cacheView.cell(for: 0)?.disclosureView as? UILabel
        disclosureLab?.text = ""
    }

    private func getCache() {
        let disclosureLab = self.cacheView.cell(for: 0)?.disclosureView as? UILabel
        disclosureLab?.text = "525kb"
    }
    
    private func setupViews() {
        // 常规样式右指示文字
        func disclosuresLabel(_ text: String) -> UILabel {
            let disclosureLab = UILabel.init()
            disclosureLab.text = text
            disclosureLab.textAlignment = .right
            disclosureLab.font = UIFont.systemFont(ofSize: 12)
            disclosureLab.textColor = UIColor.init(white: 0.7, alpha: 1.0)
            disclosureLab.translatesAutoresizingMaskIntoConstraints = false
            return disclosureLab
        }
        
        cacheView.cellInfos = [CellBlockView.CellInfo.init(title: "清空缓存", disclosuresLabel(""), action: { [weak self] in
            self?.clearCache()
        })]
        let satisfactionSurvey = CellBlockView.CellInfo.init(title: "用户满意度调查") { [weak self] in
            self?.pushTo(viewControllerName: "用户满意度调查")
        }
        let grade = CellBlockView.CellInfo.init(title: "喜欢猫眼电影吗？去评分吧！") { [weak self] in
            self?.pushTo(viewControllerName: "评分")
        }
        let sugesstion = CellBlockView.CellInfo.init(title: "意见反馈") { [weak self] in
            self?.pushTo(viewControllerName: "意见反馈")

        }
        let about = CellBlockView.CellInfo.init(title: "关于") { [weak self] in
            self?.pushTo(viewControllerName: "关于")
        }
        otherView.cellInfos = [satisfactionSurvey, grade, sugesstion, about]
    }
    
    private func layoutViews() {
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
                
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["contentView":contentView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["contentView":contentView]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cacheView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["cacheView":cacheView]))
        contentView.addConstraint(NSLayoutConstraint.init(item: cacheView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[cacheView]-10-[otherView]|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: ["cacheView":cacheView,"otherView":otherView]))
        
    }
    
}


extension SettingViewController: PushViewControllerProtocol {
    
    func pushTo(viewControllerName: String) {
        print(viewControllerName)
    }
    
    func pushTo(viewController: UIViewController) {
        self.pushViewController(viewController)
    }
    
    
}

