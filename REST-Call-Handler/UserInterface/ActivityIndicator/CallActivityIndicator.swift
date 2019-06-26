/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallActivityIndicator.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit


//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        final class CallActivityIndicator
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
final class CallActivityIndicator {
    fileprivate static var activityIndicator    : UIActivityIndicatorView?
    fileprivate static var style                : UIActivityIndicatorView.Style = .whiteLarge
    fileprivate static var baseBackColor        : UIColor                       = UIColor( white : 0, alpha : 0.6 )
    fileprivate static var baseColor            : UIColor                       = UIColor.white
    
    //***************************************************************
    //***************        func reset()
    //***************************************************************
    func reset() {
        stop()
    }  // func reset()
    
    //***************************************************************
    //***************        public static func start
    //***************************************************************
    func start(   from view       : UIView,
                  style           : UIActivityIndicatorView.Style = CallActivityIndicator.style,
                  backgroundColor : UIColor                       = CallActivityIndicator.baseBackColor,
                  baseColor       : UIColor                       = CallActivityIndicator.baseColor ) {
        
        guard CallActivityIndicator.activityIndicator == nil else { return }
        
        let callactivityindicator                                         = UIActivityIndicatorView( style: style )
        callactivityindicator.backgroundColor                             = backgroundColor
        callactivityindicator.color                                       = baseColor
        callactivityindicator.translatesAutoresizingMaskIntoConstraints   = false
        view.addSubview( callactivityindicator )
        
        // Auto-layout constraints
        addConstraints( to : view, with : callactivityindicator )
        
        CallActivityIndicator.activityIndicator                           = callactivityindicator
        CallActivityIndicator.activityIndicator?.startAnimating()
    }  //public static func start
    
    //***************************************************************
    //***************        public static func stop()
    //***************************************************************
    func stop() {
        CallActivityIndicator.activityIndicator?.stopAnimating()
        CallActivityIndicator.activityIndicator?.removeFromSuperview()
        CallActivityIndicator.activityIndicator = nil
    }  //public static func stop()
    
    //***************************************************************
    //***************        fileprivate static func addConstraints
    //***************************************************************
    func addConstraints(to view: UIView, with spinner: UIActivityIndicatorView) {
        spinner.topAnchor.constraint(       equalTo : view.topAnchor     ).isActive = true
        spinner.trailingAnchor.constraint(  equalTo : view.trailingAnchor).isActive = true
        spinner.bottomAnchor.constraint(    equalTo : view.bottomAnchor  ).isActive = true
        spinner.leadingAnchor.constraint(   equalTo : view.leadingAnchor ).isActive = true
    }  // fileprivate static func addConstraints
    
}  // final class CallActivityIndicator


//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallActivityIndicator.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
