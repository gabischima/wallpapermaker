//
//  HomeViewController.swift
//  wallpapermaker
//
//  Created by Gabriela Schirmer  | Stone on 03/08/18.
//  Copyright © 2018 gabischima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var panGesture  = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotateGesture = UIRotationGestureRecognizer()
    
    var textViewTransform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
    var parentViewTransform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)

    var defaultFont = UIFont.systemFont(ofSize: 16, weight: .thin)
    
    var textIsEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
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
        
        let textView = UITextView()
        textView.text = ""
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        textView.frame.size = CGSize(width: self.view.frame.width, height: 34)
        textView.center = CGPoint(x: self.view.frame.width / 2, y: myview.frame.height / 2)
        
        myview.addSubview(textView)
        self.view.addSubview(myview)
        
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.isScrollEnabled = false

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        textView.addGestureRecognizer(panGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        textView.addGestureRecognizer(pinchGesture)
        
        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        textView.addGestureRecognizer(rotateGesture)
        
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotateGesture.delegate = self
        
        //Enable multiple touch and user interaction for textView and myview
        textView.isUserInteractionEnabled = true
        textView.isMultipleTouchEnabled = true
        myview.isUserInteractionEnabled = true
        myview.isMultipleTouchEnabled = true

    }
    
    func fitSize(_ textView: UITextView) {
        let fixedSize = CGSize(width: textView.frame.size.width, height: textView.frame.size.height)
        let newSize = textView.sizeThatFits(CGSize(width: fixedSize.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedSize.width), height: newSize.height)
        textView.superview?.bounds = CGRect(x: textView.bounds.origin.x, y: textView.bounds.origin.y, width: textView.bounds.width, height: textView.bounds.height)

    }
    
    //MARK:- Handle Gestures Methods

    @objc func handlePan(_ gestureRecognizer:UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.superview?.center = CGPoint(x: (gestureRecognizer.view!.superview?.center.x)! + translation.x, y: (gestureRecognizer.view!.superview?.center.y)! + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc func handlePinch(_ gestureRecognizer:UIPinchGestureRecognizer) {
        if (gestureRecognizer.state == .began || gestureRecognizer.state == .changed) {
            let pinchView = gestureRecognizer.view as! UITextView
            let parentView = (pinchView.superview)!
            let pointSize = pinchView.font?.pointSize
            let scale = gestureRecognizer.scale
            var newSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize!;
            
            if (newSize < 13) {newSize = 13}
            if (newSize > 150) {newSize = 150}
            
            pinchView.font = UIFont(name: (pinchView.font?.fontName)!, size: newSize)
            fitSize(pinchView)
            
            let transform = parentView.transform
            parentView.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(transform)
            
            gestureRecognizer.scale = 1
        }
    }
    
    @objc func handleRotate(_ gestureRecognizer:UIRotationGestureRecognizer) {
        if let view = gestureRecognizer.view?.superview {
            let transform = view.transform
            view.transform = CGAffineTransform(rotationAngle: gestureRecognizer.rotation).concatenating(transform)
            gestureRecognizer.rotation = 0
        }
    }
    
}

extension HomeViewController: UIGestureRecognizerDelegate {
    //MARK:- UIGestureRecognizerDelegate Methods
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (textIsEditing) {
            return false
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // If either gesture recognizer is a long press, do not allow
        // simultaneous recognition.
        if gestureRecognizer is UILongPressGestureRecognizer ||
            otherGestureRecognizer is UILongPressGestureRecognizer {
            return false
        }
        
        // If the gesture recognizer's view isn't one of the squares, do not
        // allow simultaneous recognition.
        if gestureRecognizer.view is UITextView  {
            return true
        }
        
        return true
    }
}

//MARK:- UITextView Methods
extension HomeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textIsEditing = true
        textViewTransform = textView.transform
        parentViewTransform = (textView.superview?.transform)!
        defaultFont = textView.font!

        textView.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
        textView.superview?.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .thin)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.superview?.removeFromSuperview()
        }
        textView.transform = textViewTransform
        textView.superview?.transform = parentViewTransform
        textView.font = defaultFont
        
        textIsEditing = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        fitSize(textView)
    }
}

//MARK:- Protocol
extension HomeViewController: ChildToParentProtocol {
    func changeColor(to color: UIColor) {
        self.view.backgroundColor = color
    }
}



