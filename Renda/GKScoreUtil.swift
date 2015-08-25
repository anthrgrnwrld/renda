//
//  GKScoreUtil.swift
//  Renda
//
//  Created by Masaki Horimoto on 2015/08/17.
//  Copyright (c) 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit
import GameKit

struct GKScoreUtil {
    
    static func reportScores(value:Int, leaderboardid:String){
        println("\(__FUNCTION__) is called")
        
        var score:GKScore = GKScore();
        score.value = Int64(value);
        score.leaderboardIdentifier = leaderboardid;
        var scoreArr:[GKScore] = [score];
        
        GKScore.reportScores(scoreArr, withCompletionHandler:{(error:NSError!) -> Void in
            if( (error != nil)){
                println("reportScore NG");
            }else{
                println("reportScore OK");
            }
        });
        
    }
}
