//
//  MineBodyView.swift
//  MineView
//
//  Created by 刘岭 on 2017/5/31.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class MineBodyView: UIView {
    
    static let normalCellH: CGFloat = 40

    lazy var firstItemView: ItemsView = ItemsView.init(isSeparate: true).then { (firstItemView) in
        firstItemView.separate(direction: [.bottom])
        firstItemView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(firstItemView)
    }
    
    lazy var secondHeaderView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (secondHeaderView) in
        secondHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(secondHeaderView)
    }
    
    lazy var secondItemView: ItemsView = ItemsView.init(isSeparate: false).then { (secondItemView) in
        secondItemView.fontSize = 10
        secondItemView.separate(direction: [.bottom])
        secondItemView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(secondItemView)
    }
    
    lazy var thirdNormalBlockView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (thirdNormalBlockView) in
        thirdNormalBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thirdNormalBlockView)
    }
    
    lazy var forthNormalBlockView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (forthNormalBlockView) in
        forthNormalBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(forthNormalBlockView)
    }
    
    lazy var finalNormalBlockView: CellBlockView = CellBlockView.init(cellHeight: normalCellH).then { (finalNormalBlockView) in
        finalNormalBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(finalNormalBlockView)
    }
    
    lazy var protocolImplementer: PushViewControllerProtocol? = {
        return self.getProtocolImplementer(PushViewControllerProtocol.self)
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let want = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_cashticket_red_selected"), title: "想看") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "想看")
        }
        let watched = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_success_alert_header"), title: "看过") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "看过")
        }
        let comment = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_bank"), title: "影评") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "影评")
        }
        let topics = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_quantity_increase2"), title: "话题") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "话题")
        }
        firstItemView.itemInfos = [want, watched, comment, topics]
        
        let cellInfo = CellBlockView.CellInfo.init(title: "我的订单", disclosuresLabel("全部"), action: { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "全部订单")
        })
        secondHeaderView.cellInfos = [cellInfo]
        
        let unUsed = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_cashticket_red_selected"), title: "未消费") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "未消费")
        }
        let unPay = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_success_alert_header"), title: "待付款") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "待付款")
        }
        let unComment = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_bank"), title: "待评价") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "待评价")
        }
        let refund = ItemInfo.init(logo: #imageLiteral(resourceName: "icon_quantity_increase2"), title: "退款") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "退款")
        }
        secondItemView.itemInfos = [unUsed, unPay, unComment, refund]
        
        let myMessage = CellBlockView.CellInfo.init(title: "我的消息") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "我的消息")
        }
        let myCollection = CellBlockView.CellInfo.init(title: "我的收藏") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "我的收藏")
        }
        let memberCentral = CellBlockView.CellInfo.init(title: "会员中心") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "会员中心")
        }
        let myAchievement = CellBlockView.CellInfo.init(title: "我的成就") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "我的成就")
        }
        thirdNormalBlockView.cellInfos = [myMessage, myCollection, memberCentral, myAchievement]
        
        let myWallet = CellBlockView.CellInfo.init(title: "我的钱包") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "我的钱包")
        }
        let balance = CellBlockView.CellInfo.init(title: "余额") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "余额")
        }
        let discountCoupon = CellBlockView.CellInfo.init(title: "优惠券") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "优惠券")
        }
        let shoppingMall = CellBlockView.CellInfo.init(title: "商城") { [weak self] in
            self?.protocolImplementer?.pushTo?(viewControllerName: "商城")
        }
        forthNormalBlockView.cellInfos = [myWallet, balance, discountCoupon, shoppingMall]
        
        finalNormalBlockView.cellInfos = [CellBlockView.CellInfo.init(title: "设置", action: { [weak self] in
            let vc = SettingViewController()
            self?.protocolImplementer?.pushTo?(viewController: vc)
        })]
    }
    
    private func layoutViews() {
        let blockMargin: CGFloat = 10
        let firstItemH: CGFloat = 68
        let secondItemH: CGFloat = 68
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[firstItemView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["firstItemView":firstItemView]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[firstItemView(==firstItemH)]-blockMargin-[secondHeaderView]-0-[seconItemView(==secondItemH)]-blockMargin-[thirdNormalBlockView]-blockMargin-[forthNormalBlockView]-blockMargin-[finalNormalBlockView]-(>=8)-|",
            options: [.alignAllLeft, .alignAllRight],
            metrics: ["firstItemH":firstItemH,
                      "secondItemH":secondItemH,
                      "blockMargin":blockMargin],
            views: ["firstItemView":firstItemView,
                    "secondHeaderView":secondHeaderView,
                    "seconItemView":secondItemView,
                    "thirdNormalBlockView":thirdNormalBlockView,
                    "forthNormalBlockView":forthNormalBlockView,
                    "finalNormalBlockView":finalNormalBlockView]
        ))
        
        
    }
    
    
}
