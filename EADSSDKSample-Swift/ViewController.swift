//
//  ViewController.swift
//  AroundTest
//
//  Created by Farzan on 8/20/18.
//  Copyright © 2018 Mevamedia. All rights reserved.
//

import UIKit
import EadsSDK

class ViewController: UIViewController {
    
    var nativeBannerAd: ARNativeBannerView!
    var nativeVideoBannerAd: ARNativeVideoAd!
    
    @IBOutlet weak var sdkModeLabel: UILabel!
    @IBOutlet weak var sdkTokenLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func clearClicked(_ sender: UIButton) {
        statusLabel.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sdkModeLabel.text = EadsAd.config?.environment.value()
        sdkTokenLabel.text = EadsAd.config?.appToken
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    // MARK: Add Advertise Banners
    
    @IBAction func initiateNativeBannerAd(_ sender: UIButton) {
        if nativeBannerAd != nil {
            sender.setTitle("Native Banner", for: .normal)
            nativeBannerAd.removeFromSuperview()
            nativeBannerAd = nil
            return
        }
        sender.setTitle("Dismiss Native Banner", for: .normal)
        nativeBannerAd = ARNativeBannerView(frame: CGRect(x: (view.frame.width - 320) / 2, y: view.frame.height - 250, width: 320, height: 250), size: .BANNER_320x50)
        nativeBannerAd.delegate = self
        view.addSubview(nativeBannerAd)
        nativeBannerAd.execute()
        updateStatusLabel(text: "\(NSStringFromClass(type(of: nativeBannerAd))) is fetching")
        
        nativeBannerAd.clicked = { () -> Void in
            print("Native banner clicked.")
        }
    }

    @IBAction func initiateFullScreenNativeBannerAd(_ sender: UIButton) {
        let banner = ARFullscreenBannerView()
        banner.delegate = self
        banner.execute()
        updateStatusLabel(text: "\(NSStringFromClass(type(of: banner))) is fetching")
        
        banner.clicked = { () -> Void in
            print("Fullscreen banner clicked.")
        }
    }
    
    @IBAction func initiateNativeVideoBannerAd(_ sender: UIButton) {
        if nativeVideoBannerAd != nil {
            sender.setTitle("Native Video Banner", for: .normal)
            nativeVideoBannerAd.removeFromSuperview()
            nativeVideoBannerAd = nil
            return
        }
        sender.setTitle("Dismiss Native Video Banner", for: .normal)
        nativeVideoBannerAd = ARNativeVideoAd(frame: CGRect(x: 0, y: view.frame.height - 250, width: view.frame.width, height: 250))
        nativeVideoBannerAd.delegate = self
        view.addSubview(nativeVideoBannerAd)
        nativeVideoBannerAd.execute()
        updateStatusLabel(text: "\(NSStringFromClass(type(of: nativeVideoBannerAd))) is fetching")
        
        nativeVideoBannerAd.clicked = { () -> Void in
            print("Video banner clicked.")
        }
    }
    
    @IBAction func initiateFullscreenNativeVideoBannerAd(_ sender: UIButton) {
        let banner = ARFullscreenVideoAd(zone: .All)
        banner.delegate = self
        banner.execute()
        updateStatusLabel(text: "\(NSStringFromClass(type(of: banner))) is fetching")
        
        banner.viewCompleted = { () -> Void in
            print("Fullscreen video banner content did finish displaying.")
        }
        
        banner.clicked = { () -> Void in
            print("Fullscreen video banner clicked.")
        }
    }

    private func updateStatusLabel(text: String) {
        statusLabel.text = text + "\n ------ \n" + (statusLabel.text ?? "")
    }
}


// ARAdDelegate for implemented adviews in viewcontroller

extension ViewController: ARAdDelegate {
    
    func eadsAd(_ adView: ARAdView, didDismissWithTag tag: Int) {
        updateStatusLabel(text: "\(NSStringFromClass(type(of: adView))) did dismiss")
    }
    
    func eadsAd(_ adView: ARAdView, willDismissWithTag tag: Int) -> Bool {
        updateStatusLabel(text: "\(NSStringFromClass(type(of: adView))) will dismiss")

        if let ad = adView as? ARFullscreenVideoAd {
            let alert = UIAlertController(title: "Warning", message: "You should see the Ad to get rewarded, Do you want to dismiss the Ad?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in ad.dismiss() }))
            present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
        
    }
    
    func eadsAd(_ adView: ARAdView, ARAdDidFinishLoadWithTag tag: Int, contentAvailable: Bool) {
        updateStatusLabel(text: "\(NSStringFromClass(type(of: adView))) did finished loading with content: \(contentAvailable)")
    }
    
    func eadsAd(_ adView: ARAdView, didCompleteWithError error: SplitError) {
        let errorStr: String
        switch error {
        case .Forbidden: errorStr = "Forbidden"
        case .ServerError: errorStr = "ServerError"
        case .NetworkError: errorStr = "NetworkError"
        case .NoInternetConnection: errorStr = "NoInternetConnection"
        }
        updateStatusLabel(text: "\(NSStringFromClass(type(of: adView))) did Complete with error: \(errorStr)")
    }
        
}
