//
//  FiveViewController.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/4.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit

class FiveViewController: UIViewController {
    var tableview:UITableView!
    let arr = ["带图片的弹出框","带输入框的弹出框"]
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "弹框"
        view.backgroundColor = UIColor.white
        tableview = UITableView(frame: view.frame, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FiveViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellid")
        cell.textLabel?.text = arr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //带图片的弹出框
            let alert = CustomAlertActionController(title: "alert", message: "hello,world,这是一个新通知,请查看,哈哈哈哈哈哈", preferredStyle: .alert)
            let image = UIImage(named: "alert")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect.init(x: -50, y: -(image?.size.height)!/2.0, w: (image?.size.width)!, h: (image?.size.height)!)
            alert.view.addSubview(imageView)
            let sure = CustomAlertAction.init(title: "ok", style: .default) { (action) in
                print("确定")
            }
            sure.textColor = UIColor.red
            let cancel = CustomAlertAction.init(title: "cancel", style: .default) { (action) in
                print("取消")
            }
            cancel.textColor = UIColor.blue
            alert.addAction(sure)
            alert.addAction(cancel)
            self.presentVC(alert)

        default:
            let clvie = CLView.initclview()
            //clvie.clView()
            clvie?.frame = CGRect.init(x: 0, y: 0, w: 260, h: 200)
            clvie?.delegate = self
            KGModal.sharedInstance().show(withContentView: clvie)
        }
    }
}
extension FiveViewController:CLViewDelegate{
    func clickedCommitButton(withMoneyString string: String!) {
        log.debug("支付\(string)")
            }

}
