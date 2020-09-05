//
//  LoadViewController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 05.09.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToTapBarController()
        
        getAnimation(firstPoint: view.frame.midX, secondPoint: view.frame.midY)
        getAnimation(firstPoint: view.frame.midX - 50, secondPoint: view.frame.midY)
        getAnimation(firstPoint: view.frame.midX + 50, secondPoint: view.frame.midY)
    }
    
    func getAnimation(firstPoint: CGFloat, secondPoint: CGFloat) {
        
        let firstLayer = CAShapeLayer()
        let secondLayer = CAShapeLayer()
        
        firstLayer.backgroundColor = UIColor.white.cgColor
        secondLayer.backgroundColor = UIColor.white.cgColor
        
        firstLayer.frame = CGRect(x: firstPoint, y: secondPoint, width: 5, height: 5)
        secondLayer.frame = CGRect(x: firstPoint, y: secondPoint, width: 5, height: 5)
        
        firstLayer.masksToBounds = true
        secondLayer.masksToBounds = true
        firstLayer.cornerRadius = 4
        secondLayer.cornerRadius = 4
        
        view.layer.addSublayer(firstLayer)
        view.layer.addSublayer(secondLayer)
        
        let scale = CABasicAnimation(keyPath: "bounds.size.width")
        scale.byValue = 50
        scale.duration = 1
        scale.fillMode = CAMediaTimingFillMode.forwards
        scale.isRemovedOnCompletion = false
        
        let rotationLeft = CABasicAnimation(keyPath: "transform.rotation")
        rotationLeft.byValue = CGFloat.pi / 4
        rotationLeft.duration = 1
        rotationLeft.beginTime = CACurrentMediaTime() + 1
        rotationLeft.fillMode = CAMediaTimingFillMode.both
        rotationLeft.isRemovedOnCompletion = false
        rotationLeft.autoreverses = true
        
        let rotationRight = CABasicAnimation(keyPath: "transform.rotation")
        rotationRight.byValue = -CGFloat.pi / 4
        rotationRight.duration = 1
        rotationRight.beginTime = CACurrentMediaTime() + 1
        rotationRight.fillMode = CAMediaTimingFillMode.both
        rotationRight.isRemovedOnCompletion = false
        rotationRight.autoreverses = true
        
        firstLayer.add(scale, forKey: nil)
        firstLayer.add(rotationLeft, forKey: nil)
        secondLayer.add(scale, forKey: nil)
        secondLayer.add(rotationRight, forKey: nil)
    }
    
    func goToTapBarController() {
        
        // Откладываем на 3 секунды:
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
}
