//
//  FirstVC.swift
//  GLCircleScrollVeiw
//
//  Created by god、long on 15/7/3.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit
import Kingfisher

class FirstVC: UIViewController {

    //MARK:- System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Circle"
        
        let url = URL(string: "http://desk.fd.zol-img.com.cn/t_s1280x800c5/g5/M00/07/0F/ChMkJljm_yuIYqSsABBV4J7WQmwAAbb9gCiLRcAEFX4103.jpg")
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 20.0, y: 64.0, width: UIScreen.main.bounds.size.width - 20.0*2, height: 140.0))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(named:"first.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        self.view.addSubview(imageView)
        
        
        
        let nextButton = UIButton(frame: CGRect(x: 0, y: 340, width: self.view.frame.size.width, height: 40))
        nextButton.backgroundColor = UIColor.red
        nextButton.setTitle("下一个界面", for: UIControlState())
        nextButton.addTarget(self, action: #selector(FirstVC.nextButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
    }
    
    //MARK:- Privite Methods
    func nextButtonPressed(_ sender: UIButton) {
        let vc = SecondVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    //MARK:- End Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
