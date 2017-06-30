//
//  CirCleView.swift
//  GLCircleScrollVeiw
//
//  Created by god、long on 15/7/3.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit

enum IndicatorPostion {
    case left, center, right
}

class CircleView: UIView, UIScrollViewDelegate {
    //MARK:- Property
    lazy var contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        contentScrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.backgroundColor = .green
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isScrollEnabled = ((self.imageUrlArray?.count)! <= 1)
        self.addSubview(contentScrollView)
        
        return contentScrollView
    }()
    
    
    var _imageArray: [UIImage]?
    fileprivate var imageArray: [UIImage]? {
        get {
            if let _imageArray = _imageArray {
                return _imageArray
            } else {
                return []
            }
        }
        
        set(newValue) {
            _imageArray = newValue
            contentScrollView.isScrollEnabled = !(newValue?.count == 1)
            pageIndicator.numberOfPages = (newValue?.count)!
            
            if (newValue?.count)! > 1 {
                self.setScrollViewOfImage()
            }
        }
    }
    
    var _imageUrlArray: [String]?
    var imageUrlArray: [String]? {
        get {
            return _imageUrlArray
        }
        
        set(newValue) {
            _imageUrlArray = newValue
            
            if (_imageArray != nil) && (_imageArray?.count)! > 0 {
                _imageArray?.removeAll()
            }
            indexOfCurrentImage = 0
            
            var tmpImageArray: [UIImage] = []
            
            //这里用了强制拆包，所以不要把urlImageArray设为nil
            for urlStr in newValue! {
                let dataImage: Data?
                let tempImage: UIImage?
                if urlStr.hasPrefix("http://") {
                    let urlImage = URL(string: urlStr)
                    if urlImage == nil { break }
                    dataImage = try? Data(contentsOf: urlImage!)
                    if dataImage == nil { break }
                    tempImage = UIImage(data: dataImage!)
                } else {
                    tempImage = UIImage(named: urlStr)
                }
                
                if let tempImage = tempImage {
                    tmpImageArray.append(tempImage)
                } else {
                    continue
                }
            }
            
            imageArray? = tmpImageArray
        }
    }

    var delegate: CircleViewDelegate?
    
    var indexOfCurrentImage: Int!  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            pageIndicator.currentPage = indexOfCurrentImage
        }
    }
    
    lazy var currentImageView: UIImageView = {
        let currentImageView = UIImageView()
        currentImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: 200)
        currentImageView.isUserInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.scaleAspectFill
        currentImageView.clipsToBounds = true
        
        return currentImageView
    }()
    
    lazy var lastImageView: UIImageView = {
        let lastImageView = UIImageView()
        lastImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 200)
        lastImageView.contentMode = UIViewContentMode.scaleAspectFill
        lastImageView.clipsToBounds = true
        
        return lastImageView
    }()

    lazy var nextImageView: UIImageView = {
        let nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: self.frame.size.width, height: 200)
        nextImageView.contentMode = UIViewContentMode.scaleAspectFill
        nextImageView.clipsToBounds = true
        
        return nextImageView
    }()


    /// 页数指示器
    var _pageIndicator: UIPageControl?
    var pageIndicator: UIPageControl {
        get {
            if _pageIndicator == nil {
                var pageIndicatorX: CGFloat
                switch pageIndicatorPostion {
                    case .left:
                        pageIndicatorX = 0.0
                    case .center:
                        pageIndicatorX = (self.frame.size.width - 20 * CGFloat((imageUrlArray?.count)!)) / 2
                    case .right:
                        pageIndicatorX = self.frame.size.width - 20 * CGFloat((imageUrlArray?.count)!)
                }
            
                _pageIndicator = UIPageControl(frame: CGRect(x: pageIndicatorX, y: self.frame.size.height - 30, width: 20 * CGFloat((imageUrlArray?.count)!), height: 20))
                _pageIndicator?.hidesForSinglePage = true
                _pageIndicator?.numberOfPages = (imageUrlArray?.count)!
                
                _pageIndicator?.currentPageIndicatorTintColor = currentPageIndicatorColor
                _pageIndicator?.pageIndicatorTintColor = pageIndicatorColor
                _pageIndicator?.backgroundColor = UIColor.clear
            }
            return _pageIndicator!
        }
        
        set(newValue) {
            _pageIndicator = newValue
        }
    }
    
    /// 页面指示器显示位置
    public var pageIndicatorPostion: IndicatorPostion = .center
    
    /// 页面指示器当前页颜色
    public var currentPageIndicatorColor: UIColor? = UIColor(white: 0.9, alpha: 0.6)
    
    /// 页面指示器颜色
    public var pageIndicatorColor: UIColor? = UIColor(white: 0.4, alpha: 0.4)
    
    
    
    //计时器
    var _timer: Timer?
    var timer: Timer? {
        get {
            if _timer == nil {
//                _timer = Timer(timeInterval: TimeInterval, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)
//                RunLoop.current.add(_timer!, forMode: .commonModes)
                
                _timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CircleView.timerAction), userInfo: nil, repeats: true)
//                _timer?.fire()
            }
            return _timer
        }
        
        set(newValue) {
            _timer = newValue
        }
    }
    
    // 轮播时间间隔
    private var _timeInterval: Double = 2.5
    public var timeInterval: Double {
        get {
            return _timeInterval
        }
        
        set {
            _timeInterval = newValue
            stopAnimation()
            startAnimation()
        }
    }
    
    
    
    //MARK:- Initailizer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    convenience init(frame: CGRect, imageArray: [UIImage?]?) {
//        self.init(frame: frame)
//        self.imageArray = imageArray
//
//        // 默认显示第一张图片
//        self.indexOfCurrentImage = 0
//        self.setUpCircleView()
//    }
    
    convenience init(frame: CGRect, imageUrlArray: [String]?) {
        self.init(frame: frame)

        self.imageUrlArray = imageUrlArray
        
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleView()
    }
    
    deinit {
        stopAnimation()
    }
    

    
    //MARK:- Privite Methods
    fileprivate func setUpCircleView() {
        contentScrollView.addSubview(lastImageView)
        contentScrollView.addSubview(currentImageView)
        contentScrollView.addSubview(nextImageView)
        self.addSubview(pageIndicator)
        
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(CircleView.imageTapAction(_:)))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.setScrollViewOfImage()
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
    }
    
    func setScrollViewOfImage(){
        
        if _imageArray?.count == 1  {
            if let timer = timer, timer.isValid {
                contentScrollView.isScrollEnabled = false
                stopAnimation()
            }
        } else {
            // 设置计时器
//            if let timer = timer, !timer.isValid, (_imageArray?.count)! > 1 {
//                timer.fire()
//            }
        }
        
        if let _imageArray = _imageArray, _imageArray.count > 0 {
            currentImageView.image = _imageArray[indexOfCurrentImage]
            nextImageView.image = _imageArray[getNextImageIndex(indexOfCurrentImage: indexOfCurrentImage)]
            lastImageView.image = _imageArray[getLastImageIndex(indexOfCurrentImage: indexOfCurrentImage)]
            
            if _imageArray.count > 1 {
                startAnimation()
            }
        }
    }
    
    // 得到上一张图片的下标
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            if let _imageArray = _imageArray {
                return _imageArray.count - 1
            } else {
                return 0
            }
            
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    fileprivate func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < (_imageArray?.count)! ? tempIndex : 0
    }
    
    //事件触发方法
    func timerAction() {
//        print("timer", terminator: "")
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
//        print(contentScrollView.contentOffset)
    }
}


// MARK: - Public Method
extension CircleView {
    public func startAnimation() {
        if timer == nil {
            startAnimation()
        } else if !(timer?.isValid)! {
            stopAnimation()
            startAnimation()
        }
    }
    
    public func stopAnimation() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    func imageTapAction(_ tap: UITapGestureRecognizer){
        self.delegate?.clickCurrentImage!(indexOfCurrentImage)
    }
}



//MARK:  - UIScrollViewDelegate
extension CircleView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAnimation()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        } else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        // 当轮播图数量大于1时才启动定时器
        if (self.imageArray?.count)! > 1 {
            startAnimation()
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //        print("animator", terminator: "")
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
}


// MARK:- Protocol Methods
@objc protocol CircleViewDelegate {
    /**
    *  点击图片的代理方法
    *  
    *  @para  currentIndxe 当前点击图片的下标
    */
    @objc optional func clickCurrentImage(_ currentIndxe: Int)
}










