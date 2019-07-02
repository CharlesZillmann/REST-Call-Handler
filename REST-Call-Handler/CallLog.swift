/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallLog.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

// PURPOSE: CallLog is a class to accumulate log messages from all the threads and return them to the UI for display
//          Implementing the gMsgLogDelegate protocol will allow you to be notified everytime a new message is logged

import Foundation

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        var gMsgLog
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************

var gMsgLog : CallLog = CallLog()

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        protocol gMsgLogDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************

protocol gMsgLogDelegate {
    func newMsgLogged()
}  // protocol gMsgLogDelegate

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallLog
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class CallLog {
    //***************************************************************
    //***************        var gMsgLog
    //*****************************-**********************************
    //Array of Strings to log messages
    var lgMsgLog    : [String]          = []
    var lgDelegate  : gMsgLogDelegate?  = nil
    
    //***************************************************************
    //***************        func gLog( msg : String )
    //***************************************************************
    //Adds a message to the var gMsgLog
    func Log( msg : String ) {
        lgMsgLog.append( msg )
        DispatchQueue.main.async {
            self.lgDelegate?.newMsgLogged()
        }  // DispatchQueue.main.async
    } //func gLog( msg : String )
    
    //***************************************************************
    //***************        func ClearLog()
    //***************************************************************
    func ClearLog() {
        lgMsgLog.removeAll()
        DispatchQueue.main.async {
            self.lgDelegate?.newMsgLogged()
        }  // DispatchQueue.main.async
    }  // func ClearLog()
    
    //***************************************************************
    //***************        func LogAsText() -> String
    //***************************************************************
    func LogAsText() -> String {
        return lgMsgLog.joined(separator: "\n")
    }  // func LogAsText() -> String
    
}  // class CallLog


//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallLog.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
