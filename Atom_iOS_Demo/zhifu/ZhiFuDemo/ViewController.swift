//
//  ViewController.swift
//  ZhiFuDemo
//
//  Created by 齐翠丽 on 17/2/28.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tn = "201508281139266004168"
    
    var tnMode = String()
    var responseData : NSMutableData!
    var alert : UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let alipay = UIButton.init(type: .custom)
        alipay.frame = CGRect.init(x: 50, y: 100, width: 80, height: 44)
        alipay.setTitle("支付宝支付", for: .normal)
        alipay.backgroundColor = UIColor.orange
        alipay.addTarget(self, action: #selector(aliPay), for: .touchUpInside)
        self.view.addSubview(alipay)
        
        let wechartPay = UIButton.init(type: .custom)
        wechartPay.frame = CGRect.init(x:self.view.frame.size.width-80-50, y: 100, width: 80, height: 44)
        wechartPay.setTitle("微信支付", for: .normal)
        wechartPay.backgroundColor = UIColor.brown
        wechartPay.addTarget(self, action: #selector(wechartpay), for: .touchUpInside)
        self.view.addSubview(wechartPay)
        tnMode = "01" //测试环境  上线时，请改为“00”
        //微信支付成功的通知
        NotificationCenter.default.addObserver(self, selector: #selector(dealWXpayResult), name: NSNotification.Name(rawValue: "WXpayresult"), object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    func dealWXpayResult(notification:NSNotification){
        print(notification.object ?? ["key":"value"])
    }

    func aliPay(){
        /*
         支付宝支付--前台签名
         */        if alipayPartner.characters.count == 0 || alipaySeller.characters.count == 0 || aliPayPrivateKey.characters.count == 0 {
//         let  alert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
//            alert.
            print("缺少patner等参数")
//            let alert = UIAlertView(title: "",message: "",delegate: nil,cancelButtonTitle: "确定",otherButtonTitles: "")
//            alert.show()
        }
        /*
         生订单信息以及签名
         将商品信息赋予alipayorder的成员变量
         */
        let order = Order()
        order.partner = alipayPartner
        order.seller = alipaySeller
        order.tradeNO = tn//订单id
        order.productName = "海印社区---支付"//商品标题
        order.productDescription = "积分商城:支付宝移动支付"//商品描述
        order.amount = "0.01"//商品价格
        order.notifyURL = alipayNotifServerURL//回调url
        order.service = "mobile.securitypay.pay";
        order.paymentType = "1";
        order.inputCharset = "utf-8";
        order.itBPay = "30m";
        order.showUrl = "m.alipay.com";
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        let appScheme = URLScheme;
        
        let orderSpec = order.description;
        let signer = CreateRSADataSigner(aliPayPrivateKey);//用私钥做签名
        let signedString = signer?.sign(orderSpec);
        if signedString != nil {
            let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\"";
            //支付方法
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme) { (dic)-> Void in
                print(dic as AnyObject)
                if dic?["resultStatus"]as! String == "9000"{
                    print("支付成功")
                }else{
                    let resultMes = dic?["memo"] as! String
                    print("支付失败:\(resultMes)")
                }
                
                
            }
        }
        /*
         支付宝支付--后台签名
         */
        /*
         Networking.newDefaultNetworking()
         .request(DefaultAPI.pay_service_alipay(serviceID: serviceId, amount: money))
         .filterSuccessfulStatusCodes()
         .mapJSON()
         .mapToIgnoreOutside(object: AliDataModel.self)
         
         .subscribe{[weak self] even in
         
         
         switch even {
         case .next(let element):
         self?.aliPayModel = element
         self?.aliPaySiin()
         log.debug("支付宝签名")
         case .completed:
         self?.hidePageLoading()
         case .error(let error):
         log.error(error)
         
         
         
         }
         
         }.addDisposableTo(disposeBag)

 */
        
    }
    //支付宝支付后台签名
    /*
    func aliPaySiin(){
        AlipaySDK.defaultService().payOrder(self.aliPayModel.order_info, fromScheme: String.URLScheme, callback: {[weak self] resultDic in
            if let strongSelf = self {
                print("Alipay result = \(resultDic)")
                let resultDic = resultDic
                if let resultStatus = resultDic?["resultStatus"] as? String {
                    if resultStatus == "9000" {
                        self?.alipaySuccess()
                        strongSelf.delegate?.paymentSuccess(paymentType: .Alipay)
                        let msg = "支付成功！"
                        let alert = UIAlertView(title: nil, message: msg, delegate: nil, cancelButtonTitle: "好的")
                        alert.show()
                        //strongSelf.navigationController?.popViewControllerAnimated(true)
                    } else {
                        strongSelf.delegate?.paymentFail(paymentType: .Alipay)
                        let alert = UIAlertView(title: nil, message: "支付失败，请您重新支付！", delegate: nil, cancelButtonTitle: "好的")
                        alert.show()
                    }
                }
            }
        })
    }
*/
    //微信支付签名
//    func wechatSiign(){
//        let req = PayReq()
//        req.openID = wechatModel.appid
//        print(req.openID)
//        req.partnerId = wechatModel.partnerid
//        req.prepayId = wechatModel.prepayid
//        req.nonceStr = wechatModel.noncestr
//        print(wechatModel.timestamp)
//        let str1 = wechatModel.timestamp!
//        //"\(Date().timeIntervalSince1970)"
//        print(str1)
//        var str = ""
//        if str1.length > 10{
//            let range = str1.index(str1.startIndex, offsetBy: 10)
//            str = str1.substring(to: range)
//            print(str)
//        }else{
//            str = str1
//        }
//        print(str)
//        req.timeStamp = UInt32(str)!
//        print(req.timeStamp)
//        req.package = "Sign=WXPay"
//        req.sign = wechatModel.sign
//        WXApi.send(req)
//        
//        print("appid=\(req.openID)\npartid=\(req.partnerId)\nprepayid=\(req.prepayId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(req.package)\nsign=\(req.sign)");
//    }

    func wechartpay(){
        //微信支付--前台签名
        var a = 0
        let ordreno = "\(time(&a))"
        wxPayWith(orderID: ordreno, orderTitle: "微信支付", amount: "0.01")
        //微信支付后台签名
    
//        Networking.newDefaultNetworking()
//            .request(DefaultAPI.pay_service_weixin(serviceID: self.serviceId, amount: money))
//            .filterSuccessfulStatusCodes()
//            .mapJSON()
//            .mapToIgnoreOutside(object: WechatDataModel.self)
//            
//            .subscribe{[weak self] even in
//                
//                
//                switch even {
//                case .next(let element):
//                    self?.wechatModel = element
//                    //*************注册微信支付信息************
//                    //WXApi.registerApp(element.appid, withDescription: "apppaydemo1.0")
//                    
//                    
//                    self?.wechatSiign()
//                    log.debug("微信支付签名")
//                case .completed:
//                    self?.hidePageLoading()
//                case .error(let error):
//                    log.error(error)
//                    self?.btn.isEnabled = true
//                    self?.delegate?.paymentFail(paymentType: .Weichat)
//                    let alert = UIAlertView(title: nil, message: "获取支付信息失败，请重新支付！", delegate: nil, cancelButtonTitle: "好的")
//                    alert.show()
//                    
//                    
//                    
//                }
//                
//            }.addDisposableTo(disposeBag)
        
    }
    
    func wxPayWith(orderID:String,orderTitle:String,amount:String){
        
        //实际的金额
        let realPrice = "\(Int(Float(amount)!*100))"
        //创建支付签名对象
        let req = payRequsestHandler()
        req.initwith(APP_ID, mch_id: MCH_ID)
        
        //req.init(APP_ID, mch_id: MCH_ID)
        //设置秘钥
        req.setKey(PARTNER_ID)
        print(req)
        //获取到实际调起微信支付的参数后,在app端调起支付
        let dict = req.sendPay_demo(orderID, title: orderTitle, price: realPrice) as NSMutableDictionary
            //req.sendPay_demo(orderID, title: orderTitle, price: realPrice) ?? ""
        print(dict)
//        if dict == "" {
           let debug = req.getDebugifo()
           print("错误信息:\(debug)")
//        }else{
            let dicc = dict
         let stamp = dicc["timestamp"] as! String
            
            let reqe = PayReq()
            reqe.openID = dicc["appid"] as! String
            reqe.partnerId = dicc["partnerid"] as! String
            reqe.prepayId = dicc["prepayid"] as! String
            reqe.nonceStr = dicc["noncestr"] as! String
            reqe.timeStamp  =  UInt32(stamp as String)!
            reqe.package = dicc["package"] as! String
            reqe.sign = dicc["sign"] as! String
            
            let status = WXApi.send(reqe)
            print(status)
        
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.present(EmptyViewController(), animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

