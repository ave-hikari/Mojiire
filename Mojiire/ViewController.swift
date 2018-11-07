//
//  ViewController.swift
//  Mojiire
//
//  Created by Hikari Yanagihara on 2018/08/19.
//  Copyright © 2018年 Hikari Yanagihara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // 内蔵カメラで撮影
    @IBAction func tapCameraButton(_ sender: AnyObject) {
        print(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        // カメラが利用可能か
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let _controller = UIImagePickerController()
            _controller.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            
            _controller.allowsEditing = true
            _controller.sourceType = UIImagePickerControllerSourceType.camera
            self.present(_controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapLibraryButton(_ sender: AnyObject) {
        // ライブラリからイメージ取得
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let _controller = UIImagePickerController()
            _controller.delegate = self
            // 正方形にトリミングする
            _controller.allowsEditing = true
            _controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(_controller, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // キャンセルタップ時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    // 写真選択時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 画面遷移設定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // 遷移するViewを定義
        let nextView = storyboard.instantiateViewController(withIdentifier: "drawView") as! DrawViewController
        present(nextView, animated: true, completion: nil)
        
        // トリミングした画像を設定
        if info[UIImagePickerControllerEditedImage] != nil {
            let imagePicked = info[UIImagePickerControllerEditedImage] as! UIImage
            nextView.tempImage = imagePicked
            print(imagePicked)
        }
        picker.dismiss(animated: true, completion: nil)
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}

