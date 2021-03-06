//
//  CirCleView.swift
//  GLCircleScrollVeiw
//
//  Created by god、long on 15/7/3.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit
import Kingfisher


typealias DownloadProgressBlock = ((_ currentImageIndex: Int, _ receivedSize: Int64, _ totalSize: Int64) -> ())

typealias CompletionHandler = ((_ currentImageIndex: Int, _ image: Image?, _ error: NSError?, _ cacheType: CacheType, _ imageURL: URL?) -> ())

typealias ClickBlock = ((_ currentIndex: Int, _ imageURLString: String?) -> ())



enum IndicatorPostion {
    case left, center, right
}



class CircleView: UIView, UIScrollViewDelegate {
    
    // MARK: - Internal Property
    /// 下载指示器类型，默认为.none：不显示
    var indicatorType: IndicatorType = .none
    /// 下载进度Block
    var downloadProgressBlock: DownloadProgressBlock? = nil
    /// 下载完成Block
    var completionHandler: CompletionHandler? = nil
    /// 是否不缓存图片
    var noCache: Bool = false
    
    /// 缓存周期(秒) - 私有
    private var _cachePeriod: TimeInterval = -1.0
    /// 缓存周期(秒)
    var cachePeriod: TimeInterval {
        get {
            return _cachePeriod
        }
        
        set {
            _cachePeriod = newValue
            let cache = KingfisherManager.shared.cache
            cache.maxCachePeriodInSecond = newValue
        }
    }
    
    /// 占位图名称
    var placeHolderImageName: String? = nil
    /// 点击图片的Block
    var clickBlock: ClickBlock? = nil
    
    //MARK:- Property
    
    private lazy var contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        contentScrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.backgroundColor = .white
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isScrollEnabled = ((self.imageUrlArray?.count)! <= 1)
        self.addSubview(contentScrollView)
        
        return contentScrollView
    }()
    
    private var getImageCount: Int {
        get {
            if let _imageUrlArray = _imageUrlArray {
                return _imageUrlArray.count
            } else {
                return 0
            }
        }
    }
    
//    private var _imageArray: [UIImage]?
//    fileprivate var imageArray: [UIImage]? {
//        get {
//            if let _imageArray = _imageArray {
//                return _imageArray
//            } else {
//                return []
//            }
//        }
//        
//        set(newValue) {
//            _imageArray = newValue
//            contentScrollView.isScrollEnabled = !(newValue?.count == 1)
//            pageIndicator.numberOfPages = (newValue?.count)!
//            
//            if (newValue?.count)! > 1 {
//                self.setScrollViewOfImage()
//            }
//        }
//    }
    
    fileprivate var _imageUrlArray: [String]?
    var imageUrlArray: [String]? {
        get {
            return _imageUrlArray
        }
        
        set(newValue) {
            _imageUrlArray = newValue
            
//            if (_imageArray != nil) && getImageCount > 0 {
//                _imageArray?.removeAll()
//            }
            indexOfCurrentImage = 0
            
//            var tmpImageArray: [UIImage] = []
//            
//            //这里用了强制拆包，所以不要把urlImageArray设为nil
//            for urlStr in newValue! {
//                let dataImage: Data?
//                let tempImage: UIImage?
//                if urlStr.hasPrefix("http://") {
//                    let urlImage = URL(string: urlStr)
//                    if urlImage == nil { break }
//                    dataImage = try? Data(contentsOf: urlImage!)
//                    if dataImage == nil { break }
//                    tempImage = UIImage(data: dataImage!)
//                } else {
//                    tempImage = UIImage(named: urlStr)
//                }
//                
//                if let tempImage = tempImage {
//                    tmpImageArray.append(tempImage)
//                } else {
//                    continue
//                }
//            }
//            
//            imageArray? = tmpImageArray
            
            contentScrollView.isScrollEnabled = !(newValue?.count == 1)
            pageIndicator.numberOfPages = (newValue?.count)!
            
            if (newValue?.count)! > 1 {
                self.setScrollViewOfImage()
            }
        }
    }

    weak var delegate: CircleViewDelegate?
    
    fileprivate var indexOfCurrentImage: Int = 0  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            pageIndicator.currentPage = indexOfCurrentImage
        }
    }
    
    private lazy var currentImageView: UIImageView = {
        let currentImageView = UIImageView()
        currentImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: 200)
        currentImageView.isUserInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.scaleAspectFill
        currentImageView.clipsToBounds = true
        
        return currentImageView
    }()
    
    private lazy var lastImageView: UIImageView = {
        let lastImageView = UIImageView()
        lastImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 200)
        lastImageView.contentMode = UIViewContentMode.scaleAspectFill
        lastImageView.clipsToBounds = true
        
        return lastImageView
    }()

    private lazy var nextImageView: UIImageView = {
        let nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: self.frame.size.width, height: 200)
        nextImageView.contentMode = UIViewContentMode.scaleAspectFill
        nextImageView.clipsToBounds = true
        
        return nextImageView
    }()


    /// 页数指示器
    private var _pageIndicator: UIPageControl?
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
    var pageIndicatorPostion: IndicatorPostion = .center
    
    /// 页面指示器当前页颜色
    var currentPageIndicatorColor: UIColor? = UIColor(white: 0.9, alpha: 0.6)
    
    /// 页面指示器颜色
    var pageIndicatorColor: UIColor? = UIColor(white: 0.4, alpha: 0.4)
    
    
    
    //计时器
    private var _timer: Timer?
    fileprivate var timer: Timer? {
        get {
            if _timer == nil {

                _timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            }
            return _timer
        }
        
        set(newValue) {
            _timer = newValue
        }
    }
    
    // 轮播时间间隔
    private var _timeInterval: Double = 2.5
    var timeInterval: Double {
        get {
            return _timeInterval
        }
        
        set {
            _timeInterval = newValue
            stopAnimation()
            startAnimation()
        }
    }
    
//    var initialPos = CGPoint.zero
//    var dragPos = CGPoint.zero
    
    
    
    //MARK:- Initailizer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, imageUrlArray: [String]?, placeHolderImageName: String?) {
        self.init(frame: frame)

        // 配置Kingfisher图片保存时间为1周
        let cache = KingfisherManager.shared.cache
        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 7
        
        self.imageUrlArray = imageUrlArray
        self.placeHolderImageName = placeHolderImageName
        
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleView()
    }
    
    
    
    // MARK: - Life Cycle
    /// 可用来获取UIView的生命周期，确定UIView是否从superView中移除
    /// 如果被移除，则停止计时器，并做一些收尾工作
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            print("deinit: \(#file)  \(#function)")
            stopAnimation()
            
            let cache = KingfisherManager.shared.cache
            if noCache || cachePeriod == 0.0 {
                cache.clearDiskCache()//清除硬盘缓存
                cache.clearMemoryCache()//清理网络缓存
            } else if !noCache && cachePeriod > 0.0{
                cache.cleanExpiredDiskCache()
            }
        }
    }
    

    
    //MARK:- Privite Methods

    fileprivate func setUpCircleView() {
        contentScrollView.addSubview(lastImageView)
        contentScrollView.addSubview(currentImageView)
        contentScrollView.addSubview(nextImageView)
        self.addSubview(pageIndicator)
        
        // 添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(CircleView.imageTapAction(_:)))
        currentImageView.addGestureRecognizer(imageTap)
//        imageTap.delegate = self
        
        
        // 长按手势，停止计时器
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CircleView.imageLongPressAction(_:)))
//        longPress.delegate = self
//        currentImageView.addGestureRecognizer(longPress)
        
        self.setScrollViewOfImage()
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
    }
    
    fileprivate func setScrollViewOfImage(){
        
        if getImageCount == 1  {
            if let timer = timer, timer.isValid {
                contentScrollView.isScrollEnabled = false
                stopAnimation()
            }
        }
        
        if let _imageUrlArray = _imageUrlArray, _imageUrlArray.count > 0 {
            let placeholderImage: UIImage?
            if let placeHolderImageName = placeHolderImageName {
                placeholderImage = UIImage(named: placeHolderImageName)
            } else {
                placeholderImage = nil
            }
            
            currentImageView.kf.indicatorType = indicatorType
            currentImageView.kf.setImage(with: URL(string: _imageUrlArray[indexOfCurrentImage]), placeholder: placeholderImage, options: [.transition(.fade(0.2))], progressBlock: {
                [weak self] (_ receivedSize: Int64, _ totalSize: Int64) in
                if let downloadProgressBlock = self?.downloadProgressBlock {
                    downloadProgressBlock((self?.indexOfCurrentImage)!,  receivedSize, totalSize)
                }
            }, completionHandler: {
                [weak self] (image, error, cacheType, imageUrl) in
                
                if let completionHandler = self?.completionHandler {
                    completionHandler((self?.indexOfCurrentImage)!, image, error, cacheType, imageUrl)
                }
            })
            
            nextImageView.kf.indicatorType = indicatorType
            nextImageView.kf.setImage(with: URL(string: _imageUrlArray[getNextImageIndex(indexOfCurrentImage: indexOfCurrentImage)]), placeholder: placeholderImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
            
            lastImageView.kf.indicatorType = indicatorType
            lastImageView.kf.setImage(with: URL(string: _imageUrlArray[getLastImageIndex(indexOfCurrentImage: indexOfCurrentImage)]), placeholder: placeholderImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
            
//            currentImageView.image = _imageArray[indexOfCurrentImage]
//            nextImageView.image = _imageArray[getNextImageIndex(indexOfCurrentImage: indexOfCurrentImage)]
//            lastImageView.image = _imageArray[getLastImageIndex(indexOfCurrentImage: indexOfCurrentImage)]
            
            if _imageUrlArray.count > 1 {
                startAnimation()
            }
        }
    }
    
    // 得到上一张图片的下标
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            if let _imageUrlArray = _imageUrlArray {
                return _imageUrlArray.count - 1
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
        return tempIndex < getImageCount ? tempIndex : 0
    }
    
    //事件触发方法
    @objc private func timerAction() {
//        print("timer", terminator: "")
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
//        print(contentScrollView.contentOffset)
    }
    
    @objc fileprivate func imageTapAction(_ tap: UITapGestureRecognizer){
        if let delegate = delegate {
            delegate.clickCurrentImage?(indexOfCurrentImage, imageUrlArray?[indexOfCurrentImage])
            return
        }
        
        if let clickBlock = clickBlock {
            clickBlock(indexOfCurrentImage, imageUrlArray?[indexOfCurrentImage])
            return
        }
    }
    
//    @objc fileprivate func imageLongPressAction(_ longPress: UILongPressGestureRecognizer) {
//        if longPress.state == .began {
////            initialPos = longPress.location(in: contentScrollView)
//            stopAnimation()
//        }
////        else if longPress.state == .changed {
////            let loc = longPress.location(in: contentScrollView)
////            let newPos = CGPoint(x: initialPos.x - loc.x + dragPos.x, y: 0.0)
////            dragPos = newPos
////            contentScrollView.contentOffset = newPos
////        }
//        else if longPress.state == .ended {
//            startAnimation()
//        }
//    }
}


// MARK: - Public Method
extension CircleView {
    func startAnimation() {
        if timer == nil {
            startAnimation()
        } else if !(timer?.isValid)! {
            stopAnimation()
            startAnimation()
        }
    }
    
    func stopAnimation() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}



//MARK:  - UIScrollViewDelegate
extension CircleView {
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAnimation()
    }
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
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
        if (_imageUrlArray?.count)! > 1 {
            startAnimation()
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
}



//// MARK: - UIGestureRecognizerDelegate
//extension CircleView: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if otherGestureRecognizer is UIPanGestureRecognizer {
//            return true
//        }
//        return false
//    }
//}



// MARK:- Protocol Methods
@objc protocol CircleViewDelegate {
    /**
    *  点击图片的代理方法
    *  
    *  @para  currentIndxe 当前点击图片的下标
    */
    @objc optional func clickCurrentImage(_ currentIndex: Int, _ imageUrl: String?)
}










