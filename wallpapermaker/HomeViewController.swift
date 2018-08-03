//
//  HomeViewController.swift
//  wallpapermaker
//
//  Created by Gabriela Schirmer  | Stone on 03/08/18.
//  Copyright © 2018 gabischima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
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
        
        var panGesture  = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        textView.isUserInteractionEnabled = true
        textView.addGestureRecognizer(panGesture)
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        let dragView = sender.view
        self.view.bringSubview(toFront: dragView!)
        let translation = sender.translation(in: self.view)
        dragView?.center = CGPoint(x: dragView.center.x + translation.x, y: dragView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.removeFromSuperview()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedSize = CGSize(width: textView.frame.size.width, height: textView.frame.size.height)
        let newSize = textView.sizeThatFits(CGSize(width: fixedSize.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedSize.width), height: max(newSize.height, fixedSize.height))
        textView.isScrollEnabled = false
    }
}

extension HomeViewController: ChildToParentProtocol {
    func changeColor(to color: UIColor) {
        self.view.backgroundColor = color
    }
}



