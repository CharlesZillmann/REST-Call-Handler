/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallOutcomes.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class OptionsCallOutcomes : CallOutcomes {
}  //class OptionsCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class GetCallOutcomes : CallOutcomes {
}  //class GetCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class HeadCallOutcomes : CallOutcomes {
}  //class HeadCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class PostCallOutcomes : CallOutcomes {
    var httpBodyJSONData            : Data?     = nil
    var jsonCreationError           : String?   = nil
}  //class PostCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class PutCallOutcomes : CallOutcomes {
    var httpBodyJSONData            : Data?     = nil
    var jsonCreationError           : String?   = nil
}  //class PutCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class PatchCallOutcomes : CallOutcomes {
    var httpBodyJSONData            : Data?     = nil
    var jsonCreationError           : String?   = nil
}  //class PatchCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class DeleteCallOutcomes : CallOutcomes {
}  //class DeleteCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class UndefCallOutcomes : CallOutcomes {
}  //class UndefinedCallOutcomes : CallOutcomes

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallOutcomes
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class CallOutcomes {
    var UsersTag                    : String?           = nil       // This little piece of context info through the entire call lifecycle
    var TaskUUIDString              : String?           = nil       // This UUID is identifies the original CallTask
    var urlResponse                 : URLResponse?      = nil       // The URL Response from the network Request
    //var httpURLResponse             : HTTPURLResponse?  = nil
    var responseData                : Data?             = nil       //4) let task = session.dataTask(with: urlRequest) -> data
    
    //***************************************************************
    // Timestamps:
    // In order of capture:
    //          CallStartTime -> CallEndTime -> CallProcStartTime -> CallUserProcStartTime -> CallProcEndTime
    // First:   The Call Starts and Ends.
    //          ( So, the call took (CallEndTime - CallStartTime) on the network )
    // Second:  Processing Starts within the CallHandler Class
    //          ( So, the CallHandler took (CallUserProcStartTime - CallEndTime) pre-processing the outcome )
    // Third:   The Call Handler Class Yields Processing to the CallHandlerUser Class via a delegate.
    //          ( So, the CallHandlerUser took (CallProcEndTime - CallUserProcStartTime) processing the outcome )
    // Fourth:  The CallHandlerUser Class completes processing and returns control to the call handler where the CallProcEndTime is captured
    //          ( So, this call is fully done with the async network request, CallHandler outcome pre-processing, CallHandlerUser outcome processing at... CallProcEndTime )
    //***************************************************************
    
    var CallStartTime               : timeval           = timeval(tv_sec: 0, tv_usec: 0)        // timestamp for the start of a call
    var CallEndTime                 : timeval           = timeval(tv_sec: 0, tv_usec: 0)        // timestamp for the end of a call
    var CallProcStartTime           : timeval           = timeval(tv_sec: 0, tv_usec: 0)
    var CallUserProcStartTime       : timeval           = timeval(tv_sec: 0, tv_usec: 0)
    var CallProcEndTime             : timeval           = timeval(tv_sec: 0, tv_usec: 0)
    
    var urlCreationError            : String?   = nil  // 1) guard let url = URL(string: theEndpoint)
    {
        didSet{
            if let myValue = urlCreationError {
                let myMsg = String (
                    """
                    \n**** ERROR LOGGED Task: \(GetUUIDString())
                    UsersTag: \(UsersTag)
                    urlCreationError  : \(myValue)
                    ********\n
                    """
                )  //mySummary = String
                
                gMsgLog.Log(msg: myMsg )
            }  //if let myValue = urlCreationError
        }  //didSet
    }  // var urlCreationError            : String?   = nil
    
    var dataTaskError               : String?   = nil  //2) guard error == nil
    {
        didSet{
            if let myValue = dataTaskError {
                let myMsg = String (
                    """
                    \n**** ERROR LOGGED Task: \(GetUUIDString())
                    UsersTag: \(UsersTag)
                    dataTaskError  : \(myValue)
                    ********\n
                    """
                )  //mySummary = String
                
                gMsgLog.Log(msg: myMsg )
            }  //if let myValue = dataTaskError
        }  //didSet
    }  // var dataTaskError            : String?   = nil
    
    var responseDataError           : String?   = nil  //3) guard let responseData = data
    {
        didSet{
            if let myValue = responseDataError {
                let myMsg = String (
                    """
                    \n**** ERROR LOGGED Task: \(GetUUIDString())
                    UsersTag: \(UsersTag)
                    responseDataError  : \(myValue)
                    ********\n
                    """
                )  //mySummary = String
                
                gMsgLog.Log(msg: myMsg )
            }  //if let myValue = responseDataError
        }  //didSet
    }  // var responseDataError            : String?   = nil
    
    //***************************************************************
    //***************        func GetUUIDString() -> String
    //***************************************************************
    func GetUUIDString() -> String {
        var myTaskUUIDString    : String = ""
        
        if let myUUIDString = TaskUUIDString {
            myTaskUUIDString = myUUIDString
        }  //  if let myUUIDString = TaskUUIDString
        
        return myTaskUUIDString
    }  //func GetUUIDString() -> String
    
    //***************************************************************
    //***************        func DiffTimeVal(tvalBefore : timeval, tvalAfter : timeval ) -> String
    //***************************************************************
    func DiffTimeVal(tvalBefore : timeval, tvalAfter : timeval ) -> String {
        let myTime = "\( ( (tvalAfter.tv_sec - tvalBefore.tv_sec) * 1000000 + Int(tvalAfter.tv_usec)) - Int(tvalBefore.tv_usec) )"
        return myTime
    }  //func DiffTimeVal
    
    //***************************************************************
    //***************        func Summary() -> String
    //***************************************************************
    func Summary() -> String {
        var mySummary           : String = ""
        var myTaskUUIDString    : String = ""
        var myDataAsString      : String = ""
        var myURLStatusCode     : String = ""
        //var myHTTPStatusCode    : String = ""
        
        if let myUUIDString = TaskUUIDString {
            myTaskUUIDString = myUUIDString
        }  //  if let myUUIDString = TaskUUIDString
        
        if let myURLResponse = urlResponse as? HTTPURLResponse {
            myURLStatusCode = myURLResponse.statusCode.description
        }  //  if let myURLResponse = urlResponse
        
        if let myResponseData = responseData {
            myDataAsString = String(decoding: myResponseData, as: UTF8.self)
        }  //  if let myResponseData = responseData
        
        let myCallTime = DiffTimeVal( tvalBefore: CallStartTime, tvalAfter: CallEndTime )
        let myProcTime = DiffTimeVal( tvalBefore: CallProcStartTime, tvalAfter: CallUserProcStartTime )
        let myUserTime = DiffTimeVal( tvalBefore: CallUserProcStartTime, tvalAfter: CallProcEndTime )
        
        mySummary = String (
            """
            \n**** CallOutcomes Task: \(myTaskUUIDString)
            UsersTag: \(UsersTag)
            Call: \(myCallTime) usec, Proc: \(myProcTime) usec, User: \(myUserTime) usec\n
            urlCreationError  : \(urlCreationError)
            dataTaskError     : \(dataTaskError)
            responseDataError : \(responseDataError)
            URLStatusCode     : \(myURLStatusCode)
            The data is: \(myDataAsString)
            ********\n
            """
        )  //mySummary = String
        
        return mySummary
    }  // func Summary() -> String
    
}  // class CallOutcomes

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallOutcomes.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
