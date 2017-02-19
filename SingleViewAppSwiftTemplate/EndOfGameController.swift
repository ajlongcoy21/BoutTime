//
//  EndOfGameController.swift
//  BoutTime
//
//  Created by Alan Longcoy on 2/19/17.
//  Copyright © 2017 Treehouse Island, Inc. All rights reserved.
//

import UIKit

var gameResult: Int = 9

class EndOfGameController: UIViewController
{
    
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ScoreLabel.text = "\(gameResult)/6"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any)
    {
        
        
        dismiss(animated: true, completion: nil)

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
