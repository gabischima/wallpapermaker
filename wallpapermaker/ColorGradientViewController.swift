//
//  ColorGradientViewController.swift
//  wallpapermaker
//
//  Created by Gabriela Schirmer  | Stone on 03/08/18.
//  Copyright © 2018 gabischima. All rights reserved.
//
import UIKit

protocol ChildToParentProtocol:class {
    func changeColor(to color: UIColor)
}

class ColorGradientViewController: UIViewController {
    
    weak var delegate: ChildToParentProtocol? = nil
    
    @IBOutlet weak var hueGradientView: UIView!
    @IBOutlet weak var saturationGradientView: UIView!
    @IBOutlet weak var brightnessGradientView: UIView!
    
    @IBOutlet weak var huePicker: UISlider!
    @IBOutlet weak var saturationPicker: UISlider!
    @IBOutlet weak var brightnessPicker: UISlider!
    
    var hueGradientLayer = CAGradientLayer()
    var saturationGradientLayer = CAGradientLayer()
    var brightnessGradientLayer = CAGradientLayer()

    var HueGradientColors = [AnyObject]()
    var SatuarionGradientColors = [AnyObject]()
    var BrightnessGradientColors = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        displayColors()
    
        createGradient(gradient: HueGradientColors, view: hueGradientView, gradientLayer: hueGradientLayer)
        createGradient(gradient: SatuarionGradientColors, view: saturationGradientView, gradientLayer: saturationGradientLayer)
        createGradient(gradient: BrightnessGradientColors, view: brightnessGradientView, gradientLayer: brightnessGradientLayer)

        setGradientLayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func colorSliderChanged(sender: UISlider) {
        setGradientLayer()
        displayColors()
    }
    
    func setGradientLayer() {
        
        saturationGradientLayer.colors = [
            UIColor(hue: CGFloat(huePicker.value) / 360, saturation: 0, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: CGFloat(huePicker.value) / 360, saturation: 1, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
        ]
        
        brightnessGradientLayer.colors = [
            UIColor(hue: CGFloat(huePicker.value) / 360, saturation: CGFloat(saturationPicker.value) / 100, brightness: 0, alpha: 1).cgColor,
            UIColor(hue: CGFloat(huePicker.value) / 360, saturation: CGFloat(saturationPicker.value) / 100, brightness: 1, alpha: 1).cgColor,
        ]
        
        hueGradientLayer.colors = [
            UIColor(hue: 0, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: 0.17, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: 0.33, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: 0.5, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: 0.67, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: 0.83, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
            UIColor(hue: 1, saturation: CGFloat(saturationPicker.value) / 100, brightness: CGFloat(brightnessPicker.value) / 100, alpha: 1).cgColor,
        ]
    }
    
    func createGradient(gradient: [AnyObject], view: UIView, gradientLayer: CAGradientLayer) {
        view.layer.cornerRadius = 15
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = gradient
        
        view.layer.addSublayer(gradientLayer)
    }

    func displayColors(){
        let hue = CGFloat(huePicker.value)
        let saturation = CGFloat(saturationPicker.value)
        let brightness = CGFloat(brightnessPicker.value)
        let color = UIColor(
            hue: hue / 360,
            saturation: saturation / 100,
            brightness: brightness / 100,
            alpha: 1.0)
        delegate?.changeColor(to: color)
    }
    
}

