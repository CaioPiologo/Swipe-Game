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

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var gcScore = 0
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
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

           // authenticateLocalPlayer()
            
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
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController : UIViewController!, error : NSError!) -> Void in
            if ((viewController) != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            }else if (GKLocalPlayer.localPlayer().authenticated) {
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer
                    }
                })
                
                self.getHighScore()
            } else {
                
                println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    
    //send high score to leaderboard
    func saveHighscore(highScore: Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "swipe_hero_leaderboards", player: GKLocalPlayer.localPlayer())
            
            scoreReporter.value = Int64(highScore)
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                } else {
                    println("score submitted")
                }
            })
            
        }
        
    }
    
    // gets player highScore
    func getHighScore(){
        if (gcEnabled == true) {
            let leaderBoardRequest = GKLeaderboard()
            
            leaderBoardRequest.identifier = "swipe_hero_leaderboards"
            leaderBoardRequest.loadScoresWithCompletionHandler { (scores, error) -> Void in
                if (error != nil) {
                    println("Error: \(error!.description)")
                } else if (scores != nil) {
                    let localPlayerScore = leaderBoardRequest.localPlayerScore
                    self.gcScore = Int(localPlayerScore.value)
                    println("Local player's score: \(localPlayerScore.value)")
                }
            }
        } else {
            println("putz")
        }
    }
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
