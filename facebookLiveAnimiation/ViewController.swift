//
//  ViewController.swift
//  facebookLiveAnimiation
//
//  Created by Rui Guo on 11/5/17.
//  Copyright © 2017 Rui Guo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareAni()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func customPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        let y = AnimationParameters.lineCurevedHeight * CGFloat((1 + drand48()*0.5))
        let x = AnimationParameters.lineWidth
        //draw a line
        path.move(to: CGPoint(x: 0, y: y))
        
        let endPoint = CGPoint(x: x, y: y)
        
//        path.addLine(to: endPoint)
        
        
        //config line
        path.lineWidth = AnimationParameters.pathWidth
        
        //add a curve , use a control point
        //add random for control point
        let randomFactor = CGFloat( 1 + drand48())
        let cp1 = CGPoint(x: x / 3 * randomFactor, y: y * 0.5 * randomFactor)
        let cp2 = CGPoint(x: (x * 2 / 3) * randomFactor, y: y * 1.5 * randomFactor)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
   
        
        return path
    }
    func customeImageView()-> UIImageView {
        let height = AnimationParameters.imageViewSize
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        imageView.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        //shadow
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.5
        
        view.addSubview(imageView)
        
      
        return imageView
    }
    
    func setAnimation(for imageView : UIImageView) {
        //layer animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        let path = customPath().cgPath
        
        animation.path = path
        animation.duration = AnimationParameters.animationDuration
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        imageView.layer.add(animation, forKey: nil)
        
        //animation the path
        let shapelayer = CAShapeLayer()
        shapelayer.path = path
        shapelayer.lineWidth = 2.0
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.strokeColor = imageView.backgroundColor?.cgColor
        view.layer.addSublayer(shapelayer)
        
        //animation
        let animationForPath = CABasicAnimation(keyPath: "strokEnd")
        animationForPath.fromValue = 0
        animationForPath.toValue = 1.0
        animationForPath.duration = AnimationParameters.animationDuration
        shapelayer.add(animationForPath, forKey: nil) // key is a name or id for this animation
    }
    
    func prepareAni() {
//        let curveVIEW = cureverdView(frame: view.frame)
//         curveVIEW.backgroundColor = .yellow
//        view.addSubview(curveVIEW)
        
        
        for i in 0..<10 {
            AnimationParameters.delay(Double(i), closure: { [unowned self] in
                let imageView = self.customeImageView()
                
                self.setAnimation(for: imageView)
            })
            
        }
       
        
    }

}

struct AnimationParameters {
    //y position
    static let base = 30.0 // drand48 return random 0-1.0
    static let range = 60.0
    static let yPostion = base + drand48() * range
    
    static let animationDuration = 3.0
    
    static let pathWidth:CGFloat = 3.0
    
    static let lineWidth = UIScreen.main.bounds.size.width
    static let lineCurevedHeight = UIScreen.main.bounds.size.height / 3
    
    static var imageViewSize:CGFloat{
        get {
             return CGFloat(20.0 + 20.0 * drand48())
        }
    }
  
    
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

class cureverdView : UIView {
    override func draw(_ rect: CGRect) {
        let path = customPath()
       

        //stroke
        path.stroke()
    }

    func customPath() -> UIBezierPath {
        let path = UIBezierPath()

        //draw a line
        path.move(to: CGPoint(x: 0, y: 200))

        let endPoint = CGPoint(x: 400, y: 200)

//        path.addLine(to: endPoint)


        //config line
        path.lineWidth = 3

        //add a curve , use a control point
        let cp1 = CGPoint(x: 100, y: 300)
        let cp2 = CGPoint(x: 200, y: 300)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)



        return path
    }

}

