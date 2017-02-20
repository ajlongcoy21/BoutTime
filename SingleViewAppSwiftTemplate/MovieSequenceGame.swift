//
//  SequenceGame.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Alan Longcoy on 2/18/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

//import Foundation
import GameKit

/*------------------------------------------------------------------------------
 Movie Struct
 
 Struct used to store the information for the movie. Debut Date and Movie Title
 ------------------------------------------------------------------------------*/

struct Movie
{
    let debutDate: Date
    let movieTitle: String
}

/*------------------------------------------------------------------------------
 MovieSequenceGame
 
 Game class created to control the game
 ------------------------------------------------------------------------------*/

class MovieSequenceGame: Game
{
    
    /*--------------------------------------------------------------------------
     Define local variables that are used to control the gameplay
     --------------------------------------------------------------------------*/
    
    var gameRound: Int
    var playerScore: Int
    
    var moviesSelected: Bool
    var moviesSelectedArray: [Int]
    var movieInventory: [String: Movie]

    /*------------------------------------------------------------------------------
     init
     
     Arguments: Dictionary of Strings with value of Movie
     Returns: None
     
     This function initializes the game class
     ------------------------------------------------------------------------------*/
    
    required init(movieInventory: [String : Movie])
    {
        self.movieInventory = movieInventory
        
        self.gameRound = 0
        self.playerScore = 0
        
        self.moviesSelectedArray = Array(repeating: -1, count: 4)
        self.moviesSelected = false
        
    }
    
    /*------------------------------------------------------------------------------
     selectMovies
     
     Arguments: None
     Returns: Movie array
     
     This function selects the movies to be displayed for the next round. It ensures
     that there are no duplicates that will be shown to the user.
     ------------------------------------------------------------------------------*/
    
    func selectMovies() -> [Movie]
    {
        
        let maxNumber = UInt32(movieInventory.count - 1)             // Used to determine how many options there are
        var randomNumber: Int = 0
        var movieArray: [Movie] = []
        
        // While we do not have valid movie selections to display to the user, continue to randomly select options
        
        while !validMovieSelections()
        {
            randomNumber = Int(arc4random_uniform(maxNumber) + 1)
            
            moviesSelectedArray[0] = randomNumber
            
            for index in 1...3
            {
                randomNumber = Int(arc4random_uniform(maxNumber) + 1)
                
                switch index
                {
                case 1:
                    
                    while randomNumber == moviesSelectedArray[0]
                    {
                        randomNumber = Int(arc4random_uniform(maxNumber) + 1)
                    }
                    
                    moviesSelectedArray[index] = randomNumber
                    
                case 2:
                    
                    while randomNumber == moviesSelectedArray[0] || randomNumber == moviesSelectedArray[1]
                    {
                        randomNumber = Int(arc4random_uniform(maxNumber) + 1)
                    }
                    
                    moviesSelectedArray[index] = randomNumber
                    
                case 3:
                    
                    while randomNumber == moviesSelectedArray[0] || randomNumber == moviesSelectedArray[1] || randomNumber == moviesSelectedArray[2]
                    {
                        randomNumber = Int(arc4random_uniform(maxNumber) + 1)
                    }
                    
                    moviesSelectedArray[index] = randomNumber
                    
                default:
                    break
                }
                
            }
        }
        
        // Used to track which options were chosen to be displayed to the user
        
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[0])"]!)
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[1])"]!)
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[2])"]!)
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[3])"]!)
        
        return movieArray
    }
    
    /*------------------------------------------------------------------------------
     validMovieSelections
     
     Arguments: None
     Returns: Bool
     
     This function looks to see if the the movie selection is okay to be displayed
     to the user without duplicates.
     ------------------------------------------------------------------------------*/
    
    func validMovieSelections() -> Bool
    {
        
        // check to see if the array is set to the starting default value of -1
        
        for movieOption in moviesSelectedArray
        {
            if movieOption == -1
            {
                return false
            }
        }
        
        // If not check to see of all of the movies are different
        
        if moviesSelectedArray[0] != moviesSelectedArray[1] && moviesSelectedArray[0] != moviesSelectedArray[2] && moviesSelectedArray[0] != moviesSelectedArray[3]
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /*------------------------------------------------------------------------------
     checkAnswer
     
     Arguments: Movie Array
     Returns: Bool
     
     This function checks to see if the user put the movies in the correct debut 
     order (top to bottom : earliest to latest)
     ------------------------------------------------------------------------------*/
    
    func checkAnswer(submittal: [Movie]) -> Bool
    {
        
        if submittal[0].debutDate < submittal[1].debutDate && submittal[1].debutDate < submittal[2].debutDate && submittal[2].debutDate < submittal[3].debutDate
        {
            playerScore += 1
            return true
        }
        
        return false
        
    }
    
    /*------------------------------------------------------------------------------
     resetMovieSelectedArray
     
     Arguments: None
     Returns: None
     
     This function resets the movie array to prepare for the new round
     ------------------------------------------------------------------------------*/
    
    func resetMovieSelectedArray()
    {
        for index in 1...3
        {
            moviesSelectedArray[index] = -1
        }
    }
    
    /*------------------------------------------------------------------------------
     updateRound
     
     Arguments: None
     Returns: None
     
     This function keeps track of how many rounds have been played
     ------------------------------------------------------------------------------*/
    
    func updateRound()
    {
        gameRound += 1
    }
    
    /*------------------------------------------------------------------------------
     getRound
     
     Arguments: None
     Returns: Int
     
     This function just returns how many rounds have been played
     ------------------------------------------------------------------------------*/
    
    func getRound() -> Int
    {
        return gameRound
    }
    
    /*------------------------------------------------------------------------------
     getScore
     
     Arguments: None
     Returns: Int
     
     This function just returns the players score
     ------------------------------------------------------------------------------*/
    
    func getScore() -> Int
    {
        return playerScore
    }
    
    /*------------------------------------------------------------------------------
     isGameFinished
     
     Arguments: None
     Returns: Bool
     
     This function checks to see how many rounds have been played. If 6 have been
     played then the game will end.
     ------------------------------------------------------------------------------*/
    
    func isGameFinished() -> Bool
    {
        if gameRound == 5
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /*------------------------------------------------------------------------------
     resetGame
     
     Arguments: None
     Returns: None
     
     resets the game to start play over
     ------------------------------------------------------------------------------*/
    
    func resetGame()
    {
        self.gameRound = 0
        self.playerScore = 0
        self.moviesSelected = false
        
        resetMovieSelectedArray()
    }
    
}

/*------------------------------------------------------------------------------
Code to extract the information from the PList File
 ------------------------------------------------------------------------------*/

enum MovieError: Error
{
    case invalidResource
    case conversionFailure
    case invalidDateOrTitle
}

class PlistConverter
{
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject]
    {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else
        {
            throw MovieError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else
        {
            throw MovieError.conversionFailure
        }
        
        return dictionary
    }
}

class MovieUnarchiver
{
    static func movieInventory(fromDictionary dictionary: [String: AnyObject]) throws -> [String: Movie]
    {
        var movieInventory: [String: Movie] = [:]
        
        for (key, value) in dictionary
        {
            if let itemDictionary = value as? [String: Any], let debutDate = itemDictionary["debutDate"] as? Date, let movieTitle = itemDictionary["movieTitle"] as? String
            {
                let item = Movie(debutDate: debutDate, movieTitle: movieTitle)

                movieInventory.updateValue(item, forKey: key)
            }
            else
            {
                throw MovieError.invalidDateOrTitle
            }
        }
        
        return movieInventory
    }
}






