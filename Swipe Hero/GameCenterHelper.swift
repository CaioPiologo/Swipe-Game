//
//  GameCenterHelper.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 7/7/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import Foundation
import GameKit

protocol GameCenterHelperProtocol
{
    func didStartAuthentication()
    func finishedAuthenticationWithSuccess()
    func finishedAuthenticationFailed()
    func finishedLoadingScore()
}

class GameCenterHelper: NSObject, GKGameCenterControllerDelegate {
    var gcScore = 0
    var leaderboardIdentifier: String? = nil
    var gameCenterEnabled: Bool = false
    var myViewController: UIViewController!
    var delegate:GameCenterHelperProtocol?
    
    
    init(VC:UIViewController){
        myViewController = VC
    }
    
    
    func openLeaderBoard(id: String) {
        var gameCenter = GKGameCenterViewController()
        gameCenter.gameCenterDelegate = self
        gameCenter.leaderboardIdentifier = id
        self.myViewController.presentViewController(gameCenter, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer()
    {
        if(self.delegate != nil)
        {
            self.delegate!.didStartAuthentication()
        }
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler =
            { (viewController : UIViewController!, error : NSError!) -> Void in
                if viewController != nil
                {
                    self.myViewController.presentViewController(viewController, animated:true, completion: nil)
                }
                else
                {
                    if localPlayer.authenticated
                    {
                        self.gameCenterEnabled = true
                        self.getHighScore()
                        localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler
                            { (leaderboardIdentifier, error) -> Void in
                                if error != nil
                                {
                                    print("error")
                                }
                                else
                                {
                                    self.leaderboardIdentifier = leaderboardIdentifier
                                    println("\(self.leaderboardIdentifier)")
                                }
                        }
                        if(self.delegate != nil)
                        {
                            println(self.gcScore)
                            self.delegate!.finishedAuthenticationWithSuccess()
                        }
                    }
                    else
                    {
                        println("not able to authenticate fail")
                        self.gameCenterEnabled = false
                        
                        if (error != nil)
                        {
                            println("\(error.description)")
                        }
                        else
                        {
                            println(    "error is nil")
                        }
                    }
                }
        }
        
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func saveHighscore(id: String, Score: Int){
        if GKLocalPlayer.localPlayer().authenticated {
            var scoreReporter = GKScore(leaderboardIdentifier: id)
            scoreReporter.value = Int64(Score);
            
            var scores = [scoreReporter]
            
            GKScore.reportScores(scores, withCompletionHandler: { (error : NSError!) -> Void in
                println("reporting")
                if error != nil {
                    println("error")
                    println("\(error.localizedDescription)")
                }else{
                    println("nice score!")
                    
                }
                
            })
        }
    }
    
    func getHighScore(){
        if (GKLocalPlayer.localPlayer().authenticated) {
            let leaderBoardRequest = GKLeaderboard()

            leaderBoardRequest.identifier = "swipe_hero_leaderboards"
            leaderBoardRequest.loadScoresWithCompletionHandler { (scores, error) -> Void in
                if (error != nil) {
                    println("Error: \(error!.description)")
                } else if (scores != nil) {
                    let localPlayerScore = leaderBoardRequest.localPlayerScore
                    self.gcScore = Int(localPlayerScore.value)
                    println("Local player's score: \(localPlayerScore.value)")
                    if(self.delegate != nil){
                        self.delegate!.finishedLoadingScore()
                    }
                }
            }
        } else {
            println("OH NO you didn't connect!")
        }
    }

}