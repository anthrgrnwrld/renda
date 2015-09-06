//
//  KosuriGestureRecognizer.swift
//  Renda
//
//  Created by Masaki Horimoto on 2015/09/02.
//  Copyright (c) 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit


/**
2つのViewにおいて、PanにてView範囲に入った時に、closureで指定された動作を行う。
使用例:コスリ機能

:param: _targetViewA:対象となるView(1つ目)
:param: _targetViewB:対象となるView(2つ目)
:param: 対象となるView範囲に入った時に実行する動作
*/
class KosuriGestureRecognizer : NSObject {
    let pan = UIPanGestureRecognizer()
    
    var targetViewA:UIView? = nil   //targetViewAとtargetViewBは同じsuperviewを持っていること
    var targetViewB:UIView? = nil   //targetViewAとtargetViewBは同じsuperviewを持っていること
    var didPush:(()->Void)? = nil
    
    var inFlagA = false
    var inFlagB = false
    
    init(_targetViewA:UIView, _targetViewB:UIView, didPush:()->Void) {
        super.init()
        
        self.targetViewA = _targetViewA
        self.targetViewB = _targetViewB
        self.didPush = didPush
        
        pan.addTarget(self, action: Selector("didPan:"))
        _targetViewA.superview?.addGestureRecognizer(self.pan)
    }
    
    func didPan(sender:AnyObject) {
        if let pan = sender as? UIPanGestureRecognizer,
            targetViewA = self.targetViewA,
            targetViewB = self.targetViewB,
            outView = targetViewA.superview,
            didPush = self.didPush
        {
            let p = pan.locationInView(outView) //outViewはViewControllerでいうところのself.view
            if !inFlagA && targetViewA.frame.contains(p) {
                inFlagA = true
                didPush()
            } else if inFlagA && !targetViewA.frame.contains(p) {
                inFlagA = false
            } else if !inFlagB && targetViewB.frame.contains(p) {
                inFlagB = true
                didPush()
            } else if inFlagB && !targetViewB.frame.contains(p) {
                inFlagB = false
            }
        }
    }
}

