//
//  ViewController.swift
//  dragUI
//
//  Created by Sumit Ghosh on 02/12/17.
//  Copyright © 2017 Sumit Ghosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var sampleView: UIView!
    var ballView : UIView!
    var animator:UIDynamicAnimator!
    var collision:UICollisionBehavior!
    var push:UIPushBehavior!
    var path:UIBezierPath!
    var itemBehavior:UIDynamicItemBehavior!
    var rows:Int!
    var columns:CGFloat!
    var screenHeight:CGFloat!
    var screenWidth:CGFloat!
    var Dict:NSMutableDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = self.view.frame.size.width
        screenHeight = self.view.frame.size.height
        rows = 3
        columns = 4
        self.sampleView.layer.cornerRadius = self.sampleView.frame.size.height/2
        self.sampleView.layer.masksToBounds = true
        
        
        self.ballView = UIView.init(frame: CGRect(x:self.view.frame.size.width/2,y:self.view.frame.size.height-60,width:15,height:15))
        self.ballView.backgroundColor = UIColor.red
        self.ballView.layer.cornerRadius = ballView.frame.size.height/2
        self.ballView.layer.masksToBounds = true
        self.view .addSubview(self.ballView)
        
        
        self.animator = UIDynamicAnimator.init(referenceView: self.view)
        
        
        self.collision = UICollisionBehavior.init(items:[self.ballView])
        self.collision.collisionDelegate = self
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.animator .addBehavior(self.collision)
        
        self.path = UIBezierPath.init(rect: self.sampleView.frame)
        self.collision .addBoundary(withIdentifier: "sample" as NSCopying, for:path)
        
        
        self.itemBehavior = UIDynamicItemBehavior.init(items: [self.ballView])
        self.itemBehavior.elasticity = 1.0
        self.itemBehavior.friction = 0.0
        self.itemBehavior.resistance = 0.0
        self.animator .addBehavior(self.itemBehavior)
        

        self.push = UIPushBehavior.init(items: [self.ballView], mode: UIPushBehaviorMode.instantaneous)
        self.push.pushDirection = CGVector(dx:0.0,dy:1.0)
        self.push.angle = -0.5
        self.push.active = true
        self.push.magnitude = 0.3
        self.animator .addBehavior(self.push)

        //seting rows and column
        
        self .createBricks()
    }

    func createBricks(){
        self.Dict = NSMutableDictionary.init()
    let numberColumn = Int.init(columns)
    for c in 1...numberColumn {
        for i in 1...rows {
            let factor:CGFloat = CGFloat.init(c)
            let Y:CGFloat = YcordinateForBrick(choice: i)
            let X:CGFloat = 10.0+((screenWidth/columns)*(factor-1))
            let Width:CGFloat = (screenWidth/columns)-16
            let Height:CGFloat = 30.0
            print(X,Y,Width,Height)
            let square:UIView = UIView.init(frame: CGRect(x:X,y:Y,width:Width,height:Height))
            square.backgroundColor = UIColor.blue
            self.view .addSubview(square)
            
            let viewpath = UIBezierPath.init(rect: square.frame)
            let identifier:String = "square"+String.init(c)+String.init(i)
            self.collision .addBoundary(withIdentifier: identifier as NSCopying, for:viewpath)
            self.Dict.setObject(square, forKey: identifier as NSCopying)
        }
      }
    }
    
    func YcordinateForBrick(choice:Int) -> CGFloat {
        switch choice {
        case 1:
            return 0+20;
        case 2:
            return 35+20;
        case 3:
            return 70+20;
        case 4:
            return 105+20;
        default:
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.sampleView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y)
            if view.center.x <= 0
            {
                view.center.x = view.center.x + self.sampleView.frame.size.width/2
            }else if view.center.x >= self.view.frame.size.width
            {
                view.center.x = view.center.x - self.sampleView.frame.size.width/2
            }
        }
        self.path = nil
        self.collision.removeBoundary(withIdentifier: "sample" as NSCopying)
        self.path = UIBezierPath.init(rect: self.sampleView.frame)
        self.collision .addBoundary(withIdentifier: "sample" as NSCopying, for:path)
        recognizer.setTranslation(CGPoint.zero, in: self.sampleView)
    }

}
extension ViewController: UICollisionBehaviorDelegate{
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint)
    {
        
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if (identifier != nil) {
        let current:String = (identifier as? String)!
        if current != "sample"  {
            self.collision.removeBoundary(withIdentifier: current as NSCopying)
            let view:UIView = self.Dict .object(forKey: current as NSCopying) as! UIView
            view .removeFromSuperview()
         }
        }
    }


}


