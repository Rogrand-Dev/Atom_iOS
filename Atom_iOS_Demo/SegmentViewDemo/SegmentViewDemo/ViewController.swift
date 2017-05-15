//
//  ViewController.swift
//  SegmentViewDemo
//
//  Created by 刘岭 on 17/5/12.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SegmentViewDelegate {

    
    lazy var segmentView: SegmentView = {
        let v = SegmentView.init(frame: CGRect.zero, itemTitles: ["111","22","3","44"], style: SegmentStyle.line, contentSize: nil)
        v.delegate = self
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSegmentView()
        addReloadBtn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addSegmentView() {
        self.view.backgroundColor = UIColor.white
        //            UIColor.init(red: 35/255.0, green: 39/255.0, blue: 63/255.0, alpha: 1/0)
        self.view.addSubview(segmentView)
        segmentView.frame  = CGRect.init(x: 0, y: 64, width: self.view.bounds.width, height: 44)
        segmentView.bgColor = UIColor.lightGray
        segmentView.segmentBgColor = UIColor.gray
        segmentView.setItemTitleColor(normal: UIColor.white, selected: UIColor.green)
        
        segmentView.segmentBorderColor = UIColor.black.withAlphaComponent(0.3)
        
        
    }
    
    func segmentViewChangeToItem(_ segmentControlView: SegmentView, index: Int)
    {
        print("change item to \(index)")
        // index = 0 展示类型筛选
        // index ＝ 1 展示排序
    }
    
    func addReloadBtn() {
        let reloadBtn = UIButton.init(type: .system)
        reloadBtn.setTitle("reload", for: .normal)
        reloadBtn.sizeToFit()
        reloadBtn.addTarget(self, action: #selector(changeSegment), for: .touchUpInside)
        self.view.addSubview(reloadBtn)
        
        reloadBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btn]-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["btn": reloadBtn]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btn]-|", options: .directionLeadingToTrailing, metrics: nil, views: ["btn": reloadBtn]))
        
    }
    
    func changeSegment() {
        segmentView.changeToItem(index: 3)
    }

}
