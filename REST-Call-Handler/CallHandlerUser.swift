/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallHandlerUser.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import UIKit

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallHandlerUser : CallQueueUserHooksDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class CallHandlerUser : CallQueueUserHooksDelegate {
    
    var lgCallUUIDs         : [ UUID : CallHandler.CallStates ] = [ UUID : CallHandler.CallStates ]()
    var lgCallHandler       : CallHandler               = CallHandler()
    var lgProgressIndicator : GroupProgressIndicator?   = nil
    var lgProgressTarget    : Double                    = 0
    var lgProgressActual    : Double                    = 0

    //***************************************************************
    //***************        func updateProgress()
    //***************************************************************
    func updateProgress( isComplete : Bool = false, isReady : Bool = false ) {
        
        DispatchQueue.main.async {
            self.lgProgressActual   += 1
            self.lgProgressIndicator?.setProgress( progressConstant : Double( self.lgProgressActual / self.lgProgressTarget ),
                                                   withAnimation    : true )
        }  // DispatchQueue.main.async
        
    }  // func updateProgress()
    
    //***************************************************************
    //***************        func CallStateChange( calltask  : CallHandler.CallTask, state : CallHandler.CallStates )
    //***************************************************************
    func CallStateChange( calltask  : CallHandler.CallTask, state : CallHandler.CallStates ) {
        //print( "\(calltask.TaskUUID.uuidString) : \(state)" )
        self.lgCallUUIDs[ calltask.TaskUUID ] = state
    }  // func CallStateChange( calltask  : CallHandler.CallTask, state : CallHandler.CallStates )
    
    //***************************************************************
    //***************        func OPTIONSCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.OptionsCallOutcomes)
    //***************************************************************
    func OPTIONSCallCompleted( calltask : CallHandler.CallTask, outcomes : OptionsCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN OPTIONSCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END OPTIONSCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
        
    }  // func OPTIONSCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.OptionsCallOutcomes)
    
    //***************************************************************
    //***************        func GETCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.GetCallOutcomes)
    //***************************************************************
    func GETCallCompleted( calltask : CallHandler.CallTask, outcomes : GetCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN GETCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END GETCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
        
    }  // func GETCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.GetCallOutcomes)
    
    //***************************************************************
    //***************        func HEADCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.HeadCallOutcomes)
    //***************************************************************
    func HEADCallCompleted( calltask : CallHandler.CallTask, outcomes : HeadCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN HEADCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END HEADCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
        
    }  // func HEADCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.HeadCallOutcomes)
    
    //***************************************************************
    //***************        func POSTCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.PostCallOutcomes)
    //***************************************************************
    func POSTCallCompleted( calltask : CallHandler.CallTask, outcomes : PostCallOutcomes ) {
        let myMsg = """
        **FYI: BEGIN POSTCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END POSTCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
        
    }  // func POSTCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.PostCallOutcomes)
    
    //***************************************************************
    //***************        func PUTCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.PutCallOutcomes)
    //***************************************************************
    func PUTCallCompleted(calltask: CallHandler.CallTask, outcomes: PutCallOutcomes) {
        let myMsg = """
        **FYI: BEGIN PUTCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END PUTCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
        
    }  // func PUTCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.PutCallOutcomes)
    
    //***************************************************************
    //***************        func PATCHCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.PatchCallOutcomes)
    //***************************************************************
    func PATCHCallCompleted( calltask : CallHandler.CallTask, outcomes : PatchCallOutcomes ) {
        let myMsg = """
        **FYI: BEGIN PATCHCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END PATCHCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
    }  // func PATCHCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.PatchCallOutcomes)
    
    //***************************************************************
    //***************        func DELETECallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.DeleteCallOutcomes)
    //***************************************************************
    func DELETECallCompleted( calltask: CallHandler.CallTask, outcomes: DeleteCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN DELETECallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END DELETECallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
    }  // func DELETECallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.DeleteCallOutcomes)
    
    //***************************************************************
    //***************        func UNDEFCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.UndefCallOutcomes)
    //***************************************************************
    func UNDEFCallCompleted( calltask : CallHandler.CallTask, outcomes : UndefCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN UNDEFCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END UNDEFCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        updateProgress()
        
    }  // func UNDEFCallCompleted(calltask: CallHandler.CallTask, outcomes: CallHandler.UndefCallOutcomes)
    
    //***************************************************************
    //***************        func AllCallsCompleted(callhandler: CallHandler)
    //***************************************************************
    func AllCallsCompleted( callhandler: CallHandler ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: AllCallsCompleted ( \(callhandler.lgGeneralCallsCompleted.count) of \(callhandler.lgGeneralCallsQueue.count) )
        -----------------------------------------------------
        """
        
        gMsgLog.Log( msg: myMsg)
        updateProgress( isComplete : true )
    }  // func AllCallsCompleted(callhandler: CallHandler)
    
    //***************************************************************
    //***************        func ClearCallQueue()
    //***************************************************************
    func ClearCallQueue() {
        lgCallHandler.lgGeneralCallsQueue.removeAll()
    }  //func ClearCallQueue()
    
    //***************************************************************
    //***************        func MakeCalls()
    //***************************************************************
    func MakeCalls( serial : Bool = true) {
        lgCallHandler.lgGeneralCallsCompleted.removeAll()

        lgProgressTarget = Double( lgCallUUIDs.count )
        lgProgressActual = 0
        
        lgCallHandler.lgCallQueueUserHooksDelegate                  = self

        if serial {
            lgCallHandler.executeCallsSerially()
        } else {
            lgCallHandler.executeCallsConcurrently()
        } //if serial
        
    }  // func MakeCalls()
    
    //***************************************************************
    //***************        func QueueFailingTestCalls( callhandler : CallHandler )
    //***************************************************************
    func QueueFailingTestCalls() {
        
        //Generate an error with URL Creation
        //    Creating a URL might fail if you pass a bad site, so you need to unwrap its optional return value.
        //    Loading a URL's contents might fail because the site might be down (for example), so it might throw an error. This means you need to wrap the call into a do/catch block.
        //          -1003 "A server with the specified hostname could not be found."
        //Generate an error with URL Creation
        let myErroredRequest1     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                        a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                        r : "/api/v1/un}safe/1",
                                                                        p : path( v : [:],
                                                                                  q : [:] ) ),
                                                           m: methodtype.GET,
                                                           h: headers(  pairs : [:] ),
                                                           d: databody( items : [] ) )
        
        lgCallUUIDs[ lgCallHandler.queueURIRequest( t: "Generate an error with URL Creation: unsafe character }",
                                                           r : myErroredRequest1 ) ] = CallHandler.CallStates.Queued
        
        //Generate an error with myGetCompletionFunc guard error == nil else
        //    Loading a URL's contents might fail because the site might be down (for example), so it might throw an error. This means you need to wrap the call into a do/catch block.
        //          -1003 "A server with the specified hostname could not be found."
        let myErroredRequest2     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                        a : authority( user: "", pw: "", h: "dummy.czx.com", p: "" ),
                                                                        r : "/api/v1/employee/1",
                                                                        p : path( v : [:],
                                                                                  q : [:] ) ),
                                                           m: methodtype.GET,
                                                           h: headers(  pairs : [:] ),
                                                           d: databody( items : [] ) )
        
        lgCallUUIDs[ lgCallHandler.queueURIRequest( t: "Generate an error with myGetCompletionFunc guard error == nil else",
                                                    r : myErroredRequest2 ) ] = CallHandler.CallStates.Queued
        

        let myHEADRequest1     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                 a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                 r : "/api/v1/employees",
                                                                 p : path( v : [:],
                                                                           q : [:] ) ),
                                                    m: methodtype.HEAD,
                                                    h: headers( pairs: [:] ),
                                                    d: databody( items: [] ) )
        
        lgCallUUIDs[ lgCallHandler.queueURIRequest( t: "Make a successful HEAD Request",
                                                    r : myHEADRequest1 ) ] = CallHandler.CallStates.Queued
        
        let myHEADRequest2     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                     a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                     r : "/api/v1/employeet",
                                                                     p : path( v : [:],
                                                                               q : [:] ) ),
                                                        m: methodtype.HEAD,
                                                        h: headers( pairs: [:] ),
                                                        d: databody( items: [] ) )
        
        lgCallUUIDs[ lgCallHandler.queueURIRequest( t: "Make an unsuccessful HEAD Request",
                                                    r : myHEADRequest2 ) ] = CallHandler.CallStates.Queued
        
    }  // func QueueFailingTestCalls( callhandler : CallHandler )
    
    //***************************************************************
    //***************        func QueuePassingTestCalls( callhandler : CallHandler )
    //***************************************************************
    func QueuePassingTestCalls() {
        
        
        //    http://dummy.restapiexample.com/
        //
        //    #    Route            Method    T ype    Full route                                               Description
        //    1    /employee        GET         JSON    http://dummy.restapiexample.com/api/v1/employees        Get all employee data
        //    2    /employee/{id}   GET         JSON    http://dummy.restapiexample.com/api/v1/employee/1       Get a single employee data
        //    3    /create          POST        JSON    http://dummy.restapiexample.com/api/v1/create           Create new record in database
        //    4    /update/{id}     PUT         JSON    http://dummy.restapiexample.com/api/v1/update/21        Update an employee record
        //    5    /delete/{id}     DELETE      JSON    http://dummy.restapiexample.com/api/v1/update/2         Delete an employee record
        
        //let myCallHandler                           : CallHandler   = CallHandler()
        
        //    1    /employee    GET    JSON    http://dummy.restapiexample.com/api/v1/employees             Get all employee data               Details
        //    #    Route    Method    Sample Json    Results
        //    1    /employees    GET    -
        // [{"id":"1","employee_name":"","employee_salary":"0","employee_age":"0","profile_image":""},{"id":"2","employee_name":"","employee_salary":"0","employee_age":"0","profile_image":""}]
        let myRequest1     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                         a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                         r : "/api/v1/employees",
                                                                         p : path( v : [:],
                                                                                   q : [:] ) ),
                                                            m: methodtype.GET,
                                                            h: headers( pairs: [:] ),
                                                            d: databody( items: [] ) )
        lgCallUUIDs[ lgCallHandler.queueGETStringURI( t: "",
                                                      u : myRequest1.renderURI() ) ] = CallHandler.CallStates.Queued
        
        //    3    /create          POST        JSON    http://dummy.restapiexample.com/api/v1/create           Create new record in database
        //    Route    Method    Sample Json    Results
        //    /create    POST    {"name":"test","salary":"123","age":"23"}
        //    {"name":"test","salary":"123","age":"23","id":"719"}
        let myRequest2     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                         a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                         r : "/api/v1/create",
                                                                         p : path( v : [:],
                                                                                   q : [:] ) ),
                                                            m: methodtype.POST,
                                                            h: headers( pairs: [:] ),
                                                            d: databody( items: [] ) )
        
        let myNewObj                    : [String: Any] = ["name":UUID().uuidString,"salary":"123","age":"23"]
        //let myRuntimeClassContainer     : RuntimeClassContainer = RuntimeClassContainer()
        lgCallUUIDs[ lgCallHandler.queuePOSTStringURI( t: "",
                                                       u : myRequest2.renderURI(), o: myNewObj ) ] = CallHandler.CallStates.Queued
        
        let myRequest3     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                         a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                         r : "/api/v1/employees",
                                                                         p : path( v : [:],
                                                                                   q : [:] ) ),
                                                            m: methodtype.GET,
                                                            h: headers( pairs: [:] ),
                                                            d: databody( items: [] ) )
        lgCallUUIDs[ lgCallHandler.queueGETStringURI( t: "",
                                                      u : myRequest3.renderURI() ) ] = CallHandler.CallStates.Queued
        
        //        let myRequest4     : request     = request( e: endpoint( s : "http:",
        //                                                                 a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
        //                                                                 r : "/api/v1/employee/1",
        //                                                                 p : path( v : [:],
        //                                                                           q : [:] ) ),
        //                                                    m: methodtypes.GET,
        //                                                    h: headers(  pairs : [:] ),
        //                                                    d: databody( items : [] ) )
        //        lgCallUUIDs.append( myCallHandler.queueURIRequest(  t: "", r : myRequest4 ) )
        
    }
    
}  // class CallHandlerUser : CallQueueUserHooksDelegate

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallHandlerUser.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
