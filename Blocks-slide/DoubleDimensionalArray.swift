//
//  DoubleDimensionalArray.swift
//  Blocks-slide
//
//  Created by Serx on 3/10/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import Foundation
import UIKit

struct DoubleDimensionalArrayInt{
    
    let rows: Int
    let columns:Int
    
    var grid:[Int]
    
    init(rows: Int, columns: Int){
        
        self.rows = rows
        self.columns = columns
        
        grid = Array(count: rows * columns, repeatedValue: 0)
    }
    
    subscript(row: Int, col: Int) ->Int{
    
        get{
            return grid[(row * columns) + col]
        }
        set{
            grid[(row * columns) + col] = newValue
        }
    }
}

struct DoubleDimensionalArrayFloat{
    
    let rows: Int
    let columns:Int
    
    var grid:[Double]
    
    init(rows: Int, columns: Int){
        
        self.rows = rows
        self.columns = columns
        
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    subscript(row: Int, col: Int) -> Double{
        
        get{
            return grid[(row * columns) + col]
        }
        set{
            grid[(row * columns) + col] = newValue
        }
    }
}

struct DoubleDimensionalArrayBool{
    
    let rows: Int
    let columns:Int
    
    var grid:[Bool]
    
    init(rows: Int, columns: Int){
        
        self.rows = rows
        self.columns = columns
        
        grid = Array(count: rows * columns, repeatedValue: false)
    }
    
    subscript(row: Int, col: Int) -> Bool{
        
        get{
            return grid[(row * columns) + col]
        }
        set{
            grid[(row * columns) + col] = newValue
        }
    }
}

struct DoubleDimensionalArrayPoint{
    
    let rows: Int
    let columns:Int
    
    var grid:[CGPoint]
    
    init(rows: Int, columns: Int){
        
        self.rows = rows
        self.columns = columns
        
        grid = Array(count: rows * columns, repeatedValue: CGPoint(x: 0.0, y: 0.0))
    }
    
    subscript(row: Int, col: Int) -> CGPoint{
        
        get{
            return grid[(row * columns) + col]
        }
        set{
            grid[(row * columns) + col] = newValue
        }
    }
}