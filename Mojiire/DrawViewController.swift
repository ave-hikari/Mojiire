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
    
    var inputText: String!
    
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addText.delegate = self as? UITextFieldDelegate
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ライブラリで選択した画像をimageViewのimageにセット
        mainImage.image = tempImage
        
        // ナビバーにsaveボタンを設定
        saveButton = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(DrawViewController.tapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @IBAction func tapAddTextBtn(_ sender: Any) {
        // 文字が画面上に設定されている
        if (self.stampLabel != nil) {
            setText.setTitle("paste!", for: UIControlState.normal)
            let tempImage = self.drawText(image: mainImage.image!, addText: addText.text!)
            mainImage.image = tempImage
            self.stampLabel.removeFromSuperview()
            self.stampLabel = nil
            //何度もラベルを画像に貼れるように画像にラベルをセットし終わったらtextFieldを空にする
            addText.text = nil
            
        } else {
            // デフォルトの配置位置と文字色を設定し addSubView
            self.stampLabel = UILabel(frame:CGRect(x: 50, y: 50, width: 120, height: 20))
            self.stampLabel.text = addText.text
            
            self.stampLabel.textColor = UIColor.white
            self.stampLabel.backgroundColor = UIColor.clear
            textTempColor = self.stampLabel.textColor
            
            self.mainImage.addSubview(self.stampLabel)
            // セット時にボタンの文言も変更する
            setText.setTitle("set!", for: UIControlState.normal)
        }
    }
    
    // タッチ時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // ドラッグ時
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: view)
            if (self.stampLabel != nil) {
                self.stampLabel.transform = CGAffineTransform(translationX: touchLocation.x - self.stampLabel.center.x, y: touchLocation.y - self.stampLabel.center.y)
            }
        }
    }
    
    // ドラッグ終了時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // 文字を画面上に設定している状態で[paste]をタップした際にイメージにテキストを描画する
    func drawText(image:UIImage, addText:String) -> UIImage{
        self.inputText = addText
        
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        //空のコンテキスト（保存するための画像）を選択した画像と同じサイズで設定
        UIGraphicsBeginImageContext(image.size);
        //そこに描画することを設定
        image.draw(in: imageRect)
        
        //ラベルの描画領域を設定
        let textRect  = CGRect(x: (self.stampLabel.frame.origin.x * image.size.width) / mainImage.frame.width, y: (self.stampLabel.frame.origin.y * image.size.height) / mainImage.frame.height, width: image.size.width - 5, height: image.size.height - 5)
        // paragraph(段落)のスタイル
        let textParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        // ラベルの装飾を設定
        let textFontAttributes = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 50),
            NSAttributedStringKey.foregroundColor: textTempColor,
            NSAttributedStringKey.paragraphStyle: textParagraphStyle
        ]
        addText.draw(in: textRect, withAttributes: textFontAttributes)
        
        // コンテキストをイメージとして生成
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        // イメージとテキストの合成完了
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // 作成した画像を保存
    @objc func tapSaveButton(sender: UIButton) {
        // UIImage保存
        UIImageWriteToSavedPhotosAlbum(mainImage!.image!, nil, nil, nil)
        
        let saveAlert = UIAlertController(title: nil, message: "画像を保存しました", preferredStyle: .alert)
        // presentViewControllerでsegueを使わず画面遷移する
        self.present(saveAlert, animated: true, completion: { () -> Void in
            // 遅延実行 別スレッドで3秒間遅延させている間アラートを表示する。3秒後にアラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // your code here
                self.dismiss(animated: true, completion: nil)
                //保存が終わったらメインスレッドで作成したimageViewを消す
                OperationQueue.main.addOperation({
                    self.navigationController?.popViewController(animated: true)
                })
            }
        } )
    }
}
