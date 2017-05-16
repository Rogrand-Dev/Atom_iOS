//
//  GetVillageListModel.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import ObjectMapper
class GetVillageListModel: Mappable {
    var total:Int?
    var page:Int?
    var count:Int?
    var list:Array<VillageListModel>!
    required init?(map: Map) {
        
    }
    func mapping(map:Map){
        list        <- map["list"]
        total       <- map["total"]
        page        <- map["page"]
        count       <- map["count"]
    }
    
}
class VillageListModel: Mappable {
    var name: String?
    var logo: String?
    var id: String?
    
    required init?(map:Map){
        
    }
    
    func mapping(map:Map){
        name     <- map["name"]
        logo   <- map["logo"]
        id          <- map["id"]
    }
    
}
