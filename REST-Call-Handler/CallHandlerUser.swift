/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallGroupUser.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import UIKit

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        protocol CallStateUIDelegate : class
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
protocol CallStateUIDelegate : class {
    func CallStateUIChange( uuid : UUID, state  : CallGroup.CallStates )
}  //  protocol CallStateUIDelegate : class

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallGroupUser : CallQueueUserHooksDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class CallGroupUser : CallQueueUserHooksDelegate {
    
    var lgCallStateUIDelegate   : CallStateUIDelegate?              = nil
    private var lgCallGroup   : CallGroup                       = CallGroup()
    var lgProgressIndicator     : GroupProgressIndicator?           = nil
    var lgProgressTarget        : Double                            = 0
    var lgProgressActual        : Double                            = 0
    
    //***************************************************************
    //***************        func reset()
    //***************************************************************
    func reset() {
        lgCallGroup.resetAll()
        lgProgressIndicator?.setProgress( percent : 0, withAnimation: false )
        lgProgressTarget = 0
        lgProgressActual = 0
    }  // func reset()
    
    //***************************************************************
    //***************        func queuedCallsCount() -> Int
    //***************************************************************
    func queuedCallsCount() -> Int {
        return lgCallGroup.queuedCallsCount()
    }  // func queuedCallsCount() -> Int
    
    //***************************************************************
    //***************        func queuedCallsUUID( index : Int ) -> UUID
    //***************************************************************
    func queuedCallsUUID( index : Int ) -> UUID {
        return lgCallGroup.queuedCallsUUID( index : index )
    }  // func queuedCallsUUID( index : Int ) -> UUID
    
    //***************************************************************
    //***************        func queuedCallIndexforUUID( uuid : UUID ) -> Int?
    //***************************************************************
    func queuedCallIndexforUUID( uuid : UUID ) -> Int? {
        return lgCallGroup.queuedCallIndexforUUID( uuid : uuid)
    }  // func queuedCallIndexforUUID( uuid : UUID ) -> Int?
    
    //***************************************************************
    //***************        func queuedCallTaskforUUID( uuid : UUID ) -> CallGroup.CallTask?
    //***************************************************************
    func queuedCallTaskforUUID( uuid : UUID ) -> CallGroup.CallTask? {
        return lgCallGroup.queuedCallTaskforUUID( uuid : uuid )
    }  // func queuedCallTaskforUUID( uuid : UUID ) -> CallGroup.CallTask?
    
    //***************************************************************
    //***************        func GetStateForCall( uuid : UUID ) -> CallGroup.CallStates
    //***************************************************************
    func queuedCallStateforUUID( uuid : UUID ) -> CallGroup.CallStates? {
        return lgCallGroup.queuedCallStateforUUID( uuid : uuid )
    }  // func GetStateForCall( uuid : UUID ) -> CallGroup.CallStates
    
    //***************************************************************
    //***************        func CallStateChange( calltask  : CallGroup.CallTask, state : CallGroup.CallStates )
    //***************************************************************
    func CallStateChange( calltask  : CallGroup.CallTask, state : CallGroup.CallStates ) {
        
        DispatchQueue.main.async {
            
            self.lgCallStateUIDelegate?.CallStateUIChange( uuid : calltask.TaskUUID , state  : state )
            if state == CallGroup.CallStates.Complete {
                self.lgProgressActual += 1
                let myPct : Int = Int( (self.lgProgressActual / self.lgProgressTarget ) * 100 )
                self.lgProgressIndicator?.setProgress( percent : myPct , withAnimation    : false )
                //print("\(myPct)")
            }  // if state
            
        }  // DispatchQueue.main.async
        
    }  // func CallStateChange( calltask  : CallGroup.CallTask, state : CallGroup.CallStates )
    
    //***************************************************************
    //***************        func CallGroupStatesChange()
    //***************************************************************
    func CallGroupStatesChange() {
        
    }  // func CallGroupStatesChange()
    
    
    //***************************************************************
    //***************        func OPTIONSCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.OptionsCallOutcomes)
    //***************************************************************
    func OPTIONSCallCompleted( calltask : CallGroup.CallTask, outcomes : OptionsCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN OPTIONSCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END OPTIONSCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
        
    }  // func OPTIONSCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.OptionsCallOutcomes)
    
    //***************************************************************
    //***************        func GETCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.GetCallOutcomes)
    //***************************************************************
    func GETCallCompleted( calltask : CallGroup.CallTask, outcomes : GetCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN GETCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END GETCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
        
    }  // func GETCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.GetCallOutcomes)
    
    //***************************************************************
    //***************        func HEADCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.HeadCallOutcomes)
    //***************************************************************
    func HEADCallCompleted( calltask : CallGroup.CallTask, outcomes : HeadCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN HEADCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END HEADCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
        
    }  // func HEADCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.HeadCallOutcomes)
    
    //***************************************************************
    //***************        func POSTCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.PostCallOutcomes)
    //***************************************************************
    func POSTCallCompleted( calltask : CallGroup.CallTask, outcomes : PostCallOutcomes ) {
        let myMsg = """
        **FYI: BEGIN POSTCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END POSTCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
        
    }  // func POSTCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.PostCallOutcomes)
    
    //***************************************************************
    //***************        func PUTCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.PutCallOutcomes)
    //***************************************************************
    func PUTCallCompleted(calltask: CallGroup.CallTask, outcomes: PutCallOutcomes) {
        let myMsg = """
        **FYI: BEGIN PUTCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END PUTCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
        
    }  // func PUTCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.PutCallOutcomes)
    
    //***************************************************************
    //***************        func PATCHCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.PatchCallOutcomes)
    //***************************************************************
    func PATCHCallCompleted( calltask : CallGroup.CallTask, outcomes : PatchCallOutcomes ) {
        let myMsg = """
        **FYI: BEGIN PATCHCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END PATCHCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
    }  // func PATCHCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.PatchCallOutcomes)
    
    //***************************************************************
    //***************        func DELETECallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.DeleteCallOutcomes)
    //***************************************************************
    func DELETECallCompleted( calltask: CallGroup.CallTask, outcomes: DeleteCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN DELETECallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END DELETECallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
    }  // func DELETECallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.DeleteCallOutcomes)
    
    //***************************************************************
    //***************        func UNDEFCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.UndefCallOutcomes)
    //***************************************************************
    func UNDEFCallCompleted( calltask : CallGroup.CallTask, outcomes : UndefCallOutcomes ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: BEGIN UNDEFCallCompleted \(calltask.TaskUUID)
        \(outcomes.Summary())
        **FYI: END UNDEFCallCompleted \(calltask.TaskUUID)
        -----------------------------------------------------
        """
        gMsgLog.Log( msg: myMsg)
        //updateProgress()
        
    }  // func UNDEFCallCompleted(calltask: CallGroup.CallTask, outcomes: CallGroup.UndefCallOutcomes)
    
    //***************************************************************
    //***************        func AllCallsCompleted(CallGroup: CallGroup)
    //***************************************************************
    func AllCallsCompleted( CallGroup: CallGroup ) {
        let myMsg = """
        -----------------------------------------------------
        **FYI: AllCallsCompleted ( \(CallGroup.completedCallsCount()) of \(CallGroup.queuedCallsCount()) )
        -----------------------------------------------------
        """
        
        gMsgLog.Log( msg: myMsg)
        //updateProgress( isComplete : true )
    }  // func AllCallsCompleted(CallGroup: CallGroup)
    
    //***************************************************************
    //***************        func MakeCalls()
    //***************************************************************
    func MakeCalls( serial : Bool = true) {
        lgCallGroup.resetCompleted()
        
        lgProgressTarget = Double( queuedCallsCount() )
        lgProgressActual = 0
        
        lgCallGroup.lgCallQueueUserHooksDelegate                  = self
        
        print("************ INITIAL QUEUE BEGIN *************")
        lgCallGroup.queuedCallDump()
        print("************ INITIAL QUEUE END *************")

        if serial {
            lgCallGroup.executeCallsSerially()
        } else {
            lgCallGroup.executeCallsConcurrently()
        } //if serial
        
    }  // func MakeCalls()
    
    //***************************************************************
    //***************        func QueueFailingTestCalls( CallGroup : CallGroup )
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
        
        lgCallGroup.queueURIRequest( t : "Generate an error with URL Creation: unsafe character }",
                                       r : myErroredRequest1 )
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
        
        lgCallGroup.queueURIRequest(  t : "Generate an error with myGetCompletionFunc guard error == nil else",
                                        r : myErroredRequest2 )
        
        
        let myHEADRequest1     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                             a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                             r : "/api/v1/employees",
                                                                             p : path( v : [:],
                                                                                       q : [:] ) ),
                                                                m: methodtype.HEAD,
                                                                h: headers( pairs: [:] ),
                                                                d: databody( items: [] ) )
        
        lgCallGroup.queueURIRequest( t: "Make a successful HEAD Request",
                                                    r : myHEADRequest1 )
        
        let myHEADRequest2     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                             a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                             r : "/api/v1/employeet",
                                                                             p : path( v : [:],
                                                                                       q : [:] ) ),
                                                                m: methodtype.HEAD,
                                                                h: headers( pairs: [:] ),
                                                                d: databody( items: [] ) )
        
        lgCallGroup.queueURIRequest( t: "Make an unsuccessful HEAD Request",
                                                    r : myHEADRequest2 )
        
    }  // func QueueFailingTestCalls( CallGroup : CallGroup )
    
    //***************************************************************
    //***************        func QueuePassingTestCalls( CallGroup : CallGroup )
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
        
        //let myCallGroup                           : CallGroup   = CallGroup()
        
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
        lgCallGroup.queueGETStringURI( t: "", u : myRequest1.renderURI() )
        
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

        lgCallGroup.queuePOSTStringURI( t : "", u : myRequest2.renderURI(), o: myNewObj )
        
        let myRequest3     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                         a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                         r : "/api/v1/employees",
                                                                         p : path( v : [:],
                                                                                   q : [:] ) ),
                                                            m: methodtype.GET,
                                                            h: headers( pairs: [:] ),
                                                            d: databody( items: [] ) )
        lgCallGroup.queueGETStringURI( t: "", u : myRequest3.renderURI() ) 
        
        //        let myRequest4     : request     = request( e: endpoint( s : "http:",
        //                                                                 a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
        //                                                                 r : "/api/v1/employee/1",
        //                                                                 p : path( v : [:],
        //                                                                           q : [:] ) ),
        //                                                    m: methodtypes.GET,
        //                                                    h: headers(  pairs : [:] ),
        //                                                    d: databody( items : [] ) )
        //        lgCallUUIDs.append( myCallGroup.queueURIRequest(  t: "", r : myRequest4 ) )
        
    }
    
}  // class CallGroupUser : CallQueueUserHooksDelegate

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallGroupUser.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
