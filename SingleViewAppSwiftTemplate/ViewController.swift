//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    let movieSequenceGame: MovieSequenceGame
    var movieArray: [Movie]
    
    @IBOutlet weak var FirstLabel: UILabel!
    @IBOutlet weak var SecondLabel: UILabel!
    @IBOutlet weak var ThirdLabel: UILabel!
    @IBOutlet weak var FourthLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder)
    {
        do
        {
            let dictionary = try PlistConverter.dictionary(fromFile: "MovieDebuts", ofType: "plist")
            let movieInventory = try MovieUnarchiver.movieInventory(fromDictionary: dictionary)
            self.movieSequenceGame = MovieSequenceGame(movieInventory: movieInventory)
        }
        catch let error
        {
            fatalError("\(error)")
        }
        
        movieArray = movieSequenceGame.selectMovies()
        
        super.init(coder: aDecoder)
        
    }

    @IBAction func moveEvent(_ sender: UIButton)
    {
        var tempText: String = ""
        
        switch sender.tag
        {
        case 0, 1:
            tempText = FirstLabel.text!
            FirstLabel.text = SecondLabel.text
            SecondLabel.text = tempText
        case 2, 3:
            tempText = SecondLabel.text!
            SecondLabel.text = ThirdLabel.text
            ThirdLabel.text = tempText
        case 4, 5:
            tempText = ThirdLabel.text!
            ThirdLabel.text = FourthLabel.text
            FourthLabel.text = tempText
        default:
            break
        }
        
    }
    
    @IBAction func moveButtonPressedDown(_ sender: UIButton)
    {

    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FirstLabel.text = movieArray[0].movieTitle
        SecondLabel.text = movieArray[1].movieTitle
        ThirdLabel.text = movieArray[2].movieTitle
        FourthLabel.text = movieArray[3].movieTitle
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func updateDisplay()
    {
        FirstLabel.text = movieArray[0].movieTitle
        SecondLabel.text = movieArray[1].movieTitle
        ThirdLabel.text = movieArray[2].movieTitle
        FourthLabel.text = movieArray[3].movieTitle
    }


}

