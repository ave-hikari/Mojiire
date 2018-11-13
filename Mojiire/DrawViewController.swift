//
//  DrawViewController.swift
//  Mojiire
//
//  Created by Hikari Yanagihara on 2018/09/25.
//  Copyright © 2018年 Hikari Yanagihara. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var tempImage: UIImage!
    @IBOutlet weak var addText: UITextField!
    @IBOutlet weak var setText: UIButton!
    
    var stampLabel: UILabel!
    
    var textTempColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addText.delegate = self as? UITextFieldDelegate
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ライブラリで選択した画像をimageViewのimageにセット
        mainImage.image = tempImage
    }
    
    @IBAction func tapAddTextBtn(_ sender: Any) {
        // 文字が画面上に設定されている
        if (self.stampLabel != nil) {
            
        } else {
            // デフォルトの配置位置と文字色を設定し addSubView
            self.stampLabel = UILabel(frame:CGRect(x: 50, y: 50, width: 120, height: 20))
            self.stampLabel.text = addText.text
            
            self.stampLabel.textColor = UIColor.white
            self.stampLabel.backgroundColor = UIColor.clear
            textTempColor = self.stampLabel.textColor
            
            self.mainImage.addSubview(self.stampLabel)
            setText.setTitle("set!", for: UIControlState.normal)
        }
    }
}
