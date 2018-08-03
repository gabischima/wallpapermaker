//
//  HomeViewController.swift
//  wallpapermaker
//
//  Created by Gabriela Schirmer  | Stone on 03/08/18.
//  Copyright © 2018 gabischima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ColorGradientViewController,
            segue.identifier == "homeToContainer" {
            vc.delegate = self as ChildToParentProtocol
        }
    }
}

extension HomeViewController: ChildToParentProtocol {
    func changeColor(to color: UIColor) {
        self.view.backgroundColor = color
    }
}



