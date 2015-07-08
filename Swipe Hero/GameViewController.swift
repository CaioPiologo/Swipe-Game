//
//  GameViewController.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

protocol GameCenterHelperProtocol
{
    func didStartAuthentication()
    func finishedAuthenticationWithSuccess()
    func finishedAuthenticationFailed()
    func finishedLoadingScore()
}

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var gcScore = 0
    var leaderboardIdentifier: String? = nil
    var gameCenterEnabled: Bool = false
    var delegate:GameCenterHelperProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill

            authenticateLocalPlayer()
            
            skView.presentScene(scene)

        }
    }
  
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //initiate gamecenter
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
                    self.presentViewController(viewController, animated:true, completion: nil)
                }
                else
                {
                    if localPlayer.authenticated
                    {
                        self.gameCenterEnabled = true
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
                    println("Local player's score: \(self.gcScore)")
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
