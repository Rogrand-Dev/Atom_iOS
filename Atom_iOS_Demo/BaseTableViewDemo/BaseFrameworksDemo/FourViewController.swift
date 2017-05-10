//
//  FourViewController.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/4.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit
import SnapKit

class FourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择图片"
        view.backgroundColor = UIColor.white
        
        let singlePicture = UIButton(type: .custom)
        singlePicture.setTitle("单张图片", for: .normal)
        singlePicture.backgroundColor = UIColor.orange
        singlePicture.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(singlePicture)
        singlePicture.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(80)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        let mutiplatePicture = UIButton(type:.custom)
        mutiplatePicture.setTitle("多张图片", for: .normal)
        mutiplatePicture.backgroundColor = UIColor.orange
        mutiplatePicture.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(mutiplatePicture)
        mutiplatePicture.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(singlePicture.snp.bottom).offset(60)
            make.width.equalTo(80)
            make.height.equalTo(40)

        }
        singlePicture.addTapGesture { (action) in
            //单选
            let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                //
            }
            
            sheet.addAction(cancelAction)
            
            let takePhoto = UIAlertAction.init(title: "拍照", style: .default) { (action) in
                //选择拍照的操作
                //判断设置是否支持图片库
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    //初始化图片控制器
                    let picker = UIImagePickerController()
                    //设置代理
                    picker.allowsEditing = true
                    picker.delegate = self
                    //指定图片控制器类型
                    picker.sourceType = UIImagePickerControllerSourceType.camera
                    //弹出控制器，显示界面
                    self.present(picker, animated: true, completion: {
                        () -> Void in
                        
                    })
                }
                
            }
            sheet.addAction(takePhoto)
            
            
            let photoLibriry = UIAlertAction.init(title: "从手机相册选择", style: .default) { (action) in
                //选择手机相册的操作
                
                //判断设置是否支持图片库
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    //初始化图片控制器
                    let picker = UIImagePickerController()
                    //设置代理
                    picker.allowsEditing = true
                    picker.delegate = self
                    //指定图片控制器类型
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    //弹出控制器，显示界面
                    self.present(picker, animated: true, completion: {
                        () -> Void in
                        
                    })
                }else{
                    print("读取相册错误")
                }
                
            }
            sheet.addAction(photoLibriry)
            self.presentVC(sheet)
            

        }

        mutiplatePicture.addTapGesture { (action) in
            //多选图片
            
        }
        
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
extension FourViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var imageToSave:UIImage
        //获取选择的原图
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        //headerIcon.setBackgroundImage(pickedImage, for: .normal)
        imageToSave = info["UIImagePickerControllerEditedImage"] as! UIImage
        //上传图片
        self.uploadImage(image: imageToSave, path: filePath)
        //图片控制器退出
        picker.dismiss(animated: true, completion:nil)
        
        
    }
    func uploadImage(image:UIImage,path:String){
        //上传图片的接口
    }

}
