//
//  NextGrowingTextView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/18.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//


import UIKit

public class NextGrowingTextView: UIScrollView, UITextViewDelegate {
    
    public override init(frame: CGRect) {
        
        let textViewFrame = CGRect(origin: CGPoint.zero, size: frame.size)
        let textView = UITextView(frame: textViewFrame)
        self.textView = textView
        
        // 伸縮の最小幅を指定
        self.minHeight = frame.height
        
        // 伸縮の最大幅を指定
        self.maxHeight = 50
        
        super.init(frame: frame)
        
        self.textView.delegate = self
        
        // UITextViewのスクロールはOffに
        self.textView.scrollEnabled = false
        self.addSubview(textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var minHeight: CGFloat
    public var maxHeight: CGFloat
    
    public func textViewDidChange(textView: UITextView) {
        // テキストの変更を受け取り、サイズを合わせる
        self.fitToScrollView() // こちらのコードは下に貼ります。
    }
    
    private let textView: UITextView
    private func measureTextViewSize() -> CGSize {
        // 文字が全て表示されるサイズを取得
        return textView.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat.infinity))
    }
    
    private func measureFrame(contentSize: CGSize) -> CGRect {
        
        // NextGrowingTextViewの伸縮の限界値に応じたFrameを計算
        let selfSize: CGSize
        
        if contentSize.height < self.minHeight || !self.textView.hasText() {
            selfSize = CGSize(width: contentSize.width, height: self.minHeight)
        } else if self.maxHeight > 0 && contentSize.height > self.maxHeight {
            selfSize = CGSize(width: contentSize.width, height: self.maxHeight)
        } else {
            selfSize = contentSize
        }
        
        var frame = self.frame
        frame.size.height = selfSize.height
        return frame
    }
    
    public override func intrinsicContentSize() -> CGSize {
        // Autolayoutへ対応
        // 初期化時とinvalidateIntrinsicContentSizeが呼ばれたタイミングで実行されます。
        return self.measureFrame(self.measureTextViewSize()).size
    }
    private func fitToScrollView() {
        
        // 改行された時に下にスクロールを行うか判定
        let scrollToBottom = self.contentOffset.y == self.contentSize.height - self.frame.height
        
        // 全ての文字表示に必要なサイズを取得
        let actualTextViewSize = self.measureTextViewSize()
        let oldScrollViewFrame = self.frame
        
        var frame = self.bounds
        frame.origin = CGPoint.zero
        frame.size.height = actualTextViewSize.height
        // UITextViewのサイズを全ての文字が表示される大きさに変更する
        self.textView.frame = frame
        // UITextViewのサイズと自身のContentSizeを同じにする
        self.contentSize = frame.size
        
        let newScrollViewFrame = self.measureFrame(actualTextViewSize)
        
        self.frame = newScrollViewFrame
        
        if scrollToBottom {
            self.scrollToBottom()
        }
        
        // Autolayoutへ対応
        // 自分自身のサイズが変わったことをSuperviewに伝えます。
        self.invalidateIntrinsicContentSize()
    }
    
    private func scrollToBottom() {
        let offset = self.contentOffset
        self.contentOffset = CGPoint(x: offset.x, y: self.contentSize.height - self.frame.height)
    }
}
