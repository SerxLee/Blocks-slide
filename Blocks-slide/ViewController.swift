//
//  ViewController.swift
//  Blocks-slide
//

//2016-03-10T04:42:53.381015Z 1 [Note] A temporary password is generated for root@localhost: hiPsSaM(y86c

//If you lose this password, please consult the section How to Reset the Root Password in the MySQL reference manual.

//  Created by Serx on 3/9/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var doubleArrayBoolBlocks = DoubleDimensionalArrayBool(rows: 10, columns: 10)
    var doubleArrayPointBlocks = DoubleDimensionalArrayPoint(rows: 10, columns: 10)
    
    //the second view size
    var grayView: UIView!
    var grayViewLenght: CGFloat!
    var grayViewHeight: CGFloat!
    
    
    //set the oringinal position and the lenght of the blocks (face to the grayview)
    var positionOfBlcoks = CGPoint(x: 0.0, y: 0.0)
    var sizeOfBlocks: CGSize!
    var blockLenght: CGFloat!

    
    let tapRecognizer = UITapGestureRecognizer()
    let panRecognizer = UIPanGestureRecognizer()
    
    //swipe every direction
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    

        
/*
    all the position of the blocks,
    according to the 5.5' screen iPhone6 Plus.
    
        0.0, 0.0
        65.0, 0.0
        130.0, 0.0
        195.0, 0.0
        260.0, 0.0
        325.0, 0.0
        
        
        0.0, 65.0
        65.0, 65.0
        130.0, 65.0
        195.0, 65.0
        260.0, 65.0
        325.0, 65.0
        
        
        0.0, 130.0
        65.0, 130.0
        130.0, 130.0
        195.0, 130.0
        260.0, 130.0
        325.0, 130.0
        
        
        0.0, 195.0
        65.0, 195.0
        130.0, 195.0
        195.0, 195.0
        260.0, 195.0
        325.0, 195.0
        
        
        0.0, 260.0
        65.0, 260.0
        130.0, 260.0
        195.0, 260.0
        260.0, 260.0
        325.0, 260.0
        
        
        0.0, 325.0
        65.0, 325.0
        130.0, 325.0
        195.0, 325.0
        260.0, 325.0
        325.0, 325.0
*/
    func allBlocksPoint(){
        for index_j in 0...5{
            for index_i in 0...5{
                doubleArrayPointBlocks[index_i, index_j] = CGPoint(x: grayViewLenght / 6 * CGFloat(index_i), y: grayViewHeight / 6 * CGFloat(index_j))
                print("\(grayViewLenght / 6 * CGFloat(index_i)), \(grayViewHeight / 6 * CGFloat(index_j))")
            }
            print("\n")
        }
        
    }
    
    //set the location, if there is a block, the doubleArrayBoolBlocks's value if ture.
    func isThereA_Block(){
        
        let Yaxis = 0
        for i in 0...5{
            doubleArrayBoolBlocks[i, Yaxis] = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Obtain the device's screen size, and Set the blocks's side
        getDevicesSize()
        sizeOfBlocks = CGSize(width: blockLenght, height: blockLenght)
        
        //MARK:grayview handing all the blocks
        grayView = UIView(frame: CGRect(x: 12.0, y: 82.0, width: grayViewLenght, height: grayViewHeight))
        grayView.backgroundColor = UIColor.grayColor()
        view.addSubview(grayView)
        
        //create the blocks and drap them in the grayview
        allBlocksPoint()
        
        isThereA_Block()
        
        createBlocksToMove(6)

        
        //call the method: set gesture recognizer attribute
        setGestureAttribute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getDevicesSize(){
        
        let masterX: CGFloat = getTrueLength(true)
        let masterY: CGFloat = getTrueLength(false)

        grayViewLenght = masterX - 24.0
        grayViewHeight = grayViewLenght
        
        blockLenght = grayViewLenght / 6
        
        print(masterX)
        print(masterY)
        print(blockLenght)
    }
    
    
    func createBlocksToMove(num: Int){
        
        for index_i in 0...5{
            for index_j in 0...5{
                
                //if the position of the matrix has a block, create a blocks in the position
                if doubleArrayBoolBlocks[index_i, index_j]{
                    
                    let view2 = UIView(frame: CGRect(origin: doubleArrayPointBlocks[index_i, index_j], size: sizeOfBlocks))
                    view2.backgroundColor = UIColor.whiteColor()
                    
                    grayView.addSubview(view2)
                }
            }
        }
/*
        for a in 0..<num{
            
            positionOfBlcoks.x = CGFloat(a * 65)
            
            let view2 = UIView(frame: CGRect(origin: positionOfBlcoks, size: sizeOfBlocks))
            view2.backgroundColor = UIColor.whiteColor()
            
            grayView.addSubview(view2)
//            NSLog("aaa")
        }

*/
    }
    
    
    
    /*
        according to the system version to get the real height and lenght
        while the isWidth if TRUE，is said that you get the lenght，FALSE is said that you get the height
    */
    func getTrueLength(isWidth:Bool)->CGFloat{
        
        let myRect:CGRect = UIScreen.mainScreen().bounds;
        
        //get the device's system version
        let myDeviceVersion:Float = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        var length:CGFloat = 0.0
        
        //if the iOS version lower than 8.0 and the orientation is landscsape
        if(myDeviceVersion < 8.0&&(self.interfaceOrientation == UIInterfaceOrientation.LandscapeLeft||self.interfaceOrientation == UIInterfaceOrientation.LandscapeRight)){
            
            if(isWidth){
                length = myRect.size.height
            }else{
                length = myRect.size.width
            }
        }
        else{
            if(isWidth){
                length = myRect.size.width
            }
            else{
                length = myRect.size.height
            }
        }
        return length;
    }
    
    //TODO: gesture recognizer's attribute
    func setGestureAttribute(){
        
        //The number of taps required to match
        tapRecognizer.numberOfTapsRequired = 1
        //The number of fingers required to match
        tapRecognizer.numberOfTouchesRequired = 1
        
        // default is (2) the number of fingers that must swipe
        swipeUp.numberOfTouchesRequired = 2
        swipeDown.numberOfTouchesRequired = 2
        swipeLeft.numberOfTouchesRequired = 2
        swipeRight.numberOfTouchesRequired = 2
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Right
        
        self.grayView.addGestureRecognizer(swipeUp)
        self.grayView.addGestureRecognizer(swipeDown)
        self.grayView.addGestureRecognizer(swipeLeft)
        self.grayView.addGestureRecognizer(swipeRight)
    }
    
    //swipe to move the blocks
    func swipe(recognizer: UISwipeGestureRecognizer){
        
        
        
        if recognizer.direction == UISwipeGestureRecognizerDirection.Up{
            
        }else if recognizer.direction == UISwipeGestureRecognizerDirection.Down{
        
        }else if recognizer.direction == UISwipeGestureRecognizerDirection.Right{
        
        }else{
        
        }
        
    }
    
    //judge the block which you want to move, 2 blocks together
    func judgeBlocksToMove(recognizer: UISwipeGestureRecognizer) -> UIView{
        
        var firstBlcok: UIView!
        
        let swipeStartPoint = recognizer.locationInView(self.grayView)
        let sx = swipeStartPoint.x
        let sy = swipeStartPoint.y
        
        
        
        //MARK: test the start point
        print(swipeStartPoint.x)
        print(swipeStartPoint.y)

        return firstBlcok
    }
}

