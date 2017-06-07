//
//  ViewController.swift
//  MineView
//
//  Created by 刘岭 on 2017/5/31.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public func pushViewController(_ viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 40)
        btn.backgroundColor = UIColor.red
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(goToMineView), for: .touchUpInside)
    }
   
    func goToMineView() {
        print("goToMineView")
        let vc = MineViewController()
        self.pushViewController(vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

