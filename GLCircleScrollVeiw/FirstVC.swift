//
//  FirstVC.swift
//  GLCircleScrollVeiw
//
//  Created by god、long on 15/7/3.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    //MARK:- System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Circle"
        
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
