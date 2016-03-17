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
import CoreData


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //how many blocks the blocks slide onece, 2 or 3...
    let numberBlocksSlideOnce: Int = 2
    
    let game11: [Int] =
       [0,0,1,1,0,0,
        0,1,0,0,1,0,
        1,0,0,0,0,1,
        1,0,0,0,0,1,
        0,1,0,0,1,0,
        0,0,1,1,0,0]
    
    let game12: [Int] =
       [0,0,0,0,0,0,
        0,1,1,1,1,0,
        1,0,0,0,0,1,
        1,0,0,0,0,1,
        0,1,1,1,1,0,
        0,0,0,0,0,0]
    
    let game13: [Int] =
       [0,0,0,0,0,1,
        1,1,1,1,1,1,
        1,0,0,0,0,0,
        1,0,0,0,0,0,
        1,0,0,0,1,0,
        1,0,0,0,0,0]
    
    var game: [[Int]] = []
    
    func add(){
        game.append(game11)
        game.append(game12)
        game.append(game13)
    }
    
    var level: Int!
    
    var BlocksPositionXY: [CGPoint] = []
    
    var doubleArrayNumberBlcoks = DoubleDimensionalArrayInt(rows: 100, columns: 100)
    var doubleArrayBoolBlocks = DoubleDimensionalArrayBool(rows: 100, columns: 100)
    var doubleArrayPointBlocks = DoubleDimensionalArrayPoint(rows: 100, columns: 100)
    var doubleArrayChooseBlocks = DoubleDimensionalArrayBool(rows: 100, columns: 100)
    
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
    
    //tap gesture
    var tapSingleFinger = UITapGestureRecognizer()
    var tapDoubleFinger = UITapGestureRecognizer()

    //the move Event use
    var firstBlockX: Int = -1
    var firstBlockY: Int = -1
    var secondBlockX: Int = -1
    var secondBlockY: Int = -1
    var num1: Int = -1
    var num2: Int = -1
    var num3: Int = -1
    var num4: Int = -1
    
    var firstTimeToMove = true
    
    //MARK: coreData
    var managedContext: NSManagedObjectContext!
    var markEntity: NSEntityDescription!
    var markFetch: NSFetchRequest!
    
    //the data get from the coreData, the first of the result dictionatry.
    var resultOfMark: NSDictionary!

    var markOfNow: Int = 0
    
    //the method is link the database and get the data.
    func coreDataInit(){
        
        markEntity = NSEntityDescription.entityForName("Mark", inManagedObjectContext: managedContext)
        markFetch = NSFetchRequest(entityName: "Mark")
        
        do {
            
            let result =
                try managedContext.executeFetchRequest(markFetch) as! [NSDictionary]
            
            if result.count > 0{
                resultOfMark = result.first
            }
            
        }catch let error as NSError{
            print("Error: \(error) " +
                "description \(error.localizedDescription)")
        }
    }
    
    
    func allBlocksPoint(){
        
        for index_j in 0...6{
            for index_i in 0...6{
                doubleArrayPointBlocks[index_i, index_j] = CGPoint(x: blockLenght * CGFloat(index_i), y: blockLenght * CGFloat(index_j))
            }
        }
        
    }
    
    //set the location, if there is a block, the doubleArrayBoolBlocks's value if ture.
    func isThereA_Block(){
        
        let levelComplex = level / 10
        let choose = level % 10
        var x = 0
        var y = 0
        if levelComplex == 1{
            let gg = game[choose - 1]
            for i in 0...gg.count - 1{
                if gg[i] == 1{
                    y = i / 6
                    x = i % 6
                    
                    doubleArrayBoolBlocks[x, y] = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("\(level)")
        
        //Obtain the device's screen size, and Set the blocks's side
        getDevicesSize()
        add()
        
        allBlocksPoint()
        
        isThereA_Block()
        
        //create the blocks and drap them in the grayview
        createBlocksToMove(1)

        //call the method: set gesture recognizer attribute
        setGestureAttribute()
    }
    
    //a method of get the device size
    func getDevicesSize(){
        
        let calculateBound: CGFloat = 0.058
        
        let masterX: CGFloat = getTrueLength(true)
        let masterY: CGFloat = getTrueLength(false)

        let boundWide = masterX * calculateBound
        
        grayViewLenght = masterX - boundWide
        grayViewHeight = grayViewLenght
        
        blockLenght = grayViewLenght / 6
        let blockLenghtShrink = blockLenght - 1.0
        
        sizeOfBlocks = CGSize(width: blockLenghtShrink, height: blockLenghtShrink)

        let pointOfBackground = CGPoint(x: boundWide / 2 - 4, y: masterY - grayViewHeight - masterY / 6 - 4)
        let sizeOfBackground = CGSize(width: grayViewLenght + 8, height: grayViewHeight + 8)
        
        //MARK:grayview handing all the blocks
        grayView = UIView(frame: CGRect(origin: pointOfBackground, size: sizeOfBackground))
        grayView.backgroundColor = UIColor.whiteColor()
        
        grayView.layer.masksToBounds = true
        grayView.layer.cornerRadius = 3.0
        view.addSubview(grayView)
        
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

//                    let view2 = UIView(frame: CGRect(origin: doubleArrayPointBlocks[index_i, index_j], size: sizeOfBlocks))
                    let view2 = UIView(frame: CGRect(x: doubleArrayPointBlocks[index_i, index_j].x + 4, y: doubleArrayPointBlocks[index_i, index_j].y + 4, width: sizeOfBlocks.width, height: sizeOfBlocks.height))
                    view2.backgroundColor = UIColor.grayColor()
                    
                    //set corner radius
                    view2.layer.masksToBounds = true
                    view2.layer.cornerRadius = 10.0
                    
                    view2.layer.borderWidth = 0.5
                    view2.layer.borderColor = UIColor.blackColor().CGColor
                    
                    
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
        
        tapSingleFinger.numberOfTouchesRequired = 1
        tapSingleFinger.numberOfTapsRequired = 1
        tapSingleFinger.delegate = self
        tapSingleFinger = UITapGestureRecognizer(target: self, action: Selector("handleSingleFingerEvent:"))
        self.grayView.addGestureRecognizer(tapSingleFinger)
        
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
    
    func exchange(){
        let limX = firstBlockX
        let limY = firstBlockY
        firstBlockX = secondBlockX
        firstBlockY = secondBlockY
        secondBlockX = limX
        secondBlockY = limY
    }
    
    func checkTheBackground(xx: Int, yy: Int) -> Bool{
        
        if doubleArrayBoolBlocks[xx, yy]{
            return true
        }
        return false
    }
    
    func handleTwoBlockMoveEvent(direction: Int){
        
        var allowMove = false
        var changeLenght: CGFloat = blockLenght
        
        if firstTimeToMove{
            
            firstBlockX = Int(BlocksPositionXY[0].x)
            firstBlockY = Int(BlocksPositionXY[0].y)
            secondBlockX = Int(BlocksPositionXY[1].x)
            secondBlockY = Int(BlocksPositionXY[1].y)
            
        }
        
        if !firstTimeToMove{
            firstBlockX = num1
            firstBlockY = num2
            secondBlockX = num3
            secondBlockY = num4
            
        }
            //up
        if direction == 1 && firstBlockY > 0 && secondBlockY > 0{
            
            if firstBlockY < secondBlockY{
                exchange()
            }
            
            changeLenght = -changeLenght

            if firstBlockY - 1 == secondBlockY && firstBlockX == secondBlockX{
                
                if !checkTheBackground(secondBlockX, yy: secondBlockY - 1){
                    allowMove = true
                }
            }else{
                if !checkTheBackground(firstBlockX, yy: firstBlockY - 1) && !checkTheBackground(secondBlockX, yy: secondBlockY - 1){
                    allowMove = true
                }
            }
            if allowMove{
                num1 = firstBlockX
                num2 = firstBlockY - 1
                num3 = secondBlockX
                num4 = secondBlockY - 1
            }
            
            //down
        }else if direction == 2 && firstBlockY < 5 && secondBlockY < 5{
            
            if firstBlockY > secondBlockY{
                exchange()
            }
            
            if firstBlockY + 1 == secondBlockY && firstBlockX == secondBlockX{
                if !checkTheBackground(secondBlockX, yy: secondBlockY + 1){
                    allowMove = true
                }
            }else{
                if !checkTheBackground(firstBlockX, yy: firstBlockY + 1) && !checkTheBackground(secondBlockX, yy: secondBlockY + 1){
                    allowMove = true
                }
            }
            if allowMove{
                num1 = firstBlockX
                num2 = firstBlockY + 1
                num3 = secondBlockX
                num4 = secondBlockY + 1
            }
            //left
        }else if direction == 3 && firstBlockX > 0 && secondBlockX > 0{

            if firstBlockX < secondBlockX{
                exchange()
            }
            
            changeLenght = -changeLenght
            if firstBlockX - 1 == secondBlockX && firstBlockY == secondBlockY{
                if !checkTheBackground(secondBlockX - 1, yy: secondBlockY){
                    allowMove = true
                }
            }else{
                if !checkTheBackground(firstBlockX - 1, yy: firstBlockY) && !checkTheBackground(secondBlockX - 1, yy: secondBlockY){
                    allowMove = true
                }
            }
            if allowMove{
                num1 = firstBlockX - 1
                num2 = firstBlockY
                num3 = secondBlockX - 1
                num4 = secondBlockY
            }
            
            //right
        }else if direction == 4 && firstBlockX < 5 && secondBlockX < 5{
            
            if firstBlockX > secondBlockX{
                exchange()
            }
            
            if firstBlockX + 1 == secondBlockX && firstBlockY == secondBlockY{
                if !checkTheBackground(secondBlockX + 1, yy: secondBlockY){
                    allowMove = true
                }
            }else{
                if !checkTheBackground(firstBlockX + 1, yy: firstBlockY) && !checkTheBackground(secondBlockX + 1, yy: secondBlockY){
                    allowMove = true
                }
            }
            if allowMove{
                num1 = firstBlockX + 1
                num2 = firstBlockY
                num3 = secondBlockX + 1
                num4 = secondBlockY
            }
        }
        if allowMove{
            
            BlocksPositionXY[0] = CGPoint(x: num1, y: num2)
            BlocksPositionXY[1] = CGPoint(x: num3, y: num4)
            
            firstTimeToMove = false
            for subview in grayView.subviews{
                if subview.tag == doubleArrayNumberBlcoks[secondBlockX, secondBlockY]{
                    
                    doubleArrayBoolBlocks[secondBlockX, secondBlockY] = false
                    doubleArrayNumberBlcoks[secondBlockX, secondBlockY] = 0
                    
                    UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        
                        if direction == 1 || direction == 2{
                            subview.frame.origin.y = subview.frame.origin.y + changeLenght
                        }else if direction == 3 || direction == 4{
                            subview.frame.origin.x = subview.frame.origin.x + changeLenght
                        }
                        
                        }, completion: nil)
                    
                    
                    doubleArrayBoolBlocks[num3, num4] = true
                    doubleArrayNumberBlcoks[num3, num4] = subview.tag
                }
            }
            for subview in grayView.subviews{
                if subview.tag == doubleArrayNumberBlcoks[firstBlockX, firstBlockY]{
                    
                    doubleArrayBoolBlocks[firstBlockX, firstBlockY] = false
                    doubleArrayNumberBlcoks[firstBlockX, firstBlockY] = 0
                    
                    UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        
                        if direction == 1 || direction == 2{
                            subview.frame.origin.y = subview.frame.origin.y + changeLenght
                        }else if direction == 3 || direction == 4{
                            subview.frame.origin.x = subview.frame.origin.x + changeLenght
                        }
                        
                        }, completion: nil)
                    
                    
                    doubleArrayBoolBlocks[num1, num2] = true
                    doubleArrayNumberBlcoks[num1, num2] = subview.tag
                }
            }
            
        }
    }
    
    
    func swipe(recognizer: UISwipeGestureRecognizer){

        if recognizer == swipeUp{
            handleTwoBlockMoveEvent(1)
        }else if recognizer == swipeDown{
            handleTwoBlockMoveEvent(2)
        }else if recognizer == swipeLeft{
            handleTwoBlockMoveEvent(3)
        }else{
            handleTwoBlockMoveEvent(4)
        }
    }
    
    
    func findThePositionInt(positionRAW: CGPoint) -> Bool{
        
        for index_i in 0...5{
            for index_j in 0...5{
                
                if doubleArrayBoolBlocks[index_i, index_j] && !doubleArrayChooseBlocks[index_i, index_j]{
                    
                    let contrastStart = doubleArrayPointBlocks[index_i, index_j]
                    let contrastEnd = doubleArrayPointBlocks[index_i + 1, index_j + 1]
                    if positionRAW.x >= contrastStart.x && positionRAW.x <= contrastEnd.x && positionRAW.y >= contrastStart.y && positionRAW.y <= contrastEnd.y{
                        
                        //indicate the block is selected
                        doubleArrayChooseBlocks[index_i, index_j] = true
                        
                        BlocksPositionXY.append(CGPoint(x: index_i, y: index_j))
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    func handleSeletedBlocks(whichBlock: Int, showShadow: Bool){
        
        var point = CGPoint(x: -1, y: -1)

        if whichBlock == 1{
            point = BlocksPositionXY[0]
        }else if whichBlock == 2{
            point = BlocksPositionXY[1]
        }
        
        let blockNum = doubleArrayNumberBlcoks[Int(point.x), Int(point.y)]
        
        for subview in grayView.subviews{
            if subview.tag == blockNum{
                UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                    
                    self.grayView.bringSubviewToFront(subview)
                    
                    if showShadow{
                        subview.frame.origin.x = subview.frame.origin.x - 4.0
                        subview.frame.origin.y = subview.frame.origin.y - 4.0
                    }else{
                        subview.frame.origin.x = subview.frame.origin.x + 4.0
                        subview.frame.origin.y = subview.frame.origin.y + 4.0
                    }
                    /*
                        set the blocks shadow
                    */
                    subview.layer.masksToBounds = !showShadow
                    let shadowPath = UIBezierPath(rect: subview.layer.bounds)
                    subview.layer.shadowOffset = CGSizeMake(5, 5)
                    subview.layer.shadowRadius = 4.0
                    subview.layer.shadowColor = UIColor.blackColor().CGColor
                    subview.layer.shadowOpacity = 0.3
                    subview.layer.shadowPath = shadowPath.CGPath
                    
                    }, completion: nil)
            }
        }
    }
    
    var flagFirst: Bool = false
    var flagSecond: Bool = false
    var flagThird: Bool = false
    
    func handleSingleFingerEvent(recognizer: UITapGestureRecognizer){
        
        if recognizer.numberOfTapsRequired == 1{
            
            let number = self.numberBlocksSlideOnce

            
            let limPosition = recognizer.locationInView(self.grayView)
            //slide two blocks once
            if number == 2{
                
                if !flagFirst{
                    if findThePositionInt(limPosition){
                        flagFirst = true
                        handleSeletedBlocks(1, showShadow: true)
                    }
                }else if flagFirst && !flagSecond{
                    if findThePositionInt(limPosition){
                        flagSecond = true
                        handleSeletedBlocks(2, showShadow: true)
                    }
                }
                if flagFirst && flagSecond {
                    
                    recognizer.numberOfTapsRequired = 2
                    
                    swipeUp.enabled = true
                    swipeDown.enabled = true
                    swipeLeft.enabled = true
                    swipeRight.enabled = true
                    
                    for position in BlocksPositionXY{
                        doubleArrayChooseBlocks[Int(position.x), Int(position.y)] = false
                    }
                }
                
            //slide three blocks once
            }else if number == 3{
                
                
            }
        }else if recognizer.numberOfTapsRequired == 2{
            
            firstTimeToMove = true
            
            recognizer.numberOfTapsRequired = 1
            
            swipeUp.enabled = false
            swipeDown.enabled = false
            swipeLeft.enabled = false
            swipeRight.enabled = false
            
            flagFirst = false
            flagSecond = false
            flagThird = false
            
            handleSeletedBlocks(1, showShadow: false)
            handleSeletedBlocks(2, showShadow: false)
            
            for position in BlocksPositionXY{
                doubleArrayChooseBlocks[Int(position.x), Int(position.y)] = false
            }
            
            BlocksPositionXY = []
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}