//
//  DataTableView.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/5.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper
enum RefreshType {
    case header
    case footer
    case all
}
enum reloadDataType{
    case page
    case time
}
protocol DataListProtocol:class {
    func noMoreData()//没有数据
    func endDataLoad()//加载数据结束
    func request(page:Int,dropDown:Bool,time:String)//page:第几页 dropdown:上拉 time:时间
}
protocol DataListable:class {
    func refreshingAction(type:reloadDataType)//下拉的操作
    func clearData()//清空数据
    func loadData(type:reloadDataType)//上拉的操作
}

@objc protocol MJRefreshHandler:class{
    @objc optional func handlerHeaderAction()
    @objc optional func handlerFooterAction()
}
extension MJRefreshHandler{
    var header:MJRefreshHeader? {
        let refreshHeader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.handlerHeaderAction))
        return refreshHeader
    }
    var footer:MJRefreshAutoFooter? {
        let refreshFooter = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(handlerFooterAction))
        refreshFooter?.setTitle("没有更多数据了", for: .noMoreData)
        refreshFooter?.setTitle("上拉加载更多", for: .idle)
        refreshFooter?.setTitle("加载中", for: .refreshing)

        return refreshFooter
    }
}
class DataTableView: UITableView,MJRefreshHandler {
    var headerTapCompletion:(()-> Void)?
    var footerTapCompletion:(()-> Void)?
    var loadType:reloadDataType!
    weak var dataList:DataListable!
    init(frame: CGRect, style: UITableViewStyle,refrshType:RefreshType,loadDataType:reloadDataType) {
        super.init(frame: frame, style: style)
        addRefreshType(type: refrshType)
        loadType = loadDataType
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addRefreshType(type:RefreshType) -> Void{
        switch type {
        case .header:
            mj_header = header
        case .footer:
            mj_footer = footer
        default:
            mj_header = header
            mj_footer = footer
        }
    }
    func handlerHeaderAction() {
        dataList.refreshingAction(type: loadType)
    }
    func handlerFooterAction() {
        dataList.loadData(type: loadType)
    }
    func resetDataSource(){
        dataList.clearData()
    }
    func beginRefreshing(){
        guard let head = mj_header else {
            return
        }
        head.beginRefreshing()
    }

    func endHeaderRefreshing(){
        if let mj_footer = mj_footer , dataSourceIsEmpty() == false {
            mj_footer.isHidden = false
        }
        guard let head = mj_header else {
            return
        }
        head.endRefreshing()
    }
    
    func endFooterRefreshing(){
        guard let foot = mj_footer else {
            return
        }
        foot.endRefreshing()
    }
    
    func endRefresh(){
        endHeaderRefreshing()
        endFooterRefreshing()
    }
    func dataSourceIsEmpty() -> Bool{
        
        var items = 0
        
        guard let unwrappedDataSource = dataSource else{
            log.error("dataSource is nil!")
            return true
        }
        
        var sections:Int {
            if let unwrappedSections = unwrappedDataSource.numberOfSections?(in: self) {
                return unwrappedSections
            }
            else {
                return 1
            }
        }
        
        for i in 0 ..< sections {
            items += numberOfRows(inSection: i)
            break
        }
        
        if items == 0 {
            //数据为空
            return true
        }
        
        return false
    }


}
class DataListPresenter<T>:DataListable where T:Mappable {
    var list:Array<T>!//对外调用的数组
    private weak var delegate: DataListProtocol!
    fileprivate var autoAddArray = Array<T>() //自增数组
    
    private(set) var pageNumber:Int = 1 //当前页数
   // private var isFlag = false
    private var loadFlag = true
    private var totalNumber:Int = 0 //总条数
    var firstTime = ""
    var lastTime = ""
    init(delegate:DataListProtocol){
        self.delegate = delegate
        self.list = Array<T>()
    }
    //上拉的操作
    internal func loadData(type:reloadDataType) {
        switch type {
        case .page:
            if loadFlag == false {
            noMoreDataPrompt()
                return
            }
            delegate.request(page: pageNumber, dropDown: false, time: "")
        default:
            if loadFlag == false {
                noMoreDataPrompt()
                return
            }
          delegate.request(page: 1, dropDown: false, time: lastTime)
        }
    }
//清空数据
    internal func clearData() {
        pageNumber = 1
        loadFlag = true
        totalNumber = 0
        self.list = []
        autoAddArray = []
        firstTime = ""
        lastTime = ""
    }
//下拉的操作
    internal func refreshingAction(type:reloadDataType) {
        switch type {
        case .page:
            pageNumber = 1
            autoAddArray = []
            loadFlag = true
            delegate.request(page: pageNumber, dropDown: true, time: "")
            
        default:
            //时间下拉的操作
            pageNumber = 1
            loadFlag = true
            delegate.request(page: pageNumber, dropDown: true, time: firstTime)
        }
        
    }
//没有更多数据了
    func noMoreDataPrompt(){
        loadFlag = false
        delegate.noMoreData()
    }
    //总数据的条数
    func total(number:Int){
        totalNumber = number
    }
    //追加数据,数据的处理
    func append(array:Array<T>,dropDown:Bool,type:reloadDataType){
        switch type {
        case .page:
            self.autoAddArray += array
            self.list = autoAddArray
            self.endDataLoad()
            
            if autoAddArray.count >= totalNumber {
                noMoreDataPrompt()
            }else{
                if array.count > 0 {
                    //请求到的数据如果不为空 页数就加1
                    pageNumber += 1
                }
            }

        default:
            if dropDown == true{
                //下拉
                pageNumber = 1
                self.autoAddArray = array + autoAddArray
                self.list = autoAddArray
                self.endDataLoad()
                
                
            }else{
                //上拉
                pageNumber = 1
                self.autoAddArray += array
                self.list = autoAddArray
                self.endDataLoad()
                if array.count == 0 {
                    noMoreDataPrompt()
                }else{
                    
                }
            }
        }
    }
    func endDataLoad(){
        delegate.endDataLoad()
    }
    
    // MARK: 处理时间的,对于按时间来请求的保存完数据调用此方法
    func dealTime(first:String,last:String){
        firstTime = first
        lastTime = last
    }

}
extension DataListPresenter{
    var isEmpty:Bool{
        return self.list.isEmpty
    }
    var count:Int{
        return self.list.count
    }
    subscript(i:Int) -> T? {
        return self.list.get(at: i)
    }
    
    func remove(index: Int) {
        autoAddArray.remove(at: index)
        list.remove(at: index)
    }
    func removeAll(){
        list.removeAll(keepingCapacity: true)
        autoAddArray.removeAll(keepingCapacity: true)
    }
    

}
