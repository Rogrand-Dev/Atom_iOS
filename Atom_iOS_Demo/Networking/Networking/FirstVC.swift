//
//  FirstVC.swift
//  Networking
//
//  Created by 武飞跃 on 2017/5/9.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

enum XAppDefaultAPI{
    case refresh_token()
}

extension XAppDefaultAPI:TargetType,XAuthType {
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .refresh_token():
            return nil
        
        }
    }
    
    var baseURL: URL {
        return URL(string:"xxx")!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var addAuth: Bool{
        return true
    }
    
}

enum Default2API{
    
    case get_announcement_list(count: Int, page: Int)
    
}

extension Default2API:TargetType,XAuthType {
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string:"")!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var addAuth: Bool{
        return true
    }
    
}



class FirstVC: UIViewController {

    var disposeBag = DisposeBag()
    lazy var label:UILabel = {
        let temp = UILabel()
        temp.text = "1111"
        temp.frame = CGRect(x:10, y:80, width:100, height:20)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.request(Default2API.get_announcement_list(count: 10, page: 1))
            .debug()
            .subscribe(onNext: { (response) in
                
                
            }, onError: { (error) in
                
                
            }).addDisposableTo(disposeBag)

    }
    
    deinit {
        print("firstVC dealloc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
