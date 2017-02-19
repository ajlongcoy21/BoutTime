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
    @IBOutlet weak var MoveButton1: UIButton!
    @IBOutlet weak var MoveButton2: UIButton!
    @IBOutlet weak var MoveButton3: UIButton!
    @IBOutlet weak var MoveButton4: UIButton!
    @IBOutlet weak var MoveButton5: UIButton!
    @IBOutlet weak var MoveButton6: UIButton!
    
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
            
        case 6:
            
            NextRoundButton.setImage(nil, for: .normal)
            enableMoveButtons()
            informationLabel.text = "Shake to complete"
            TimerLabel.text = "1:00"
            seconds = 60
            movieSequenceGame.resetMovieSelectedArray()
            movieSequenceGame.updateRound()
            gameTimer = Timer()
            movieArray = movieSequenceGame.selectMovies()
            updateDisplay()
            startTimer()
            
            
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
        
        disableNextRoundButton()
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
        if !movieSequenceGame.isGameFinished()
        {
            enableNextRoundButton()
            disableMoveButtons()
            
            informationLabel.text = "Tap movies to learn more"
        
            switch fromUser
            {
            case true:
                NextRoundButton.setImage(#imageLiteral(resourceName: "NextRoundCorrect"), for: .normal)
            default:
                NextRoundButton.setImage(#imageLiteral(resourceName: "NextRoundFail"), for: .normal)
            }
        }
        else
        {
            disableNextRoundButton()
            disableMoveButtons()
            informationLabel.text = "Game is finished"
        }
    }
    
    /*------------------------------------------------------------------------------
     disableNextRoundButton
     
     Arguments: None
     Returns: None
     
     diables the next round button so the user is not able to press during a round
     ------------------------------------------------------------------------------*/
    
    func disableNextRoundButton()
    {
        NextRoundButton.isUserInteractionEnabled = false
        
    }
    
    /*------------------------------------------------------------------------------
     enableNextRoundButton
     
     Arguments: None
     Returns: None
     
     enables the next round button so the user can can continue to play
     ------------------------------------------------------------------------------*/
    
    func enableNextRoundButton()
    {
        NextRoundButton.isUserInteractionEnabled = true
        
    }
    
    /*------------------------------------------------------------------------------
     disableMoveButtons
     
     Arguments: None
     Returns: None
     
     diables the move buttons until the next round
     ------------------------------------------------------------------------------*/
    
    func disableMoveButtons()
    {
        MoveButton1.isUserInteractionEnabled = false
        MoveButton2.isUserInteractionEnabled = false
        MoveButton3.isUserInteractionEnabled = false
        MoveButton4.isUserInteractionEnabled = false
        MoveButton5.isUserInteractionEnabled = false
        MoveButton6.isUserInteractionEnabled = false
        
    }
    
    /*------------------------------------------------------------------------------
     enableMoveButtons
     
     Arguments: None
     Returns: None
     
     enables the move buttons so the user can continue to play
     ------------------------------------------------------------------------------*/
    
    func enableMoveButtons()
    {
        MoveButton1.isUserInteractionEnabled = true
        MoveButton2.isUserInteractionEnabled = true
        MoveButton3.isUserInteractionEnabled = true
        MoveButton4.isUserInteractionEnabled = true
        MoveButton5.isUserInteractionEnabled = true
        MoveButton6.isUserInteractionEnabled = true
        
    }

}

