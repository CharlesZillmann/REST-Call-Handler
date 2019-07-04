//
//  CallTableViewCell.swift
//  REST-Call-Handler
//
//  Created by Charles Zillmann on 6/24/19.
//  Copyright © 2019 Charles Zillmann. All rights reserved.
//

import Foundation

/*************************************************************************
 *
 * CHARLES ZILLMANN CONFIDENTIAL
 * _____________________________
 *
 *  Blueprint Beta
 *
 *  Created by Charles Zillmann on 11/27/17.
 *  Copyright © 2017 Charles Zillmann. All rights reserved.
 *
 *  [2017] - [PRESENT] Charles Zillmann charles.zillmann@gmail.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of CHARLES ZILLMANN.  The intellectual and technical
 * concepts contained herein are proprietary to CHARLES ZILLMANN
 * and may be covered by U.S. and Foreign Patents, patents in process,
 * and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from CHARLES ZILLMANN.
 */

//Start by subclassing UITableViewCell to customize your cell, and leave your view controller immaculate of view styling code.
//
//Override initWithStyle:reuseIdentifier: to do whatever you have to do to customize your view, and…
//
//…at this point, be sure to also set a custom selectedBackgroundView.
//(If you just need a color, paint an empty view’s background***. If you need something more complex, go for it as well :P)
//
//Override setSelected:animated: and setHighlighted:animated: in order to customize other views (such as UITableViewCell’s textLabel or imageView) in your cell to match your background styling.
//
//You are done.

import UIKit

//*******************************************************************************************
//*******************************************************************************************
//***************        class CallTableViewCell
//*******************************************************************************************
//*******************************************************************************************
class CallTableViewCell : UITableViewCell {

    let lgIndexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont( ofSize: 14 )
        label.textAlignment = .right
        return label
    }()
    
    let lgNameLabel: UILabel = {
        let label           = UILabel()
        label.font          = .systemFont(ofSize: 12)
        label.textColor     = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    let lgDetailLabel: UILabel = {
        let label           = UILabel()
        label.font          = .systemFont(ofSize: 9)
        label.textColor     = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    let lgStateLabel : UILabel = {
        let label           = UILabel()
        label.font          = UIFont.italicSystemFont( ofSize: 8 )
        label.textColor     = UIColor.lightGray
        label.textAlignment = .right
        label.frame         = CGRect( x : 0, y : 0, width : 100, height : 12 )
        return label
    }()
    
    let lgActivityView : UIActivityIndicatorView = {
        let myView      = UIActivityIndicatorView()
        myView.style    = UIActivityIndicatorView.Style.gray
        myView.frame    = CGRect( x : 0, y : 0, width : 40, height : 40 )
        return myView
    }()
    
    let lgResultsButton : UIButton = {
        let myBtn                       = UIButton()
        myBtn.frame                     = CGRect( x : 0, y : 0, width : 100, height : 12 )
        return myBtn
    }()
    
    let gradientLayer : CAGradientLayer = {
        let myLayer         = CAGradientLayer()
        myLayer.colors      = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        myLayer.startPoint  = CGPoint(x: 0, y: 0)
        myLayer.endPoint    = CGPoint(x: 0, y: 1)
        return myLayer
    }()
    
    //***************************************************************
    //***************        required init?
    //***************************************************************
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }  //required init?
    
    //***************************************************************
    //***************        override init
    //***************************************************************
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        prepareForReuse()
    }  //override init
    
    //***************************************************************
    //***************        public override func updateConstraints
    //***************************************************************
    public override func updateConstraints() {
        layoutSubviews()
        super.updateConstraints()
    }  //public override func updateConstraints
    
    //***************************************************************
    //***************        override func prepareForReuse
    //***************************************************************
    override func prepareForReuse() {
        self.contentView.clipsToBounds              = false
        self.clipsToBounds                          = false
        super.prepareForReuse()
        SetCallCellState()
        lgIndexLabel.text   = ""
        lgNameLabel.text    = ""
        lgDetailLabel.text  = ""
        lgStateLabel.text   = ""
    }  //override func prepareForReuse
    
    //***************************************************************
    //***************            func SetCallCellState( cell : CallTableViewCell, state : CallGroup.CallStates )
    //***************************************************************
    func SetCallCellState( state : CallGroup.CallStates? = nil ) {
        
        if let myState = state {
            
            self.lgStateLabel.text          = myState.rawValue
            self.lgStateLabel.sizeToFit()
            self.layoutSubviews()
            
            switch myState {
            case .Queued:
                
                if self.lgActivityView.isAnimating {
                    self.lgActivityView.stopAnimating()
                }  // if !cell.lgActivityView.isAnimating
                self.lgStateLabel.textColor =   UIColor.black
                
            case .Waiting:
                
                if !self.lgActivityView.isAnimating {
                    self.lgActivityView.startAnimating()
                }  // if !cell.lgActivityView.isAnimating
                self.lgStateLabel.textColor = UIColor.yellow
                
            case .Executing:
                
                if !self.lgActivityView.isAnimating {
                    self.lgActivityView.startAnimating()
                }  // if !cell.lgActivityView.isAnimating
                self.lgStateLabel.textColor  = UIColor.green
                
            case .Complete:
                
                if self.lgActivityView.isAnimating {
                    self.lgActivityView.stopAnimating()
                }  // if !cell.lgActivityView.isAnimating
                self.lgStateLabel.textColor = UIColor.black
                
            }  // switch state
        } else {
            
            self.lgStateLabel.text          = ""
            self.lgStateLabel.sizeToFit()
            self.layoutSubviews()
            if self.lgActivityView.isAnimating {
                self.lgActivityView.stopAnimating()
            }  // if !cell.lgActivityView.isAnimating
            self.lgStateLabel.textColor =   UIColor.black
        }
        
    }  // func SetCallCellState( cell : CallTableViewCell, state : CallGroup.CallStates )
    
    //***************************************************************
    //***************        override func layoutSubviews
    //***************************************************************
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.bounds

        let myCMG = layoutMarginsGuide
        
        let myTop : CGFloat     = 6

        lgIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        lgIndexLabel.leadingAnchor.constraint   (   equalTo : myCMG.leadingAnchor,          constant: 0     ).isActive = true
        lgIndexLabel.topAnchor.constraint       (   equalTo : myCMG.topAnchor,              constant: myTop ).isActive = true
        lgIndexLabel.widthAnchor.constraint     (   equalToConstant : 40).isActive = true

        lgNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lgNameLabel.leadingAnchor.constraint    (   equalTo : lgIndexLabel.trailingAnchor,  constant: 10    ).isActive = true
        lgNameLabel.topAnchor.constraint        (   equalTo : myCMG.topAnchor,              constant: myTop ).isActive = true
        lgNameLabel.trailingAnchor.constraint   (   equalTo : myCMG.trailingAnchor,         constant: -40   ).isActive = true

        lgDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        lgDetailLabel.leadingAnchor.constraint  (   equalTo : lgIndexLabel.trailingAnchor,  constant: 10    ).isActive = true
        lgDetailLabel.topAnchor.constraint      (   equalTo : myCMG.topAnchor,              constant: myTop + 24 ).isActive = true
        lgDetailLabel.trailingAnchor.constraint (   equalTo : myCMG.trailingAnchor,         constant: -40   ).isActive = true

        lgStateLabel.sizeToFit()
        lgStateLabel.translatesAutoresizingMaskIntoConstraints = false
        lgStateLabel.topAnchor.constraint       (   equalTo : myCMG.topAnchor,              constant: 0   ).isActive = true
        lgStateLabel.trailingAnchor.constraint  (   equalTo : myCMG.trailingAnchor,         constant: 0   ).isActive = true

        lgActivityView.translatesAutoresizingMaskIntoConstraints = false
        lgActivityView.leadingAnchor.constraint (   equalTo : myCMG.trailingAnchor,         constant: -lgActivityView.frame.width ).isActive = true
        lgActivityView.topAnchor.constraint     (   equalTo : myCMG.bottomAnchor,           constant: lgActivityView.frame.height ).isActive = true
        lgActivityView.trailingAnchor.constraint(   equalTo : myCMG.trailingAnchor,         constant: 0     ).isActive = true

    }  //override func layoutSubviews
    
    //***************************************************************
    //*********   func addViews
    //***************************************************************
    func addViews(){
        layer.addSublayer(gradientLayer)
        addSubview(lgIndexLabel)
        addSubview(lgNameLabel)
        addSubview(lgDetailLabel)
        addSubview(lgStateLabel)
        addSubview(lgActivityView)
        addSubview(lgResultsButton)
    }  //func addViews
    //**************************************Coding Standard END*********************************************
    
}  //class CallTableViewCell

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallTableViewCell.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************

