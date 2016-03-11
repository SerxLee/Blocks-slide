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
    
    var Blocks: [UIView]!
    
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
    
    
    //test
    var firstBlockX: Int!
    var firstBlockY: Int!

    
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
        
        //create the blocks and drap them in the grayview
        allBlocksPoint()
        
        isThereA_Block()
        
        createBlocksToMove(1)
//        print(Blocks.count)

        
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
        var numOfBlocks: Int = 0
        for index_i in 0...5{
            for index_j in 0...5{
                
                //if the position of the matrix has a block, create a blocks in the position
                if doubleArrayBoolBlocks[index_i, index_j]{

                    let view2 = UIView(frame: CGRect(origin: doubleArrayPointBlocks[index_i, index_j], size: sizeOfBlocks))
                    view2.backgroundColor = UIColor.whiteColor()
                    view2.tag = numOfBlocks + 1
                    
                    //append the block into Blocks, add use the doubleArrayNumberBlcoks to mark blocks' number(numOfBlocks).
                    
                    doubleArrayNumberBlcoks[index_i, index_j] = numOfBlocks + 1
    
                    grayView.addSubview(view2)
                    numOfBlocks++
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
        
        // default is (2) the number of fingers that must swipe
        
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
    }
    
    
    //swipe to move the blocks
    func swipe(recognizer: UISwipeGestureRecognizer){
        
        var selectBlock: UIView

        if recognizer == swipeUp{
            
            selectBlock = judgeBlocksToMove(swipeUp)

            if firstBlockY > 0 && !doubleArrayBoolBlocks[firstBlockX, firstBlockY - 1]{
                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                
                selectBlock.frame.origin.y = selectBlock.frame.origin.y - blockLenght
                doubleArrayBoolBlocks[firstBlockX, firstBlockY - 1] = true
                doubleArrayNumberBlcoks[firstBlockX, firstBlockY - 1] = selectBlock.tag
                print("the \(selectBlock.tag)th move to up")

            }
            
        }else if recognizer == swipeDown{

            selectBlock = judgeBlocksToMove(swipeDown)
            if firstBlockY < 5 && !doubleArrayBoolBlocks[firstBlockX, firstBlockY + 1]{
                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                
                selectBlock.frame.origin.y = selectBlock.frame.origin.y + blockLenght
                doubleArrayBoolBlocks[firstBlockX, firstBlockY + 1] = true
                doubleArrayNumberBlcoks[firstBlockX, firstBlockY + 1] = selectBlock.tag
                print("the \(selectBlock.tag)th move to down")

            }
            
        }else if recognizer == swipeRight{
            
            selectBlock = judgeBlocksToMove(swipeRight)
            if firstBlockX < 5 && !doubleArrayBoolBlocks[firstBlockX + 1, firstBlockY]{
                
                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0

                selectBlock.frame.origin.x = selectBlock.frame.origin.x + blockLenght
                doubleArrayBoolBlocks[firstBlockX + 1, firstBlockY] = true
                doubleArrayNumberBlcoks[firstBlockX + 1, firstBlockY] = selectBlock.tag
                print("the \(selectBlock.tag)th move to right")
            }
        }else if recognizer == swipeLeft{

            selectBlock = judgeBlocksToMove(swipeLeft)
            if firstBlockX > 0 && !doubleArrayBoolBlocks[firstBlockX - 1, firstBlockY]{
                doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                selectBlock.frame.origin.x = selectBlock.frame.origin.x - blockLenght
                
                doubleArrayBoolBlocks[firstBlockX - 1, firstBlockY] = true
                doubleArrayNumberBlcoks[firstBlockX - 1, firstBlockY] = selectBlock.tag
                print("the \(selectBlock.tag)th move to left")

            }
        }
        
    }
    
    
    //judge the block which you want to move, 2 blocks together
    func judgeBlocksToMove(recognizer: UISwipeGestureRecognizer) -> UIView{
        
        let firstBlcok: UIView = UIView()

        
        let swipeStartPoint = recognizer.locationInView(self.grayView)
        let sx = swipeStartPoint.x
        let sy = swipeStartPoint.y
        
//        for index_i in 0...5{
//            for index_j in 0...5{
//                let contrastStart = doubleArrayPointBlocks[index_i, index_j]
//                let contrastEnd = doubleArrayPointBlocks[index_i + 1, index_j + 1]
//            }
//        }
        for index_i in 0...5{
            for index_j in 0...5{
                
                if doubleArrayBoolBlocks[index_i, index_j]{
                    
                    let contrastStart = doubleArrayPointBlocks[index_i, index_j]
                    let contrastEnd = doubleArrayPointBlocks[index_i + 1, index_j + 1]
                    
                    if sx >= contrastStart.x && sx <= contrastEnd.x && sy >= contrastStart.y && sy <= contrastEnd.y{
                        
                        firstBlockX = index_i
                        firstBlockY = index_j
                        break
                    }
                }
            }
        }
        
//        firstBlcok = Blocks[doubleArrayNumberBlcoks[firstBlockX, firstBlockY]]
        
        //check all blcoks' tag, if it is equal the doubleArrayNumberBlcoks' value, return current block
        for limView in grayView.subviews{
            if limView.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY]{
                return limView
            }
        }

        return firstBlcok
    }

}

