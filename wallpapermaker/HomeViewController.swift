//
//  HomeViewController.swift
//  wallpapermaker
//
//  Created by Gabriela Schirmer  | Stone on 03/08/18.
//  Copyright © 2018 gabischima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var pinchGesture = UIPinchGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    var rotateGesture = UIRotationGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotateGesture.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ColorGradientViewController,
            segue.identifier == "homeToContainer" {
            vc.delegate = self as ChildToParentProtocol
        }
    }
    
    @IBAction func addText(_ sender: Any) {
        let myview = UIView()
        myview.frame.size = CGSize(width: self.view.frame.width, height: 34)
        myview.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        myview.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)

        let textView = UITextView()
        textView.text = ""
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        textView.frame.size = CGSize(width: self.view.frame.width, height: 34)
        textView.center = CGPoint(x: self.view.frame.width / 2, y: myview.frame.height / 2)
        textView.isScrollEnabled = false

        myview.addSubview(textView)
        self.view.addSubview(myview)
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.isUserInteractionEnabled = true
        textView.isMultipleTouchEnabled = true
        myview.isMultipleTouchEnabled = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        myview.addGestureRecognizer(panGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        textView.addGestureRecognizer(pinchGesture)
        
        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        myview.addGestureRecognizer(rotateGesture)
    }
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        let dragView = sender.view
        self.view.bringSubview(toFront: dragView!)
        let translation = sender.translation(in: self.view)
        dragView?.transform = CGAffineTransform.identity
        dragView?.center = CGPoint(x: (dragView?.center.x)! + translation.x, y: (dragView?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func handlePinch(_ sender:UIPinchGestureRecognizer) {
        let pinchView = sender.view as! UITextView
        let parentView = (pinchView.superview)!
        let pointSize = pinchView.font?.pointSize
//        let newSize = ((sender.velocity > 0) ? 1 : -1) * 1 + pointSize!
        let scale = sender.scale
        let newSize = scale * pointSize!
        pinchView.font = UIFont(name: (pinchView.font?.fontName)!, size: max(newSize, 10))
        fitSize(pinchView)
        parentView.transform = CGAffineTransform(scaleX: scale, y: scale)
//        parentView.bounds = parentView.bounds.applying(parentView.transform.scaledBy(x: scale, y: scale))
        sender.scale = 1
    }
    
    @objc func handleRotate(_ sender : UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }

    func fitSize(_ textView: UIView) {
        let fixedSize = CGSize(width: textView.frame.size.width, height: textView.frame.size.height)
        let newSize = textView.sizeThatFits(CGSize(width: fixedSize.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedSize.width), height: newSize.height)
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension HomeViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.removeFromSuperview()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        fitSize(textView)
    }
    
}

extension HomeViewController: ChildToParentProtocol {
    func changeColor(to color: UIColor) {
        self.view.backgroundColor = color
    }
}



