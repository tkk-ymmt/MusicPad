//
//  ViewController.swift
//  MusicPad
//
//  Created by motoki on 2017/09/01.
//  Copyright © 2017年 motoki. All rights reserved.
//

import UIKit


class ViewController: UIViewController, Animation {

    @IBOutlet var scaleButtonArray: [ScaleButton]!
    let musicPlayer = MusicPlayer.sharedInstance!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func touchDown(_ sender: ScaleButton) {
        musicPlayer.playAudio(tag: sender.tag)
        animationGen(tag: sender.tag, scaleButtonArray: self.scaleButtonArray)
    }
}

