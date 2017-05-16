//
//  FourViewController.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/4.
//  Copyright © 2017年 RG. All rights reserved.
//

import UIKit
import SnapKit
import EZSwiftExtensions

class FourViewController: UIViewController,MLPhotoBrowserViewControllerDelegate,MLPhotoBrowserViewControllerDataSource {
    var lastSelectPhotos:NSMutableArray!
    var lastSelectAssets:NSMutableArray!
    var imageContentView:UIView!
    var photos:NSArray!
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
            self.showWithPreview(preview: true)
            
        }
        imageContentView = UIView.init(x: 0, y: 300, w: view.size.width, h: 200)
        view.addSubview(imageContentView)
        // Do any additional setup after loading the view.
    }
    func showWithPreview(preview:Bool){
        
       let picker = SuPhotoPicker()
        picker.selectedCount = 10
        picker.preViewCount = 2
        picker.show(inSender: self) { (photos) in
            self.showSelectedImage(images: photos!)
        }
        
        
    }
    func showSelectedImage(images:Array<UIImage>){
        let width = (view.size.width-50)/4
        photos = images as NSArray!
        for i in 0..<images.count{
            let imageView = UIImageView.init(frame: CGRect.init(x: 10+(width+10)*CGFloat(i), y: 0, w: width, h: width))
            imageView.image = images[i]
            imageView.tag = i
                        print(imageView.tag)
            
            imageView.addTapGesture(action: { (action) in
                let indexPath = NSIndexPath.init(row: imageView.tag, section: 0)
                let photoBrowser = MLPhotoBrowserViewController()
                photoBrowser.status = .zoom
                photoBrowser.delegate = self
                photoBrowser.dataSource = self
                photoBrowser.currentIndexPath = NSIndexPath.init(item: indexPath.row, section: 0) as IndexPath!
                photoBrowser.show()
                
            })
            imageContentView.addSubview(imageView)

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func photoBrowser(_ photoBrowser: MLPhotoBrowserViewController!, numberOfItemsInSection section: UInt) -> Int {
        return photos.count
    }
    func photoBrowser(_ photoBrowser: MLPhotoBrowserViewController!, photoAt indexPath: IndexPath!) -> MLPhotoBrowserPhoto! {
        let photo = MLPhotoBrowserPhoto()
        photo.photoObj = photos[indexPath.row]
        let imageView:UIImageView = self.imageContentView.subviews[indexPath.row] as! UIImageView
        photo.toView = imageView
        photo.thumbImage = imageView.image
        return photo
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
extension FourViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZLCollectionCell", for: indexPath)
        return cell
    }
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
