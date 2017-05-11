//
//  ViewController.swift
//  Networking
//
//  Created by 武飞跃 on 2017/5/8.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type:.custom)
        btn.center = view.center
        btn.frame.size = CGSize(width:100, height:44)
        btn.backgroundColor = UIColor.gray
        btn.setTitle("点击", for: .normal)
        btn.addTarget(self, action: #selector(btnDidTapped), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    func btnDidTapped(){
        navigationController?.pushViewController(FirstVC(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

