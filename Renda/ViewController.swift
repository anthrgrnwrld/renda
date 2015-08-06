//
//  ViewController.swift
//  Renda
//
//  Created by Masaki Horimoto on 2015/07/30.
//  Copyright (c) 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var counterDigit: [UILabel]!
    @IBOutlet var decimalPlace: [UILabel]!
    
    var countPushing = 0
    var countupTimer = 0
    var timer = NSTimer()
    var timerState = false
    var startState = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCounter([0,0,0,0])    //カウンタを初期表示にアップデート
        updateTimerLabel(10)        //タイマーの初期表示をアップデート
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonA(sender: AnyObject) {
        
        pressButtonFunc()
        
    }

    @IBAction func buttonB(sender: AnyObject) {

        pressButtonFunc()
        
    }

    
    /**
    ボタンA及びBを押した時に実行する関数
    */
    func pressButtonFunc() {

        //println("\(__FUNCTION__) is called")

        //timerStateがfalseの時にはTimerをスタート。trueの時には無視する。
        if timerState == false && startState {
            timerState = true
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        }
        
        if timerState && startState {
            
            countPushing++  //countPushingをインクリメント
            
            let countAfterEdit = editCount(countPushing, digitNum: counterDigit.count)  //カウントを表示用にEdit
            updateCounter(countAfterEdit)   //カウンタをアップデートする
            
        }

        
    }
    
    /**
    表示用にカウント数を10進数の桁毎に数値を分割する。表示桁数を超えた場合にはゼロに戻す。
    digiNum >= count となるようにして使用のこと。
    
    :param: count:カウント数
    :param: digitNum:変換する桁数
    :returns: digitArray:変換結果を入れる配列
    */
    func editCount(var count :Int, digitNum :Int) -> [Int] {
 
        var digitArray = [Int]()
        
        for index in 0 ... (digitNum) {
            let tmpDec = pow(10.0, Double(digitNum - index))
            if index != 0 {digitArray.append(count / Int(tmpDec))}
            count = count % Int(tmpDec)
        }
    
        return digitArray
    }
    
    /**
    カウンタの表示LabelをUpdateする。
    countArrayの要素数 = counterDigitの要素数となるよう使用のこと。
    
    :param: countArray:配列に編集済みのカウント配列*要editCount
    */
    func updateCounter(countArray :[Int]) {
        
        if countArray.count == counterDigit.count {
            
            for index in 0 ... (countArray.count - 1) {counterDigit[index].text = "\(countArray[index])"}
            
        } else {
            for index in 0 ... (countArray.count - 1) {counterDigit[index].text = "E"}
            println("Error")
        }
        
    }

    /**
    タイマー関数。1秒毎に呼び出される。
    */
    func updateTimer() {
        println("\(__FUNCTION__) is called")

        countupTimer++                                      //countupTimerをインクリメント
        let countdownTimer = editTimerCount(countupTimer)   //カウントアップ表記をカウントダウン表記へ変換
        updateTimerLabel(countdownTimer)                    //タイマー表示ラベルをアップデート
        
        if countdownTimer <= 0 {
            timerState = false
            startState = false
            countupTimer = 0
            timer.invalidate()
        }
        
        println("\(countupTimer)")
    }

    /**
    カウントアップタイマーを1カウントダウン表記(Start 10)に変更する。
    timerCount > 10 の場合には0をReturnする
    
    :param: timerCount:カウントアップタイマ値
    :returns: digitArray:カウントダウンタイマ値(Start 10)
    */
    func editTimerCount(timerCount: Int) -> Int {
        
        var timerCountAfterEdit: Int?
        
        if 10 >= timerCount {
            timerCountAfterEdit = 10 - timerCount
        } else {
            timerCountAfterEdit = 0
        }
        
        return timerCountAfterEdit!
        
    }
    
    /**
    タイマーの表示LabelをUpdateする。
    
    :param: countArray:配列に編集済みのカウント配列*要editCount
    */
    func updateTimerLabel(timerCount: Int) {
        
        decimalPlace[0].text = "\(timerCount/10)"
        decimalPlace[1].text = "\(timerCount%10)"
        
    }
   
    
    

}

