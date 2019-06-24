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
    //var lgSpinner           : CallActivityIndicator         = CallActivityIndicator()

    let lgIndexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont( ofSize: 14 )
        label.textAlignment = .right
        return label
    }()
    
    let lgNameLabel: UILabel = {
        let label           = UILabel()
        label.font          = .systemFont(ofSize: 16)
        label.textColor     = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    let lgDetailLabel: UILabel = {
        let label           = UILabel()
        label.font          = .systemFont(ofSize: 12)
        label.textColor     = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    let lgActivityView: UIActivityIndicatorView = {
        let myView              = UIActivityIndicatorView()
        myView.frame    = CGRect( x : 0, y : 0, width : 40, height : 40 )
        return myView
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
    }  //override func prepareForReuse
    
    //***************************************************************
    //***************        override func layoutSubviews
    //***************************************************************
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let myCMG = layoutMarginsGuide
        
        let myTop : CGFloat     = 6

        lgIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        lgIndexLabel.leadingAnchor.constraint(  equalTo: myCMG.leadingAnchor,   constant: 0     ).isActive = true
        lgIndexLabel.topAnchor.constraint(      equalTo: myCMG.topAnchor,       constant: myTop ).isActive = true
        lgIndexLabel.widthAnchor.constraint( equalToConstant: 40).isActive = true

        lgNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lgNameLabel.leadingAnchor.constraint(   equalTo: lgIndexLabel.trailingAnchor,   constant: 10 ).isActive = true
        lgNameLabel.topAnchor.constraint(       equalTo: myCMG.topAnchor,               constant: myTop ).isActive = true
        lgNameLabel.trailingAnchor.constraint(  equalTo: myCMG.trailingAnchor,          constant: -40 ).isActive = true

        lgDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        lgDetailLabel.leadingAnchor.constraint( equalTo: lgIndexLabel.trailingAnchor,   constant: 10 ).isActive = true
        lgDetailLabel.topAnchor.constraint(     equalTo: myCMG.topAnchor,               constant: myTop + 24 ).isActive = true
        lgDetailLabel.trailingAnchor.constraint(equalTo: myCMG.trailingAnchor,          constant: -40 ).isActive = true

        lgActivityView.translatesAutoresizingMaskIntoConstraints = false
        lgActivityView.leadingAnchor.constraint(equalTo: myCMG.trailingAnchor,          constant: -40 ).isActive = true
        lgActivityView.topAnchor.constraint(    equalTo: myCMG.topAnchor,               constant: myTop ).isActive = true
        lgActivityView.widthAnchor.constraint(  equalToConstant: 40 ).isActive = true
        lgActivityView.heightAnchor.constraint(  equalToConstant: 40 ).isActive = true

    }  //override func layoutSubviews
    
    //***************************************************************
    //*********   func addViews
    //***************************************************************
    func addViews(){
        addSubview(lgIndexLabel)
        addSubview(lgNameLabel)
        addSubview(lgDetailLabel)
        addSubview(lgActivityView)
    }  //func addViews
    //**************************************Coding Standard END*********************************************
    
}  //class MasterTableViewCell

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallTableViewCell.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************

