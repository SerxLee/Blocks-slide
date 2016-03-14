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
    
    var doubleArrayNumberBlcoks = DoubleDimensionalArrayInt(rows: 100, columns: 100)
    var doubleArrayBoolBlocks = DoubleDimensionalArrayBool(rows: 100, columns: 100)
    var doubleArrayPointBlocks = DoubleDimensionalArrayPoint(rows: 100, columns: 100)
    var doubleArrayChooseBlocks = DoubleDimensionalArrayBool(rows: 100, columns: 100)
    
//    var Blocks: [UIView]!
    
    //the second view size
    var grayView: UIView!
    var grayViewLenght: CGFloat!
    var grayViewHeight: CGFloat!
    
    
    //set the oringinal position and the lenght of the blocks (face to the grayview)
    var positionOfBlcoks = CGPoint(x: 0.0, y: 0.0)
    var sizeOfBlocks: CGSize!
    var blockLenght: CGFloat!

    
    //swipe every direction
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    
    //pan 
    var pan = UIPanGestureRecognizer()
    
    //tap gesture
    var tapSingleFinger = UITapGestureRecognizer()
    var tapDoubleFinger = UITapGestureRecognizer()
    
    //test
    var firstBlockX: Int = -1
    var firstBlockY: Int = -1
    
    var secondBlockX: Int = -1
    var secondBlockY: Int = -1
    
    //
    var sx: CGFloat = 0.0
    var sy: CGFloat = 0.0
    var ex: CGFloat = 0.0
    var ey: CGFloat = 0.0
    
    //mark : get the point
    
    var flagFirst = Bool()
    var flagSecond = Bool()

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
        for index_j in 0...6{
            for index_i in 0...6{
                doubleArrayPointBlocks[index_i, index_j] = CGPoint(x: grayViewLenght / 6 * CGFloat(index_i), y: grayViewHeight / 6 * CGFloat(index_j))
//                print("\(grayViewLenght / 6 * CGFloat(index_i)), \(grayViewHeight / 6 * CGFloat(index_j))")
            }
//            print("\n")
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
        
        allBlocksPoint()
        
        isThereA_Block()
        
        //create the blocks and drap them in the grayview
        createBlocksToMove(1)

        //call the method: set gesture recognizer attribute
        setGestureAttribute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //a method of get the device size
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
        var numOfBlocks: Int = 0
        for index_i in 0...5{
            for index_j in 0...5{
                
                //if the position of the matrix has a block, create a blocks in the position
                if doubleArrayBoolBlocks[index_i, index_j]{

                    let view2 = UIView(frame: CGRect(origin: doubleArrayPointBlocks[index_i, index_j], size: sizeOfBlocks))
                    view2.backgroundColor = UIColor.whiteColor()
                    
                    //set the tag for everyone block
                    view2.tag = numOfBlocks + 1
                    
                    doubleArrayNumberBlcoks[index_i, index_j] = numOfBlocks + 1
    
                    grayView.addSubview(view2)
                    numOfBlocks++
                }
            }
        }
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
        
        // default is (2) the number of fingers that must swipe
        tapSingleFinger.numberOfTouchesRequired = 1
        tapSingleFinger.numberOfTapsRequired = 1
        tapSingleFinger.delegate = self
        tapSingleFinger = UITapGestureRecognizer(target: self, action: Selector("handleSingleFingerEvent:"))
        self.grayView.addGestureRecognizer(tapSingleFinger)
        tapSingleFinger.delegate = self
        
        
        tapDoubleFinger.numberOfTouchesRequired = 2
        tapDoubleFinger.numberOfTapsRequired = 1
        tapDoubleFinger.delegate = self
        tapDoubleFinger = UITapGestureRecognizer(target: self, action: Selector("handleDoubleFingerEvent:"))
        
        
        swipeUp.numberOfTouchesRequired = 1
        swipeDown.numberOfTouchesRequired = 1
        swipeLeft.numberOfTouchesRequired = 1
        swipeRight.numberOfTouchesRequired = 1
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        
        self.grayView.addGestureRecognizer(swipeUp)
        self.grayView.addGestureRecognizer(swipeDown)
        self.grayView.addGestureRecognizer(swipeLeft)
        self.grayView.addGestureRecognizer(swipeRight)
        
        swipeUp.enabled = false
        swipeDown.enabled = false
        swipeLeft.enabled = false
        swipeRight.enabled = false
        
        swipeUp.delegate = self
        swipeDown.delegate = self
        swipeLeft.delegate = self
        swipeRight.delegate = self
        
        
    }
    
    func checkTheBackground(xx: Int, yy: Int) -> Bool{
        
        if doubleArrayBoolBlocks[xx, yy]{
            return true
        }
        return false
    }
 
    //swipe to move the blocks
    func swipe(recognizer: UISwipeGestureRecognizer){
        
        if recognizer == swipeUp{
            
            if firstBlockY > 0 && secondBlockY > 0{
                
                //check and echange, make sure the firstBlock on the move direction's back.
                if firstBlockY < secondBlockY{
                    
//                    exchangeFirstAndSecond(firstBlockX, firY: firstBlockY, sndX: secondBlockX, sndY: secondBlockY)
                    
                    let limX = firstBlockX
                    let limY = firstBlockY
                    firstBlockX = secondBlockX
                    firstBlockY = secondBlockY
                    secondBlockX = limX
                    secondBlockY = limY
                    
                }
                
                if firstBlockY - 1 == secondBlockY{
                    
                    if !checkTheBackground(secondBlockX, yy: secondBlockY - 1) {
                        
                        for selectBlock in grayView.subviews{

                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY] {
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY - 1] = true
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY - 1] = selectBlock.tag
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y - blockLenght
                                NSLog("the \(selectBlock.tag)th move to up")
                            }
                        }
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y - blockLenght
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY - 1] = true
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY - 1] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to up")
                            }
                        }
                        firstBlockY = firstBlockY - 1
                        secondBlockY = secondBlockY - 1
                    }
                    
                }else{
                    
                    if !checkTheBackground(firstBlockX, yy: firstBlockY - 1) && !checkTheBackground(secondBlockX, yy: secondBlockY - 1){
                        
                        for selectBlock in grayView.subviews{
                            

                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY] {
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y - blockLenght
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY - 1] = true
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY - 1] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to up")
                            }
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y - blockLenght
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY - 1] = true
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY - 1] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to up")
                            }
                        }
                        firstBlockY = firstBlockY - 1
                        secondBlockY = secondBlockY - 1
                    }
                }
            }
            
        }else if recognizer == swipeDown{
            
            if firstBlockY < 5 && secondBlockY < 5{
                
                //check and echange, make sure the firstBlock on the move direction's back.
                if firstBlockY > secondBlockY{
                    
                    let limX = firstBlockX
                    let limY = firstBlockY
                    firstBlockX = secondBlockX
                    firstBlockY = secondBlockY
                    secondBlockX = limX
                    secondBlockY = limY
                    
                }
                
                if firstBlockY + 1 == secondBlockY{
                    
                    if !checkTheBackground(secondBlockX, yy: secondBlockY + 1){
                        
                        for selectBlock in grayView.subviews{

                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY] {
                                
                                NSLog("the \(selectBlock.tag)th move to down")
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y + blockLenght
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY + 1] = true
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY + 1] = selectBlock.tag
                                
                            }
                        }
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                NSLog("the \(selectBlock.tag)th move to down")
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y + blockLenght
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY + 1] = true
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY + 1] = selectBlock.tag
                                
                            }
                        }
                        firstBlockY = firstBlockY + 1
                        secondBlockY = secondBlockY + 1
                    }
                    
                }else{
                    if !checkTheBackground(firstBlockX, yy: firstBlockY + 1) && !checkTheBackground(secondBlockX, yy: secondBlockY + 1){
                        
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y + blockLenght
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY + 1] = true
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY + 1] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to down")
                            }
                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY] {
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.y = selectBlock.frame.origin.y + blockLenght
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY + 1] = true
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY + 1] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to down")
                            }
                        }
                        firstBlockY = firstBlockY + 1
                        secondBlockY = secondBlockY + 1
                    }
                }
            }
            
        }else if recognizer == swipeRight{
            
            if firstBlockX < 5 && secondBlockX < 5{
                
                if firstBlockX > secondBlockX{
                    
                    let limX = firstBlockX
                    let limY = firstBlockY
                    firstBlockX = secondBlockX
                    firstBlockY = secondBlockY
                    secondBlockX = limX
                    secondBlockY = limY
                    
                }
                
                if firstBlockX + 1 == secondBlockX{
                    
                    if !checkTheBackground(secondBlockX + 1, yy: secondBlockY){
                        
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY] {
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x + blockLenght
                                doubleArrayBoolBlocks[secondBlockX + 1, secondBlockY] = true
                                doubleArrayNumberBlcoks[secondBlockX + 1, secondBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to right")

                            }
                        }
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x + blockLenght
                                doubleArrayBoolBlocks[firstBlockX + 1, firstBlockY] = true
                                doubleArrayNumberBlcoks[firstBlockX + 1, firstBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to right")
                            }
                        }
                        firstBlockX = firstBlockX + 1
                        secondBlockX = secondBlockX + 1
                    }
                    
                }else{
                    
                    if !checkTheBackground(firstBlockX + 1, yy: firstBlockY) && !checkTheBackground(secondBlockX + 1, yy: secondBlockY){
                        
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x + blockLenght
                                doubleArrayBoolBlocks[firstBlockX + 1, firstBlockY] = true
                                doubleArrayNumberBlcoks[firstBlockX + 1, firstBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to right")
                            }
                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY] {
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x + blockLenght
                                doubleArrayBoolBlocks[secondBlockX + 1, secondBlockY] = true
                                doubleArrayNumberBlcoks[secondBlockX + 1, secondBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to right")
                            }
                        }
                        firstBlockX = firstBlockX + 1
                        secondBlockX = secondBlockX + 1
                    }
                }
            }
        }else if recognizer == swipeLeft{
            
            if firstBlockX > 0 && secondBlockX > 0{
                
                //check and echange, make sure the firstBlock on the move direction's back.
                if firstBlockX < secondBlockX{
                    
                    let limX = firstBlockX
                    let limY = firstBlockY
                    firstBlockX = secondBlockX
                    firstBlockY = secondBlockY
                    secondBlockX = limX
                    secondBlockY = limY
                }
                
                if firstBlockX - 1 == secondBlockX{
                    
                    if !checkTheBackground(secondBlockX - 1, yy: secondBlockY){
                        
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY]{
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x - blockLenght
                                
                                doubleArrayBoolBlocks[secondBlockX - 1,secondBlockY] = true
                                doubleArrayNumberBlcoks[secondBlockX - 1, secondBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to left")
                            }
                        }
                        for selectBlock in grayView.subviews{
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x - blockLenght
                                
                                doubleArrayBoolBlocks[firstBlockX - 1, firstBlockY] = true
                                doubleArrayNumberBlcoks[firstBlockX - 1, firstBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to left")
                            }
                        }
                        firstBlockX = firstBlockX - 1
                        secondBlockX = secondBlockX - 1
                    }
                    
                }else{
                    
                    if !checkTheBackground(firstBlockX - 1, yy: firstBlockY) && !checkTheBackground(secondBlockX - 1, yy: secondBlockY){
                        
                        for selectBlock in grayView.subviews{
                            if selectBlock.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY] {
                                
                                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x - blockLenght
                                
                                doubleArrayBoolBlocks[firstBlockX - 1, firstBlockY] = true
                                doubleArrayNumberBlcoks[firstBlockX - 1, firstBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to left")
                            }
                            
                            if selectBlock.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY]{
                                
                                doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                                doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                                
                                selectBlock.frame.origin.x = selectBlock.frame.origin.x - blockLenght
                                
                                doubleArrayBoolBlocks[secondBlockX - 1,secondBlockY] = true
                                doubleArrayNumberBlcoks[secondBlockX - 1, secondBlockY] = selectBlock.tag
                                NSLog("the \(selectBlock.tag)th move to left")
                            }
                        }
                        firstBlockX = firstBlockX - 1
                        secondBlockX = secondBlockX - 1
                    }
                }
            }
        }
    }

    //FIXME: choose the same blocks should not be allowed......
    func handleSingleFingerEvent(recognizer: UITapGestureRecognizer){
        
        if recognizer.numberOfTapsRequired == 1{
            
            let firstPoint:CGPoint!
            let secondPoint: CGPoint!
            
            if flagFirst && !flagSecond{
                secondPoint = recognizer.locationInView(self.grayView)
                
                ex = secondPoint.x
                ey = secondPoint.y
                
                var limBool: Bool = false

                //make sure the block had been choosed.
                for index_i in 0...5{
                    for index_j in 0...5{
                        
                        if doubleArrayBoolBlocks[index_i, index_j]{
                            
                            let contrastStart = doubleArrayPointBlocks[index_i, index_j]
                            let contrastEnd = doubleArrayPointBlocks[index_i + 1, index_j + 1]
                            if ex >= contrastStart.x && ex <= contrastEnd.x && ey >= contrastStart.y && ey <= contrastEnd.y{
                                
                                secondBlockX = index_i
                                secondBlockY = index_j
                                
                                limBool = true
                            }
                        }
                    }
                }
                if !doubleArrayChooseBlocks[secondBlockX, secondBlockY] && limBool{
                    
                    if doubleArrayBoolBlocks[secondBlockX, secondBlockY]{
                        flagSecond = true
                        print("second, \(ex), \(ey)")
                    }
                }
            }
            if !flagFirst{
                
                var limBool: Bool = false
                
                firstPoint = recognizer.locationInView(self.grayView)
                sx = firstPoint.x
                sy = firstPoint.y
                
                for index_i in 0...5{
                    for index_j in 0...5{
                        
                        if doubleArrayBoolBlocks[index_i, index_j]{
                            
                            let contrastStart = doubleArrayPointBlocks[index_i, index_j]
                            let contrastEnd = doubleArrayPointBlocks[index_i + 1, index_j + 1]
                            if sx >= contrastStart.x && sx <= contrastEnd.x && sy >= contrastStart.y && sy <= contrastEnd.y{
                                
                                firstBlockX = index_i
                                firstBlockY = index_j
                                limBool = true
                            }
                        }
                    }
                }
                
                if limBool{
                    if doubleArrayBoolBlocks[firstBlockX,firstBlockY]{
                        doubleArrayChooseBlocks[firstBlockX, firstBlockY] = true
                        flagFirst = true
                        print("first, \(sx), \(sy)")
                    }
                }
            }
            
            //MARK: get the firstBlock and secondBlock
            if flagFirst && flagSecond{
                
                recognizer.numberOfTapsRequired = 2
                
                swipeUp.enabled = true
                swipeDown.enabled = true
                swipeLeft.enabled = true
                swipeRight.enabled = true
                
                doubleArrayChooseBlocks[firstBlockX, firstBlockY] = false
            }
        }
            
        else if recognizer.numberOfTapsRequired == 2{
            
            recognizer.numberOfTapsRequired = 1
            
            swipeUp.enabled = false
            swipeDown.enabled = false
            swipeLeft.enabled = false
            swipeRight.enabled = false
            
            flagFirst = false
            flagSecond = false
            
            NSLog("rechoose")
            
//            firstBlockX = -1
//            firstBlockY = -1
//            secondBlockX = -1
//            secondBlockY = -1
            
//            sx = 0.0
//            sy = 0.0
//            ex = 0.0
//            ey = 0.0
        }
    }
    
    func handleDoubleFingerEvent(recognizer: UITapGestureRecognizer){
        
        if recognizer.numberOfTapsRequired == 1{
            
        }else if recognizer.numberOfTapsRequired == 2{
            
        }
    }
}

