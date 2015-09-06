//
//  ViewController.swift
//  Renda
//
//  Created by Masaki Horimoto on 2015/07/30.
//  Copyright (c) 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate, GADBannerViewDelegate {
    
    @IBOutlet var counterDigit: [UILabel]!
    @IBOutlet var decimalPlace: [UILabel]!
    @IBOutlet weak var positionBeeMostLeft: UIView!
    @IBOutlet weak var positionBeeMostRight: UIView!
    @IBOutlet weak var imageBee: UIImageView!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    
    let YOUR_ID = "ca-app-pub-3530000000000000/0123456789"  // Enter Ad's ID here
    let TEST_DEVICE_ID = "61b0154xxxxxxxxxxxxxxxxxxxxxxxe0" // Enter Test ID here
    let AdMobTest:Bool = true
    let SimulatorTest:Bool = true
    
    var countPushing = 0
    var countupTimer = 0
    var timer = NSTimer()
    let ud = NSUserDefaults.standardUserDefaults()
    var timerState = false  //timerStateがfalseの時にはTimerをスタート。trueの時には無視する。
    var startState = false  //startStateがtrueの時にはゲーム開始できる
    var highScore = 0
    let udKey = "HIGHSCORE"
    let leaderboardid = "renda.highscore"
    var kosuri:KosuriGestureRecognizer? = nil   //コスリクラスのインスタンス
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScore = ud.integerForKey(udKey)     //保存済みのハイスコアを取得
        println("highScore is \(highScore)")
        
        let tmpNum = counterDigit != nil ? counterDigit.count : 0
        
        let highScoreAfterEdit = editCount(highScore, digitNum: tmpNum)
        updateCounter(highScoreAfterEdit)       //カウンタを初期表示にアップデート
        updateTimerLabel(0)                     //タイマーの初期表示をアップデート
        
        let bannerView:GADBannerView = getAdBannerView()
        self.view.addSubview(bannerView)
        
        self.kosuri = KosuriGestureRecognizer(_targetViewA: self.buttonA, _targetViewB: self.buttonB, didPush: {
            self.pressButtonFunc()
        })
        
    }
    
    private func getAdBannerView() -> GADBannerView {
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
        bannerView.frame.origin = CGPointMake(0, 20)
        bannerView.frame.size = CGSizeMake(self.view.frame.width, bannerView.frame.height)
        bannerView.adUnitID = "\(YOUR_ID)"
        bannerView.delegate = self
        bannerView.rootViewController = self
        
        var request:GADRequest = GADRequest()
        
        if AdMobTest {
            if SimulatorTest {
                request.testDevices = [kGADSimulatorID]
            } else {
                request.testDevices = [TEST_DEVICE_ID]
            }
        }
        
        bannerView.loadRequest(request)
        
        return bannerView
    }
    
    func adViewDidReceiveAd(adView: GADBannerView){
        println("adViewDidReceiveAd:\(adView)")
    }
    func adView(adView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        println("error:\(error)")
    }
    func adViewWillPresentScreen(adView: GADBannerView){
        println("adViewWillPresentScreen")
    }
    func adViewWillDismissScreen(adView: GADBannerView){
        println("adViewWillDismissScreen")
    }
    func adViewDidDismissScreen(adView: GADBannerView){
        println("adViewDidDismissScreen")
    }
    func adViewWillLeaveApplication(adView: GADBannerView){
        println("adViewWillLeaveApplication")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    Startボタンを押した時に実行する関数
    */
    @IBAction func buttonStart(sender: AnyObject) {
        
        if startState != false {    //starStateがtrueの時には処理を終了
            return
        }
        
        startState = true           //startStateがtrueにし、Gameが開始できる状態にする
        countPushing = 0
        countupTimer = 0
        updateCounter([0,0,0,0])    //カウンタを初期表示にアップデート
        updateTimerLabel(10)        //タイマーの初期表示をアップデート
        imageBee.center = positionBeeMostRight.center   //imageBeeの表示位置を初期値に戻す

        //Viewの点滅を終了する。
        finishBlinkAnimationWithView(imageBee)
        for (index, view) in enumerate(self.counterDigit) {
            finishBlinkAnimationWithView(view)
        }
        
    }

    /**
    Aボタンを押した時に実行する関数
    */
    @IBAction func pressButtonA(sender: AnyObject) {
        
        pressButtonFunc()
        
    }

    /**
    Bボタンを押した時に実行する関数
    */
    @IBAction func pressButtonB(sender: AnyObject) {

        pressButtonFunc()
        
    }

    
    /**
    Aボタン及びBボタンを押した時に実行する関数
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
 
            let tmpNum = counterDigit != nil ? counterDigit.count : 0
            
            let countAfterEdit = editCount(countPushing, digitNum: tmpNum)  //カウントを表示用にEdit
            updateCounter(countAfterEdit)   //カウンタをアップデートする
            moveImageBeeWithCountPushing(countPushing)  //imageBeeの表示位置をアップデートする
            
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
        
        if counterDigit != nil && countArray.count == counterDigit.count {
            
            for index in 0 ... (countArray.count - 1) {counterDigit[index].text = "\(countArray[index])"}
            
        } else if counterDigit != nil && countArray.count != counterDigit.count {
            
            for index in 0 ... (countArray.count - 1) {counterDigit[index].text = "E"}
            println("Error")
            
        } else {    //counterDigit == nil
            
            //Do nothing
            
        }
        
    }
    
    /**
    タイマー関数。1秒毎に呼び出される。
    */
    func updateTimer() {
        //println("\(__FUNCTION__) is called")
        
        countupTimer++                                      //countupTimerをインクリメント
        let countdownTimer = editTimerCount(countupTimer)   //カウントアップ表記をカウントダウン表記へ変換
        updateTimerLabel(countdownTimer)                    //タイマー表示ラベルをアップデート
        
        if countdownTimer <= 0 {timeupFunc()}               //ゲーム開始より10秒経過後、ゲーム完了処理を実行
        
        println("\(__FUNCTION__) is called! \(countupTimer)")
    }
    
    /**
    ゲーム完了時に実行する関数。
    */
    func timeupFunc() {

        let highScoreFlag = countPushing > highScore ? true : false
        highScore = countPushing > highScore ? countPushing : highScore
        timerState = false
        startState = false
        timer.invalidate()
        println("highScore is \(highScore)")
        ud.setInteger(highScore, forKey: udKey)     //ハイスコアをNSUserDefaultsのインスタンスに保存
        ud.synchronize()                            //保存する情報の反映
        GKScoreUtil.reportScores(highScore, leaderboardid: leaderboardid)   //GameCenter Score Transration
        
        //ハイスコア更新の場合にはimageBeeとカウンタ表示を点滅させる
        if highScoreFlag {
            blinkAnimationWithView(imageBee)
            for (index, view) in enumerate(self.counterDigit) {
                blinkAnimationWithView(view)
            }
        }
        
        

    }
 
    /**
    指定されたViewを1秒間隔で点滅させる
    
    :param: view:点滅させるView
    */
    func blinkAnimationWithView(view :UIView) {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.Repeat, animations: { () -> Void in
            view.alpha = 0.0
            }, completion: nil)
    }
    
    /**
    指定されたViewの点滅アニメーションを終了する
    
    :param: view:点滅を終了するView
    */
    func finishBlinkAnimationWithView(view :UIView) {
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.animateWithDuration(0.001, animations: {
            view.alpha = 1.0
        })
    }
    
    /**
    カウントアップタイマーを1カウントダウン表記(Start 10)に変更する。
    timerCount > 10 の場合には0をReturnする
    
    :param: timerCount:カウントアップタイマ値
    :returns: digitArray:カウントダウンタイマ値(Start 10)
    */
    func editTimerCount(timerCount: Int) -> Int {
        
        var timerCountAfterEdit: Int?
        
        if 10 >= timerCount {timerCountAfterEdit = 10 - timerCount}
        else {timerCountAfterEdit = 0}
        
        return timerCountAfterEdit!
        
    }
    
    /**
    タイマーの表示LabelをUpdateする。
    
    :param: countArray:配列に編集済みのカウント配列*要editCount
    */
    func updateTimerLabel(timerCount: Int) {
 
        if decimalPlace != nil {

            decimalPlace[0].text = "\(timerCount/10)"
            decimalPlace[1].text = "\(timerCount%10)"

        }
        
    }

    /**
    GameCenterボタンを押した時に実行する関数
    */
    @IBAction func pressGameCenter(sender: AnyObject) {
        showLeaderboardScore()
    }
    
    /**
    GKScoreにてスコアが送信されたデータスコアをLeaderboardで確認する
    */
    func showLeaderboardScore() {
        var localPlayer = GKLocalPlayer()
        localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier : String!, error : NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                let gameCenterController:GKGameCenterViewController = GKGameCenterViewController()
                gameCenterController.gameCenterDelegate = self  //このViewControllerにはGameCenterControllerDelegateが実装されている必要があります
                gameCenterController.viewState = GKGameCenterViewControllerState.Leaderboards
                gameCenterController.leaderboardIdentifier = self.leaderboardid //該当するLeaderboardのIDを指定します
                self.presentViewController(gameCenterController, animated: true, completion: nil);
            }
        })
        
    }
    
    /**
    Leaderboardを"DONE"押下後にCloseする
    */
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        println("\(__FUNCTION__) is called")
        //code to dismiss your gameCenterViewController
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil);
    }
    
    /**
    imageBeeの表示位置を変更する。
    
    :param: countPushing:Pushカウント数
    */
    func moveImageBeeWithCountPushing(countPushing: Int) {
        println("countPushing is \(countPushing)")
        
        let deltaXperOnePushing = (positionBeeMostRight.center.x - positionBeeMostLeft.center.x)/100    //1Push当たりのx移動量
        if (countPushing - 1) % 100 == 0 {imageBee.center.x = positionBeeMostRight.center.x}            //100回毎にpositionBeeMostLeftに位置を戻す
        imageBee.center.x -= deltaXperOnePushing                                                        //imageBeeの表示位置を移動する
        
    }

    

}

