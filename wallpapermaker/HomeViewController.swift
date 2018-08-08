//
//  HomeViewController.swift
//  wallpapermaker
//
//  Created by Gabriela Schirmer  | Stone on 03/08/18.
//  Copyright © 2018 gabischima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var panGesture  = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotateGesture = UIRotationGestureRecognizer()
    
    var initialRotation = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
    var initialFont = UIFont.systemFont(ofSize: 16, weight: .thin)
    
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
        let textView = UITextView()
        textView.text = ""
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        textView.frame.size = CGSize(width: self.view.frame.width, height: 34)
        textView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        self.view.addSubview(textView)
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
        
        //Enable multiple touch and user interaction for textfield
        textView.isUserInteractionEnabled = true
        textView.isMultipleTouchEnabled = true
    }
    
    func fitSize(_ textView: UITextView) {
        let fixedSize = CGSize(width: textView.frame.size.width, height: textView.frame.size.height)
        let newSize = textView.sizeThatFits(CGSize(width: fixedSize.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedSize.width), height: newSize.height)
    }
    
    //MARK:- Handle Gestures Methods

    @objc func handlePan(_ gestureRecognizer:UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc func handlePinch(_ gestureRecognizer:UIPinchGestureRecognizer) {
        if let view = gestureRecognizer.view as? UITextView {
//            let screenScaleFactor = UIScreen.main.scale
//            view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
//            view.textInputView.contentScaleFactor = screenScaleFactor * gestureRecognizer.scale;
            let scale = gestureRecognizer.scale
            view.font = UIFont(name: (view.font?.fontName)!, size: (view.font?.pointSize)! * scale)
            gestureRecognizer.scale = 1
//            view.frame.size = CGSize(width: view.frame.width * scale, height: view.frame.height * scale)
//            fitSize(view)
        }
    }
    
    @objc func handleRotate(_ gestureRecognizer:UIRotationGestureRecognizer) {
        if let view = gestureRecognizer.view {
            view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }
    
    //MARK:- UIGestureRecognizerDelegate Methods
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (textIsEditing) {
            return false
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // If the gesture recognizers are on diferent views, do not allow
        // simultaneous recognition.
        if gestureRecognizer.view != otherGestureRecognizer.view {
            return false
        }

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
    
    //MARK:- UITextView Methods

    func textViewDidBeginEditing(_ textView: UITextView) {
        textIsEditing = true
        initialRotation = textView.transform
        initialFont = textView.font!
        textView.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .thin)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.removeFromSuperview()
        }
        textView.transform = initialRotation
        textView.font = initialFont
        textIsEditing = false
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



