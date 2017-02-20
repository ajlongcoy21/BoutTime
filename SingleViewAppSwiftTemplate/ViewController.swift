//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

/*--------------------------------------------------------------------------
 Import kits and toolboxes
 --------------------------------------------------------------------------*/

import UIKit

/*--------------------------------------------------------------------------
 Class ViewController
 
 Controls the view part of the application
 --------------------------------------------------------------------------*/

class ViewController: UIViewController
{
    /*--------------------------------------------------------------------------
     Define local variables that are used to control the sequence game display
     --------------------------------------------------------------------------*/
    
    let movieSequenceGame: MovieSequenceGame           // Create a movieSequenceGame instance
    var movieArray: [Movie]                            // movieArray - An array of movie structures used to display on the labels
    
    var gameTimer: Timer                               // gameTimer - Timer that is used during each round
    var seconds: Int                                   // seconds - variable used to display the timer countdown
    
    /*--------------------------------------------------------------------------
     Create a connection between the screen labels and buttons and the
     viewController.
     --------------------------------------------------------------------------*/
    
    @IBOutlet weak var FirstLabel: UILabel!           //Label to display answer option 1 to the question
    @IBOutlet weak var SecondLabel: UILabel!          //Label to display answer option 2 to the question
    @IBOutlet weak var ThirdLabel: UILabel!           //Label to display answer option 3 to the question
    @IBOutlet weak var FourthLabel: UILabel!          //Label to display answer option 4 to the question
    @IBOutlet weak var TimerLabel: UILabel!           //Label to display the timer countdown for each round
    @IBOutlet weak var informationLabel: UILabel!     //Label to display instructions for the user
    
    @IBOutlet weak var NextRoundButton: UIButton!     //Button to initiate the next round in the game
    @IBOutlet weak var MoveButton1: UIButton!         //Button to swap options 1 & 2
    @IBOutlet weak var MoveButton2: UIButton!         //Button to swap options 1 & 2
    @IBOutlet weak var MoveButton3: UIButton!         //Button to swap options 2 & 3
    @IBOutlet weak var MoveButton4: UIButton!         //Button to swap options 2 & 3
    @IBOutlet weak var MoveButton5: UIButton!         //Button to swap options 3 & 4
    @IBOutlet weak var MoveButton6: UIButton!         //Button to swap options 3 & 4
    
    required init?(coder aDecoder: NSCoder)
    {
        
        /*--------------------------------------------------------------------------
         Read the list of movies and their associated information from the
         MovieDebuts.plist. Create the Movie structures and game and initialize
         the starting conditions for the game.
         --------------------------------------------------------------------------*/
        
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
    
    /*------------------------------------------------------------------------------
     moveEvent
     
     Arguments: UIButton
     Returns: None
     
     This function takes the press event from all the buttons on the board. If
     Buttons 1-5 are pressed, the logic moves the movies around according to where
     the player wants them. 
     
     If the NextRoundButton is pressed, the game resets information displayed to
     the user and a new round is initiated.
     ------------------------------------------------------------------------------*/

    @IBAction func moveEvent(_ sender: UIButton)
    {
        
        /*--------------------------------------------------------------------------
         Variables to keep swap and keep track of how the user would like to arrange
         the movies
         --------------------------------------------------------------------------*/
        
        var tempText: String = ""                  //String used to temporarely store label text to swap answers for the user
        var tempMovie: Movie                       //Movie used to temporarely store a movie struct to swap answer for the user
        
        /*--------------------------------------------------------------------------
         Look at the tag of the button that was pressed to determine if it was a
         button to move the answers around or to move to the next round
         --------------------------------------------------------------------------*/
        
        switch sender.tag
        {
        case 0, 1:                              //Swap answers 1 and 2
            tempText = FirstLabel.text!
            FirstLabel.text = SecondLabel.text
            SecondLabel.text = tempText
            
            tempMovie = movieArray[0]
            movieArray[0] = movieArray[1]
            movieArray[1] = tempMovie
            
        case 2, 3:                              //Swap answers 2 and 3
            tempText = SecondLabel.text!
            SecondLabel.text = ThirdLabel.text
            ThirdLabel.text = tempText
            
            tempMovie = movieArray[1]
            movieArray[1] = movieArray[2]
            movieArray[2] = tempMovie
            
        case 4, 5:                              //Swap answers 3 and 4
            tempText = ThirdLabel.text!
            ThirdLabel.text = FourthLabel.text
            FourthLabel.text = tempText
            
            tempMovie = movieArray[2]
            movieArray[2] = movieArray[3]
            movieArray[3] = tempMovie
            
        case 6:                                             //Start a new round of the game
            
            // Reset buttons for the user experience
            
            NextRoundButton.setImage(nil, for: .normal)
            enableMoveButtons()
            
            // Reset visuals for the user
            
            informationLabel.text = "Shake to complete"
            TimerLabel.text = "1:00"
            seconds = 60
            
            // Reset the game and timer
            
            movieSequenceGame.resetMovieSelectedArray()
            movieSequenceGame.updateRound()
            gameTimer = Timer()
            movieArray = movieSequenceGame.selectMovies()
            
            // Update the display and start the timer
            
            updateDisplay()
            startTimer()
            
            
        default:
            break
        }
        
    }

    /*------------------------------------------------------------------------------
     viewDidAppear
     
     Arguments: Bool
     Returns: None
     
     This function is used for when the main view controller comes back into view.
     It is used to reset the display and the user controls.
     ------------------------------------------------------------------------------*/
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        // Reset the games and display information
        
        seconds = 60
        TimerLabel.text = "1:00"
        
        movieSequenceGame.resetGame()
        movieArray = movieSequenceGame.selectMovies()
        
        // Setup buttons for the next round
        
        disableNextRoundButton()
        enableMoveButtons()
        
        // start the timer for the next round
        
        startTimer()
        
        // Update the labels with the next round of movies
        
        updateDisplay() //just modified this // check if it works
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.becomeFirstResponder() // Used to detect the shaking of the phone
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    /*------------------------------------------------------------------------------
     startTimer
     
     Arguments: None
     Returns: None
     
     This function starts the timer for the game. Set to repeat every one second.
     ------------------------------------------------------------------------------*/
    
    func startTimer()
    {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimerLabel)), userInfo: nil, repeats: true)
    }
    
    /*------------------------------------------------------------------------------
     updateTimerLabel
     
     Arguments: None
     Returns: None
     
     This function displays the timer and the time left in the round.
     ------------------------------------------------------------------------------*/
    
    func updateTimerLabel()
    {
        // If the timer is positive, display the time correctly to the user
        
        if (seconds > 0)
        {
            switch seconds
            {
            case 1,2,3,4,5,6,7,8,9,10:               // We need to add a 0 in front of the single digit numbers
                seconds -= 1
                TimerLabel.text = "0:0\(seconds)"
            default:                                 // Do not need to add the additional 0 in the string
                seconds -= 1
                TimerLabel.text = "0:\(seconds)"
            }
        }
        else                                        // If the timer is at 0, that means the round has ended
        {
            gameTimer.invalidate()                                                  // Stop the timer
            answer(fromUser: movieSequenceGame.checkAnswer(submittal: movieArray))  // Check the answer for the user
        }
        
    }
    
    /*------------------------------------------------------------------------------
     updateDisplay
     
     Arguments: None
     Returns: None
     
     Update the labels to show the movies to the user
     ------------------------------------------------------------------------------*/
    
    func updateDisplay()
    {
        FirstLabel.text = movieArray[0].movieTitle
        SecondLabel.text = movieArray[1].movieTitle
        ThirdLabel.text = movieArray[2].movieTitle
        FourthLabel.text = movieArray[3].movieTitle
    }
    
    /*------------------------------------------------------------------------------
     motionBegan
     
     Arguments: UIEventSubtype, UIEvent
     Returns: None
     
     Used to detect the shaking of the phone. If the phone was shooken, stop the
     round and check the answer for the user.
     ------------------------------------------------------------------------------*/
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if motion == .motionShake
        {
            gameTimer.invalidate()
            answer(fromUser: movieSequenceGame.checkAnswer(submittal: movieArray))
        }
    }
    
    /*------------------------------------------------------------------------------
     answer
     
     Arguments: Bool
     Returns: None
     
     Used display to the user whether they got the answer correct or incorrect.
     ------------------------------------------------------------------------------*/
    
    func answer(fromUser: Bool)
    {
        // If the game is not complete show the user if they are right or not 
        
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
        else // End the game and display the ending page
        {
            disableNextRoundButton()
            disableMoveButtons()
            gameResult = movieSequenceGame.getScore()
            finishGameScreen()
            

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
    
    /*------------------------------------------------------------------------------
     finishGameScreen
     
     Arguments: None
     Returns: None
     
     loads the new view showing the user how they did during the game
     ------------------------------------------------------------------------------*/
    
    func finishGameScreen()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "EndOfGameController")
        
        // If you want to present the new ViewController then use this
        self.present(objSomeViewController, animated:true, completion:nil)
        
    }

}

