/*************************************************************************
 MIT License
 
 Copyright (c) 2019  GroupProgressIndicator.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class GroupProgressIndicator : UIView
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************

class GroupProgressIndicator : UIView {
    
    // States
    enum ProgressStates : String {
        case Ready          = "Ready"
        case Processing     = "Processing"
        case Complete       = "Complete"
    }  // enum ProgressStates
    
    private var lgPercent               : Int               = 0 {
        
        didSet{
            if lgPercent >= 100 {
                lgPercent = 100
            } else if lgPercent < 0 {
                lgPercent = 0
            } // if progressConstant
        }  // didSet
        
    }  // private var lgPercent
    
    private var lgState                 : ProgressStates    = ProgressStates.Ready
    
    private var layoutDone      : Bool              = false
    private var mainLabel       : UILabel           = UILabel()
    private var stateLabel      : UILabel           = UILabel()
    private let foregroundLayer : CAShapeLayer      = CAShapeLayer()
    private let backgroundLayer : CAShapeLayer      = CAShapeLayer()
    
    //***************************************************************
    //***************        private var radius: CGFloat
    //***************************************************************
    private var radius : CGFloat {
        
        get {
            
            if self.frame.width < self.frame.height {
                return ( self.frame.width - lineWidth )/2
            } else {
                return ( self.frame.height - lineWidth )/2
            }  // if self.frame.width < self.frame.height
            
        }  // get
        
    }  // private var radius: CGFloat
    
    //***************************************************************
    //***************        private var pathCenter : CGPoint
    //***************************************************************
    private var pathCenter : CGPoint {
        
        get {
            return self.convert( self.center, from : self.superview )
        }  // get
        
    }  // private var pathCenter : CGPoint
    
    //***************************************************************
    //***************        public var lineWidth
    //***************************************************************
    public var lineWidth : CGFloat = 3 {
        
        didSet {
            
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - ( 0.20 * lineWidth )
            
        }  // didSet
        
    }  // public var lineWidth
    
    //***************************************************************
    //***************        public var labelSize
    //***************************************************************
    public var mainLabelSize : CGFloat = 10 {
        
        didSet {
            
            mainLabel.font  = UIFont.systemFont( ofSize: mainLabelSize )
            mainLabel.sizeToFit()
            configLabels()
            
        }  // didSet
        
    }  // public var labelSize
    
    //***************************************************************
    //***************        public var labelSize
    //***************************************************************
    public var stateLabelSize : CGFloat = 8 {
        
        didSet {
            
            stateLabel.font  = UIFont.systemFont( ofSize: stateLabelSize )
            stateLabel.sizeToFit()
            configLabels()
            
        }  // didSet
        
    }  // public var labelSize
    
    //***************************************************************
    //***************        public var safePercen
    //***************************************************************
    public var safePercent: Int = 100 {
        
        didSet {
            
            setForegroundLayerColorForSafePercent()
            
        }  // didSet
        
    }  // public var safePercen
    
    //***************************************************************
    //***************        func reset()
    //***************************************************************
    func reset() {
        //variables
        lgPercent       = 0
        lgState         = ProgressStates.Ready
        
        //UI Components
        mainLabel.text  = "0"
        stateLabel.text = lgState.rawValue
        
        //Progress
        setProgress( percent : 0, withAnimation : false )
        
    }  // func reset()
    
    //***************************************************************
    //***************        override func awakeFromNib
    //***************************************************************
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupView()
        reset()
        
    }  // override func awakeFromNib
    
    //***************************************************************
    //***************        override func layoutSublayers( of layer : CALayer )
    //***************************************************************
    override func layoutSublayers( of layer : CALayer ) {
        
        if !layoutDone {
            setupView()
            layoutDone          = true
        }  // if !layoutDone
        
    }  // override func layoutSublayers( of layer : CALayer )
    
    //***************************************************************
    //***************        public func setProgress( percent : Int, withAnimation : Bool )
    //***************************************************************
    public func setProgress( percent : Int, withAnimation : Bool ) {
    
        lgPercent = percent

        if withAnimation {
            foregroundLayer.strokeEnd   = CGFloat( lgPercent/100 )

            let myDuration : Double = 1.0
            let animation           = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue     = 0
            animation.toValue       = lgPercent
            animation.duration      = myDuration
            foregroundLayer.add( animation, forKey: "foregroundAnimation" )

        }  else {
            CATransaction.begin()
            CATransaction.setValue( true, forKey: kCATransactionDisableActions)
            
            foregroundLayer.strokeEnd   = CGFloat( lgPercent/100 )
            
            CATransaction.commit()
        } // if withAnimation
        

        self.mainLabel.text     = "\( self.lgPercent )%"
        
        if self.lgPercent >= 100 {
            self.stateLabel.text    = ProgressStates.Complete.rawValue
        } else if self.lgPercent == 0 {
            self.stateLabel.text    = ProgressStates.Ready.rawValue
        } else {
            self.stateLabel.text    = ProgressStates.Processing.rawValue
        }  //if self.lgPercent
        
        self.setForegroundLayerColorForSafePercent()
        self.adjustLabels()
        
    }  // public func setProgress( percent : Int, withAnimation : Bool )
    
    //***************************************************************
    //***************        private func setupView()
    //***************************************************************
    private func setupView() {
        
        makeBar()
        configLabels()
        self.addSubview( mainLabel )
        self.addSubview( stateLabel )
        
    }  // private func setupView()
    
    //***************************************************************
    //***************        private func configLabel()
    //***************************************************************
    private func configLabels() {
        
        mainLabel.font          = UIFont.systemFont( ofSize: mainLabelSize )
        stateLabel.font         = UIFont.systemFont( ofSize: stateLabelSize )
        adjustLabels()
        
    }  // private func configLabel()

    //***************************************************************
    //***************        private func configLabel()
    //***************************************************************
    private func adjustLabels() {
        
        mainLabel.sizeToFit()
        stateLabel.sizeToFit()

        mainLabel.center       = CGPoint( x : pathCenter.x, y : pathCenter.y - ( mainLabel.frame.height * 0.2 ) )
        stateLabel.center      = CGPoint( x : pathCenter.x, y : ( mainLabel.frame.minY + mainLabel.frame.height * 1.3 ) )
        
    }  // private func configLabel()
    
    //***************************************************************
    //***************        private func makeBar()
    //***************************************************************
    private func makeBar() {
        
        self.layer.sublayers    = nil
        drawBackgroundLayer()
        drawForegroundLayer()
        
    }  // private func makeBar()
    
    //***************************************************************
    //***************        private func setForegroundLayerColorForSafePercent()
    //***************************************************************
    private func setForegroundLayerColorForSafePercent() {
        
        //if Int( mainLabel.text! )! >= self.safePercent {
        if self.lgPercent >= self.safePercent {
            
            self.foregroundLayer.strokeColor    = UIColor.green.cgColor
            
        } else {
            
            self.foregroundLayer.strokeColor    = UIColor.red.cgColor
            
        }  // if
        
    }  // private func setForegroundLayerColorForSafePercent()
    
    //***************************************************************
    //***************        private func drawBackgroundLayer()
    //***************************************************************
    private func drawBackgroundLayer() {
        
        let path = UIBezierPath( arcCenter  : pathCenter,
                                 radius     : self.radius,
                                 startAngle : 0,
                                 endAngle   : 2 * CGFloat.pi,
                                 clockwise  : true )
        
        self.backgroundLayer.path           = path.cgPath
        self.backgroundLayer.strokeColor    = UIColor.lightGray.cgColor
        self.backgroundLayer.lineWidth      = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor      = UIColor.clear.cgColor
        
        self.layer.addSublayer( backgroundLayer )
        
    }  // private func drawBackgroundLayer()
    
    //***************************************************************
    //***************        private func drawForegroundLayer()
    //***************************************************************
    private func drawForegroundLayer() {
        
        let startAngle  = ( -CGFloat.pi/2 )
        let endAngle    = 2 * CGFloat.pi + startAngle
        
        let path        = UIBezierPath( arcCenter   : pathCenter,
                                        radius      : self.radius,
                                        startAngle  : startAngle,
                                        endAngle    : endAngle,
                                        clockwise   : true )
        
        foregroundLayer.lineCap     = CAShapeLayerLineCap.round
        foregroundLayer.path        = path.cgPath
        foregroundLayer.lineWidth   = lineWidth
        foregroundLayer.fillColor   = UIColor.clear.cgColor
        foregroundLayer.strokeColor = UIColor.red.cgColor
        foregroundLayer.strokeEnd   = 0
        
        self.layer.addSublayer( foregroundLayer )
        
    }  // private func drawForegroundLayer()
    

    
}  // class GroupProgressIndicator : UIView


//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END GroupProgressIndicator.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************

