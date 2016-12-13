//
//  ViewController.swift
//  photoSender
//
//  Created by macbook on 21.07.16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let _imagePicker:UIImagePickerController = UIImagePickerController()
    
    private var _mainLogo:UIImageView=UIImageView()
    private var _logoTitleView:UIImageView=UIImageView()
    
    private var _backTopView:UIView=UIView()
    private var _backBottomView:UIView=UIView()
    private var _uploadButton:UIButton=UIButton()
    private var _urlLabel:UILabel=UILabel()
    private var _settingsButton:UIButton=UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerOperations.defaults?.setObject("", forKey: "url")
        
        view.backgroundColor=UIColor.whiteColor()
        
        _imagePicker.delegate=self
        
        _backTopView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(_backTopView)
        
        _backBottomView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(_backBottomView)
        
        _mainLogo.image=UIImage(named: "logo.png")
        _mainLogo.translatesAutoresizingMaskIntoConstraints=false
        _backTopView.addSubview(_mainLogo)
        
        _logoTitleView.image=UIImage(named: "logoText.png")
        _logoTitleView.translatesAutoresizingMaskIntoConstraints=false
        _backTopView.addSubview(_logoTitleView)

        _uploadButton.translatesAutoresizingMaskIntoConstraints=false
        _uploadButton.setImage(UIImage(named: "shareButton.png"), forState: UIControlState.Normal)
        _uploadButton.addTarget(self, action:"upload:", forControlEvents: UIControlEvents.TouchUpInside)
        _backBottomView.addSubview(_uploadButton)
        
        _urlLabel.translatesAutoresizingMaskIntoConstraints=false
        _urlLabel.textAlignment=NSTextAlignment.Center
        _urlLabel.lineBreakMode = .ByWordWrapping
        _urlLabel.numberOfLines=4
        _backBottomView.addSubview(_urlLabel)
        
        _settingsButton.translatesAutoresizingMaskIntoConstraints=false
        let img=UIImage(named: "settings.png")
        _settingsButton.setImage(img,forState:UIControlState.Normal)
        _settingsButton.imageView?.contentMode=UIViewContentMode.Center
        _settingsButton.addTarget(self, action: "createPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(_settingsButton)
        
        NSLayoutConstraint.activateConstraints([
            _backTopView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            _backTopView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            _backTopView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 40),
            _backTopView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.5),
            
            _mainLogo.centerXAnchor.constraintEqualToAnchor(_backTopView.centerXAnchor),
            _mainLogo.topAnchor.constraintEqualToAnchor(_backTopView.topAnchor),
            _mainLogo.heightAnchor.constraintLessThanOrEqualToAnchor(_backTopView.heightAnchor, multiplier: 0.4),
            _mainLogo.widthAnchor.constraintEqualToAnchor(_mainLogo.heightAnchor),
            
            _logoTitleView.centerXAnchor.constraintEqualToAnchor(_backTopView.centerXAnchor),
            _logoTitleView.topAnchor.constraintEqualToAnchor(_mainLogo.bottomAnchor, constant: 20),
            _logoTitleView.heightAnchor.constraintLessThanOrEqualToAnchor(_backTopView.heightAnchor, multiplier: 0.4),
            
            _backBottomView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            _backBottomView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            _backBottomView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.4),
            _backBottomView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: 5),
            
            _uploadButton.centerXAnchor.constraintEqualToAnchor(_backBottomView.centerXAnchor),
            _uploadButton.topAnchor.constraintEqualToAnchor(_backBottomView.topAnchor),
            _uploadButton.heightAnchor.constraintEqualToAnchor(_backBottomView.heightAnchor, multiplier: 0.5),
            
            _urlLabel.topAnchor.constraintEqualToAnchor(_uploadButton.bottomAnchor, constant: 5),
            _urlLabel.leftAnchor.constraintEqualToAnchor(_backBottomView.leftAnchor),
            _urlLabel.rightAnchor.constraintEqualToAnchor(_backBottomView.rightAnchor),
            
            _urlLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            
            _settingsButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20),
            _settingsButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor,constant: -10),
            _settingsButton.heightAnchor.constraintGreaterThanOrEqualToAnchor(view.heightAnchor, multiplier: 0.1),
            _settingsButton.widthAnchor.constraintGreaterThanOrEqualToAnchor(_settingsButton.heightAnchor),
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        _urlLabel.text=ServerOperations.defaults?.stringForKey("url")
    }
    
    
    func upload(sender:UIButton){
        _imagePicker.allowsEditing = false
        presentViewController(_imagePicker, animated: true, completion: nil)
        
    }
    func createPhoto(sender: UIButton){
        navigationController?.pushViewController(QRCaptureViewController(), animated: true)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if picker.sourceType==UIImagePickerControllerSourceType.PhotoLibrary{
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                print("1")
                ServerOperations.uploadImage(UIImageJPEGRepresentation(pickedImage, 1.0)!)
                
            }

        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

