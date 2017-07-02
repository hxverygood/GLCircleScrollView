//
//  SecondVC.swift
//  GLCircleScrollVeiw
//
//  Created by 韩啸 on 2017/6/30.
//  Copyright © 2017年 ___GL___. All rights reserved.
//

import UIKit

class SecondVC: UIViewController, CircleViewDelegate {
    var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        //        let imageArray: [UIImage?] = [UIImage(named: "first.jpg"), UIImage(named: "second.jpg"), UIImage(named: "third.jpg")]
        
        //        self.circleView = CirCleView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 200), imageArray: imageArray)
        
        let imageUrlArray = ["first.jpg", "second.jpg", "third.jpg"]
        
        self.circleView = CircleView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 200), imageUrlArray: imageUrlArray)
        self.circleView.timeInterval = 2.0
        
        circleView.backgroundColor = UIColor.orange
        circleView.delegate = self
        self.view.addSubview(circleView)
        
        let tempButton = UIButton(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width, height: 40))
        tempButton.backgroundColor = UIColor.red
        tempButton.setTitle("changeImage", for: UIControlState())
        tempButton.addTarget(self, action: #selector(self.setImage(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(tempButton)
        
        let oneThanOneImagesButton = UIButton(frame: CGRect(x: 0, y: 390, width: self.view.frame.size.width, height: 40))
        oneThanOneImagesButton.backgroundColor = UIColor.red
        oneThanOneImagesButton.setTitle("多图", for: UIControlState())
        oneThanOneImagesButton.addTarget(self, action: #selector(self.moreThanOneImagesButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(oneThanOneImagesButton)
        
        
//        let delayTime = DispatchTime.now() + 6.0
//        DispatchQueue.main.asyncAfter(deadline: delayTime) {
//            self.circleView.stopAnimation()
//        }
//        DispatchQueue.main.asyncAfter(deadline: delayTime) {
//            self.circleView.startAnimation()
//        }
    }
    
    
    func setImage(_ sender: UIButton) {
        //        circleView.imageArray = [UIImage(named: "first.jpg"), UIImage(named: "third.jpg")]
        circleView.imageUrlArray = ["http://pic1.nipic.com/2008-09-08/200898163242920_2.jpg"]
    }
    
    // 点击了具有多组图片的按钮
    func moreThanOneImagesButtonPressed(_ sender: UIButton) {
        circleView.imageUrlArray = ["second.jpg", "first.jpg"]
    }
    
    func clickCurrentImage(_ currentIndxe: Int) {
        print(currentIndxe);
    }

    
    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
