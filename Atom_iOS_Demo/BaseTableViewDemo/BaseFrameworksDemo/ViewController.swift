//
//  ViewController.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/2.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit
import Moya
import RxSwift
class ViewController: UIViewController {
    lazy var disposeBag:DisposeBag = {
        return DisposeBag()
    }()
    var model : GetVillageListModel!
    var tableView:UITableView!
    var dataSource:NSArray = ["baseTableView","loading","空页面处理","选择图片","弹框"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //网络请求
        Networking.newDefaultNetworking()
            .request(API.getvillageList(keyword:"",count:"10",page:"\(1)"))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToIgnoreOutside(object: GetVillageListModel.self)
            .subscribe{[weak self] even in
                //                self?.myTableView!.endRefresh()
                switch even {
                case .next(let value):
                    self?.model = value
                    print("next---\(value)-----")
                    //self?.myTableView?.reloadData()
                    
                case .completed:
                    log.debug("")
                    //self?.hidePageLoading()
                case .error(let error):
                    log.error(error)
                    
                }
                
                
            }.addDisposableTo(disposeBag)
        
//创建ui
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellidentifier")
        cell.textLabel?.text = dataSource[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushVC(FirstViewController())
        case 1:
            pushVC(SecondViewController())
        case 2:
            pushVC(ThirdViewController())
        case 3:
            pushVC(FourViewController())
        default:
            pushVC(FiveViewController())
        }
    }
}
