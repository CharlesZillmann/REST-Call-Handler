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
//***************        class CallGroupUser : UIDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class CallGroupUser : UIDelegate {
    
    var lgCallStateUIDelegate   : CallStateUIDelegate?              = nil
    private var lgCallGroup     : CallGroup                         = CallGroup()
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
    //***************        func func queueURIRequest( r : request)
    //***************************************************************
    func queueURIRequest( t : String, r : CallRequest) {
        lgCallGroup.queueURIRequest( t : t , r : r )
    }  //func queueURIRequest( r : request)
    
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
    func CallGroupStatesChange( text : String) {
        print( text )
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
        
        lgCallGroup.lgUIDelegate                  = self
        
        print("************ INITIAL QUEUE BEGIN *************")
        print( lgCallGroup.queuedCallsState() )
        print("************ INITIAL QUEUE END *************")

        if serial {
            lgCallGroup.executeCallsSerially()
        } else {
            lgCallGroup.executeCallsConcurrently()
        } //if serial
        
    }  // func MakeCalls()
    

}  // class CallGroupUser : UIDelegate

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallGroupUser.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
