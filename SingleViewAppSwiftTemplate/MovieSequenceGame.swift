//
//  SequenceGame.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Alan Longcoy on 2/18/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

//import Foundation
import GameKit

struct Movie
{
    let debutDate: Date
    let movieTitle: String
}

class MovieSequenceGame: Game
{
    var gameRound: Int
    var playerScore: Int
    
    var moviesSelected: Bool
    var moviesSelectedArray: [Int]
    var movieInventory: [String: Movie]

    required init(movieInventory: [String : Movie])
    {
        self.movieInventory = movieInventory
        
        self.gameRound = 0
        self.playerScore = 0
        
        self.moviesSelectedArray = Array(repeating: -1, count: 4)
        self.moviesSelected = false
        
    }
    
    func displayMovieInventory()
    {
        print(movieInventory)
    }
    
    func selectMovies() -> [Movie]
    {
        
        let maxNumber = UInt32(movieInventory.count - 1)
        var randomNumber: Int = 0
        var movieArray: [Movie] = []
        
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
        
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[0])"]!)
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[1])"]!)
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[2])"]!)
        movieArray.append(movieInventory["Movie\(moviesSelectedArray[3])"]!)
        
        return movieArray
    }
    
    func validMovieSelections() -> Bool
    {
        for movieOption in moviesSelectedArray
        {
            if movieOption == -1
            {
                return false
            }
        }
        
        if moviesSelectedArray[0] != moviesSelectedArray[1] && moviesSelectedArray[0] != moviesSelectedArray[2] && moviesSelectedArray[0] != moviesSelectedArray[3]
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func resetMovieSelections()
    {
        for index in 0...3
        {
            moviesSelectedArray[index] = -1
        }
    }
    
    func checkAnswer(submittal: [Movie]) -> Bool
    {
        
        if submittal[0].debutDate < submittal[1].debutDate && submittal[1].debutDate < submittal[2].debutDate && submittal[2].debutDate < submittal[3].debutDate
        {
            playerScore += 1
            return true
        }
        
        return false
        
    }
    
    func resetMovieSelectedArray()
    {
        for index in 1...3
        {
            moviesSelectedArray[index] = -1
        }
    }
    
    func updateRound()
    {
        gameRound += 1
    }
    
    func getRound() -> Int
    {
        return gameRound
    }
    
    func isGameFinished() -> Bool
    {
        if gameRound == 6
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}

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






