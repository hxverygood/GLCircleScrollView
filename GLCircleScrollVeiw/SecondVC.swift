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
        
//        let imageUrlArray = ["first.jpg", "second.jpg", "third.jpg"]
        
//        let imageUrlArray = ["http://113.200.105.34:8081/image/banner/f13eabc2-6974-444f-9fe8-f573e72cb5f2.jpg",
//                             "http://113.200.105.34:8081/image/banner/582cf2b4-9095-44c4-b08a-acc1dc036206.svg",
//                             "http://113.200.105.34:8081/image/banner/d6119a6b-8968-4256-9138-7e322ab83c6b.jpg"]
//
        
        let imageUrlArray = ["https://i0.wp.com/picjumbo.com/wp-content/uploads/DSC06760.jpg",
                             "https://i0.wp.com/picjumbo.com/wp-content/uploads/HNCK3218.jpg",
                             "https://i0.wp.com/picjumbo.com/wp-content/uploads/HNCK5108.jpg"]
        
//        let imageUrlArray = ["",
//                             "https://i0.wp.com/picjumbo.com/wp-content/uploads/HNCK3218.jpg",
//                             "https://i0.wp.com/picjumbo.com/wp-content/uploads/HNCK5108.jpg"]
        
//        let imageUrlArray = ["http://desk.fd.zol-img.com.cn/t_s1280x1024c5/g5/M00/04/02/ChMkJljcnkeIE45pACnWCEyzAOEAAbMrANmMw0AKdYg418.jpg",
//                             "http://desk.fd.zol-img.com.cn/t_s1280x800c5/g5/M00/01/03/ChMkJllAmgeIccqsAEpQOqPnoEcAAdAbwJXbzwASlBS965.jpg",
//                             "http://desk.fd.zol-img.com.cn/t_s1280x800c5/g5/M00/09/01/ChMkJ1jq7sOIfZrIABH47H14SrgAAbgdgKliXQAEfkE592.jpg"]
        
        circleView = CircleView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 200), imageUrlArray: imageUrlArray, placeHolderImageName: "first.jpg")
        circleView.timeInterval = 2.0
        circleView.indicatorType = .activity
        circleView.noCache = true
        circleView.cachePeriod = 1.0
//        circleView.delegate = self
        circleView.downloadProgressBlock = { (currentImageIndex: Int, receivedSize: Int64, totalSize: Int64) -> () in
            print("已下载图片\(currentImageIndex): \(Double(receivedSize)/Double(totalSize)*100)%")
        }
        circleView.completionHandler = { (currentImageIndex, image, error, cacheType, imageURL) -> () in
            if error == nil {
                print("图片\(currentImageIndex)下载完成")
            }
        }
        
        circleView.clickBlock = { (currentIndex, imageURLString) -> () in
            print("\(currentIndex)" + ": " + "\(imageURLString ?? "")");
        }
        
        
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
    
//    func clickCurrentImage(_ currentIndex: Int, _ imageUrl: String?) {
//        print("\(currentIndex)" + ": " + "\(imageUrl ?? "")");
//    }

    
    
    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
