//
//  AppDelegate.swift
//  ZhiFuDemo
//
//  Created by 齐翠丽 on 17/2/28.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let isok = WXApi.registerApp(APP_ID, withDescription: "demo测试")
        print(isok)
        return true
    }
   //支付回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == APP_ID{
            return WXApi.handleOpen(url, delegate: self)
        }
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { resultdic in
            print(resultdic ?? ["key":"value"])
        }
        return true
    }
    func onResp(_ resp: BaseResp!) {
        print(resp.errCode)
        //if resp.isKind(of: PayResp()){
            switch resp.errCode {
            case 0 :
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXpayresult"), object: nil)
            default:
               // strMsg = "支付失败，请您重新支付!"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
            }
        //}
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

