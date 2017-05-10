//
//  BaseTableView.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/4.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit
import MJRefresh
enum refreshType{
    case header
    case footer
    case all
}
enum loadType{
    case page
    case time
}
protocol BaseTableViewDelegate:NSObjectProtocol {
    func loadaData(isPull:Bool,page:Int,time:String)//isPull:是否上拉
}
class BaseTableView: UITableView {
    var loadtype:loadType!
    var page = 1
    var tempArray = [AnyObject]()
    var loadFlage = true//上拉是否没有数据了
    weak var mj_delegate:BaseTableViewDelegate?
    var firstDate = ""
    var lastDate = ""
    init(frame: CGRect, style: UITableViewStyle,refreshType:refreshType,loadType:loadType) {
        super.init(frame: frame, style: style)
        
        switch refreshType {
        case .header:
            configHeader()
        case .footer:
            configFooter()
        default:
            configHeader()
            configFooter()
        }
      self.loadtype = loadType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //headerview
   func configHeader(){
    let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshAction))
    mj_header = header
    }
    //footerview
    func configFooter(){
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        
        mj_footer = footer
    }
    //下拉刷新
    func refreshAction(){
        switch loadtype! {
        case .page:
            //下拉刷新,数据重置
            page = 1
            loadFlage = true
            //数据清空
            tempArray = []
            //发送网络请求
            mj_delegate?.loadaData(isPull: false, page: page,time: "")
            
        default:
            //下拉
            page = 1
            loadFlage = true
            mj_delegate?.loadaData(isPull: false, page: 1,time: firstDate)
            
        }
        mj_header.endRefreshing()
       print("下拉了")
        
    }
    //上拉加载更多
    func loadMore(){
        switch loadtype! {
        case .page:
            if loadFlage == false {
                mj_footer.endRefreshingWithNoMoreData()
            }else{
                //上拉
                page += 1
                mj_delegate?.loadaData(isPull: true, page: page,time: "")
 
            }

            
        
        default:
            if loadFlage == false {
                mj_footer.endRefreshingWithNoMoreData()
            }else{
                mj_delegate?.loadaData(isPull: true, page: 1, time: lastDate)
            }
        }
       // mj_footer.endRefreshing()
        print("上拉")
    }
}
extension BaseTableView{
    //保存数据
    func savaDatawith(dataArray:Array<AnyObject>,noData:Bool,isPull:Bool)->Array<AnyObject>{
        switch loadtype! {
        case .page:
            //上拉
            
                if isPull == true {
                    tempArray = tempArray + dataArray
                    if noData {
                        loadFlage = false
                        
                    }else{
                        loadFlage = true
                    }
                }else{
                    tempArray = dataArray + tempArray
                    loadFlage = !noData
                }
            return tempArray
        default:
            //时间相关的处理
            //上拉
            if isPull == true {
                tempArray = tempArray + dataArray
                if noData {
                    loadFlage = false
                    
                }else{
                    loadFlage = true
                }
            }else{
                tempArray = dataArray + tempArray
                loadFlage = true
            }
            //
           // firstDate = tempArray.first
            return tempArray
        }
    }
    //时间处理
    func getTime(start:String,end:String){
        firstDate = start
        lastDate = end
    }
}
