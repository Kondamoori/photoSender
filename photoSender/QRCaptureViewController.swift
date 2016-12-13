//
//  QRCaptureViewcontroller.swift
//  photoSender
//
//  Created by macbook on 22.07.16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
extension UINavigationController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if visibleViewController is QRCaptureViewController{
            return UIInterfaceOrientationMask.Portrait
        }
        return UIInterfaceOrientationMask.All
    }
    }
class QRCaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    private var _captureSession:AVCaptureSession?
    private var _videoPreviewLayer:AVCaptureVideoPreviewLayer?
    private var _qrCodeFrameView:UIView?
    private var _closeButton:UIButton=UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")

        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

        var error:NSError?
        var input: AnyObject!
        do{
            input = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch{
            print(error)
        }
        
        _captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        _captureSession?.addInput(input as! AVCaptureInput)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        _captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        _videoPreviewLayer = AVCaptureVideoPreviewLayer(session: _captureSession)
        
        _videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        _videoPreviewLayer?.frame = view.layer.bounds
        
        view.layer.addSublayer(_videoPreviewLayer!)
        
        _captureSession?.startRunning()
        
        _qrCodeFrameView = UIView()
        _qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        _qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(_qrCodeFrameView!)
        view.bringSubviewToFront(_qrCodeFrameView!)
        
        _closeButton.translatesAutoresizingMaskIntoConstraints=false
        var img=UIImage(named: "close")
        _closeButton.setBackgroundImage(img,forState:UIControlState.Normal)
        _closeButton.imageView?.contentMode=UIViewContentMode.Center
        _closeButton.addTarget(self, action: "closeVC:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(_closeButton)
        
       
        
        NSLayoutConstraint.activateConstraints([
            
            _closeButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant:20),
            _closeButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10),
            _closeButton.heightAnchor.constraintGreaterThanOrEqualToAnchor(view.heightAnchor, multiplier: 0.1),
            _closeButton.widthAnchor.constraintGreaterThanOrEqualToAnchor(_closeButton.heightAnchor),
            ])


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func closeVC (sender:UIButton){
        navigationController?.popViewControllerAnimated(true)
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            _qrCodeFrameView?.frame = CGRectZero
            //_messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = _videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            _qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                ServerOperations.defaults?.setObject(metadataObj.stringValue, forKey: "url")
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}