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
    
    var gameTimer: Timer
    var seconds: Int
    
    @IBOutlet weak var FirstLabel: UILabel!
    @IBOutlet weak var SecondLabel: UILabel!
    @IBOutlet weak var ThirdLabel: UILabel!
    @IBOutlet weak var FourthLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var NextRoundButton: UIButton!
    
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
        gameTimer = Timer()
        seconds = 60
        
        super.init(coder: aDecoder)
        
    }

    @IBAction func moveEvent(_ sender: UIButton)
    {
        var tempText: String = ""
        var tempMovie: Movie
        
        switch sender.tag
        {
        case 0, 1:
            tempText = FirstLabel.text!
            FirstLabel.text = SecondLabel.text
            SecondLabel.text = tempText
            
            tempMovie = movieArray[0]
            movieArray[0] = movieArray[1]
            movieArray[1] = tempMovie
            
        case 2, 3:
            tempText = SecondLabel.text!
            SecondLabel.text = ThirdLabel.text
            ThirdLabel.text = tempText
            
            tempMovie = movieArray[1]
            movieArray[1] = movieArray[2]
            movieArray[2] = tempMovie
            
        case 4, 5:
            tempText = ThirdLabel.text!
            ThirdLabel.text = FourthLabel.text
            FourthLabel.text = tempText
            
            tempMovie = movieArray[2]
            movieArray[2] = movieArray[3]
            movieArray[3] = tempMovie
            
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
        self.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
        FirstLabel.text = movieArray[0].movieTitle
        SecondLabel.text = movieArray[1].movieTitle
        ThirdLabel.text = movieArray[2].movieTitle
        FourthLabel.text = movieArray[3].movieTitle
        
        startTimer()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func startTimer()
    {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimerLabel)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimerLabel()
    {
        if (seconds > 0)
        {
            switch seconds
            {
            case 1,2,3,4,5,6,7,8,9,10:
                seconds -= 1
                TimerLabel.text = "0:0\(seconds)"
            default:
                seconds -= 1
                TimerLabel.text = "0:\(seconds)"
            }
        }
        else
        {
            gameTimer.invalidate()
            answer(fromUser: movieSequenceGame.checkAnswer(submittal: movieArray))
        }
        
    }
    
    func updateDisplay()
    {
        FirstLabel.text = movieArray[0].movieTitle
        SecondLabel.text = movieArray[1].movieTitle
        ThirdLabel.text = movieArray[2].movieTitle
        FourthLabel.text = movieArray[3].movieTitle
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if motion == .motionShake
        {
            gameTimer.invalidate()
            answer(fromUser: movieSequenceGame.checkAnswer(submittal: movieArray))
        }
    }
    
    func answer(fromUser: Bool)
    {
        informationLabel.text = "Tap events to learn more"
        
        switch fromUser
        {
        case true:
            NextRoundButton.setImage(#imageLiteral(resourceName: "NextRoundCorrect"), for: .normal)
        default:
            NextRoundButton.setImage(#imageLiteral(resourceName: "NextRoundFail"), for: .normal)
        }
    }

}

