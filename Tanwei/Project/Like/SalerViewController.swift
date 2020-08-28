//
//  SalerViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/17.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class SalerViewController: KWBaseViewController {
    
    let scrollView = UIScrollView()
    let titleView = UIView()
    var previousClickedTitleButton = DiscoverTitleButton()
    let titleUnderline = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加子控制器
        self.setupChildViewController()
        
        //添加ScrollView
        self.addScrollView()
        
        //创建标题栏按钮
        self.setupTitleButton()
        
        //添加第0个自控制器
        self.addChildVcViewIntoScrollView(index: 0)
        
    }
}


// MARK: - 设置标题栏按钮
extension SalerViewController{
    
    //设置标题按钮
    func setupTitleButton(){
        
        titleView.frame                = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        titleView.backgroundColor = .white
        self.view.addSubview(titleView)
        let titles:NSArray             = ["我的关注","我的粉丝"]
        let count                      = titles.count
        
        for i in 0 ..< count {
            let titleButton            = DiscoverTitleButton()
            titleButton.tag            = i
            titleButton.setTitle(titles[i]as?String, for: .normal)
            titleButton.addTarget(self, action: #selector(titleButtonClick(titleButton:)), for: .touchUpInside)
            titleButton.frame          = CGRect(x: SCREEN_WIDTH*0.5 * CGFloat(i), y: 6, width: SCREEN_WIDTH*0.5, height: 44)
            titleView.addSubview(titleButton)
        }
        let line = UIView(frame: CGRect(x: 0, y: 49.5, width: screenWidth, height: 0.5))
        line.backgroundColor = .lightGray
        self.titleView.addSubview(line)
        setupTitleUnderline()
    }
    
    //设置下划线
    func setupTitleUnderline(){
        
        let firstTitleButton: DiscoverTitleButton = titleView.subviews.first as! DiscoverTitleButton
        
        let titleUnderlineH:CGFloat       = 3
        let titleUnderlineY:CGFloat       = 47
        titleUnderline.frame = CGRect(x: 0, y: titleUnderlineY, width: 0, height: titleUnderlineH)
        titleUnderline.backgroundColor    = APPSubjectColor
        titleUnderline.layer.cornerRadius = titleUnderline.frame.size.height*0.5
        titleUnderline.clipsToBounds      = true
        titleView.addSubview(titleUnderline)
        
        //新点击的按钮 -->黑色
        firstTitleButton.isSelected       = true
        previousClickedTitleButton        = firstTitleButton
        //下划线
        firstTitleButton.titleLabel?.sizeToFit()//???????
        titleUnderline.frame.size.width   = (firstTitleButton.titleLabel?.frame.size.width)!
        titleUnderline.center.x           = firstTitleButton.center.x
    }
}

// MARK: - 设置ScrollView
extension SalerViewController:UIScrollViewDelegate {
    
    func addScrollView(){
        let count : NSInteger  = self.children.count
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate    = self
        scrollView.frame       = view.bounds
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        
        //设置ScrollView的范围
        scrollView.contentSize     = CGSize(width: scrollView.frame.size.width * CGFloat(count), height: 0)
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {//减速
        
        let index = NSInteger(scrollView.contentOffset.x / scrollView.frame.size.width);
        let titleButton:DiscoverTitleButton = self.titleView.subviews[index] as! DiscoverTitleButton
        // 如果上一次点击的按钮 和 这次想要点击的按钮 相同，直接返回
        if self.previousClickedTitleButton == titleButton {return;}
        titleButtonClick(titleButton: titleButton)
    }
}

// MARK: - 添加子控制器
extension SalerViewController{
    func setupChildViewController(){
        self.addChild(MyFocusSalerTableViewController())
        self.addChild(MySalerFansTableViewController())
    }
}

// MARK: - 监听titleButton的点击
extension SalerViewController{
    
    @objc func titleButtonClick(titleButton:DiscoverTitleButton) {
        previousClickedTitleButton.isSelected = false
        titleButton.isSelected     = true
        previousClickedTitleButton = titleButton
        
        let index:NSInteger = titleButton.tag
        
        UIView.animate(withDuration: 0.25, animations: {
            //下划线的移动
            self.titleUnderline.frame.size.width = (titleButton.titleLabel?.frame.size.width)!
            self.titleUnderline.center.x = titleButton.center.x
            
            // 滑动scrollView到对应的子控制器界面
            var offset : CGPoint = self.scrollView.contentOffset
            offset.x = CGFloat(index) * self.scrollView.frame.size.width;
            
            self.scrollView.contentOffset = offset
            
        }) { (finished:Bool) in
            self.addChildVcViewIntoScrollView(index: index)
        }
    }
}

// MARK: - 添加index位置的自控制器到iew的ScrollView中
extension SalerViewController {
    
    func addChildVcViewIntoScrollView(index:NSInteger){
        
        // 取出index位置对应的子控制器
        let childVc: UIViewController = self.children[index]
        childVc.view.frame = CGRect(x:SCREEN_WIDTH*CGFloat(index), y: NavHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TabHeight-NavHeight)
        //SCREENWIDTH*0.1306
        self.scrollView.addSubview(childVc.view)
        
    }
}
