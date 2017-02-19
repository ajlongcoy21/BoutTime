//
//  PlistConverter.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Alan Longcoy on 2/18/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

enum MovieError: Error
{
    case invalidResource
    case conversionFailure
    case invalidSelection
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
    static func movieInventory(fromDictionary dictionary: [String: AnyObject]) throws -> [VendingSelection: VendingItem]
    {
        var inventory: [VendingSelection: VendingItem] = [:]
        
        for (key, value) in dictionary
        {
            if let itemDictionary = value as? [String: Any], let price = itemDictionary["price"] as? Double, let quantity = itemDictionary["quantity"] as? Int
            {
                let item = Item(price: price, quantity: quantity)
                
                guard let selection = VendingSelection(rawValue: key) else
                {
                    throw MovieError.invalidSelection
                }
                
                inventory.updateValue(item, forKey: selection)
            }
        }
        
        return inventory
    }
}
