//
//  ViewController.swift
//  EmptyViewDemo
//
//  Created by 刘岭 on 17/5/11.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect.init(x: 20, y: 80, width: 80, height: 40)
        btn.backgroundColor = UIColor.green
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(gotoEmptyView), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func gotoEmptyView() {
        let vc = EmptyViewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

