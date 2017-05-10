//
//  FirstViewController.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/4.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit
import Moya
import RxSwift
class FirstViewController: UIViewController {
    var tableView:DataTableView!
    lazy var disposeBag:DisposeBag = {
        return DisposeBag()
    }()
    var data:DataListPresenter<VillageListModel>!
       override func viewDidLoad() {
        super.viewDidLoad()
        title = "baseTableView"
        view.backgroundColor = UIColor.white
        data = DataListPresenter(delegate: self)

        tableView = DataTableView.init(frame: view.frame, style: .plain, refrshType: .all, loadDataType: .page)
        tableView.dataList = data
        tableView.delegate = self
        tableView.dataSource = self
        //data.refreshingAction(type: .page)
        
        view.addSubview(tableView)
        tableView.beginRefreshing()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadaData(isPull dropDown: Bool, page: Int, time: String) {
        Networking.newDefaultNetworking()
            .request(API.getvillageList(keyword:"",count:"10",page:"\(page)"))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToIgnoreOutside(object: GetVillageListModel.self)
            .subscribe{[weak self] even in
            self?.tableView!.endRefresh()
                switch even {
                case .next(let value):
                    self?.data.total(number: value.total!)
                    self?.data.append(array: value.list, dropDown: dropDown, type: .page)
                    self?.tableView.reloadData()
                case .completed:
                    log.debug("")
                //self?.hidePageLoading()
                case .error(let error):
                    log.error(error)
                    
                }
                
                
            }.addDisposableTo(disposeBag)
        
    }

}
extension FirstViewController:DataListProtocol{
    func request(page: Int, dropDown: Bool, time: String) {
        loadaData(isPull: dropDown, page: page, time: time)
    }
    func noMoreData() {
        //
        tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    func endDataLoad(){
        //
    }//加载数据结束
}
extension FirstViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.data != nil {
            return self.data.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellidentifier")
        if self.data != nil {
                    cell.textLabel?.text = self.data[indexPath.row]?.name
        }

        return cell
    }
}
extension FirstViewController:BaseTableViewDelegate{


//    func loadaData(isPull: Bool, page: Int, time: String) {
//        Networking.newDefaultNetworking()
//            .request(API.getvillageList(keyword:"",count:"10",page:"\(page)"))
//            .filterSuccessfulStatusCodes()
//            .mapJSON()
//            .mapToIgnoreOutside(object: GetVillageListModel.self)
//            .subscribe{[weak self] even in
//                //                self?.myTableView!.endRefresh()
//                switch even {
//                case .next(let value):
//                    //self?.model = value
//                    print("next---\(value)-----")
//                    //self?.myTableView?.reloadData()
//                    var nodata = false//有数据
//                    if value.list.count < value.total!{
//                        nodata = false//有数据
//                    }else{
//                        nodata = true//没数据
//                    }
//                  self?.dataArray = self?.tableView.savaDatawith(dataArray: value.list, noData: nodata, isPull: isPull) as! Array<VillageListModel>!
//                    self?.tableView.reloadData()
//                case .completed:
//                    log.debug("")
//                //self?.hidePageLoading()
//                case .error(let error):
//                    log.error(error)
//                    
//                }
//                
//                
//            }.addDisposableTo(disposeBag)
//
//    }
}
