/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallHandler.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        protocol CallQueueUserHooksDelegate : class
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
protocol CallQueueUserHooksDelegate : class {
    func CallStateChange(        calltask  : CallHandler.CallTask, state     : CallHandler.CallStates )
    
    func OPTIONSCallCompleted(   calltask  : CallHandler.CallTask, outcomes  : OptionsCallOutcomes  )
    func GETCallCompleted(       calltask  : CallHandler.CallTask, outcomes  : GetCallOutcomes      )
    func HEADCallCompleted(      calltask  : CallHandler.CallTask, outcomes  : HeadCallOutcomes     )
    func POSTCallCompleted(      calltask  : CallHandler.CallTask, outcomes  : PostCallOutcomes     )
    func PUTCallCompleted(       calltask  : CallHandler.CallTask, outcomes  : PutCallOutcomes      )
    func PATCHCallCompleted(     calltask  : CallHandler.CallTask, outcomes  : PatchCallOutcomes    )
    func DELETECallCompleted(    calltask  : CallHandler.CallTask, outcomes  : DeleteCallOutcomes   )
    func UNDEFCallCompleted(     calltask  : CallHandler.CallTask, outcomes  : UndefCallOutcomes    )
    
    func AllCallsCompleted( callhandler : CallHandler )
}  //  protocol CallQueueUserHooksDelegate : class

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class CallHandler
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class CallHandler {
    //***************************************************************
    //***************        enum CallStates : String
    //***************************************************************
    enum CallStates : String {
        case Queued     = "Queued"
        case Waiting    = "Waiting"
        case Executing  = "Executing"
        case Complete   = "Complete"
    }  // enum CallStates : String

    //***************************************************************
    //***************        struct CallTask
    //***************************************************************
    //The Call Parameters, Status, and Results. Including Error Codes and Returned Data
    struct CallTask {
        var UsersTag                    : String?                   = nil
        var TaskUUID                    : UUID                      = UUID()
        var MethodlType                 : methodtype                = methodtype.NONESPECIFIED
        var Endpoint                    : String                    = ""
        var WithJSONObject              : Any?                      = nil                   //Used by POST
        var CallType_Options_Outcome    : OptionsCallOutcomes?      = nil
        var CallType_Get_Outcome        : GetCallOutcomes?          = nil
        var CallType_Head_Outcome       : HeadCallOutcomes?         = nil
        var CallType_Post_Outcome       : PostCallOutcomes?         = nil
        var CallType_Put_Outcome        : PutCallOutcomes?          = nil
        var CallType_Patch_Outcome      : PatchCallOutcomes?        = nil
        var CallType_Delete_Outcome     : DeleteCallOutcomes?       = nil
        var CallType_Undefined_Outcome  : UndefCallOutcomes?        = nil
        
        //***************************************************************
        //***************        init ()
        //***************************************************************
        init () {
        }  // init ()
        
        //***************************************************************
        //***************        init UsersTag, TaskUUID, MethodlType, Endpoint, WithJSONObject
        //***************************************************************
        init ( UsersTag : String  = "", TaskUUID : UUID, MethodlType : methodtype, Endpoint : String, WithJSONObject : Any? = nil ) {
            self.UsersTag                    = UsersTag
            self.TaskUUID                    = TaskUUID
            self.MethodlType                 = MethodlType
            self.Endpoint                    = Endpoint
            self.WithJSONObject              = WithJSONObject
        }  // init UsersTag, TaskUUID, MethodlType, Endpoint, WithJSONObject
        
    }  //struct CallTask
    
    var lgCallQueueUserHooksDelegate    : CallQueueUserHooksDelegate?   = nil                   // Notified after EACH call *and* ALL calls complete
    var lgSemaphore                     : DispatchSemaphore?            = nil                   // Semaphore for execution
    var lgGeneralCallsQueue             : [CallTask]                    = [CallTask]()          // Queue for calls waiting to be executed
    var lgGeneralCallsCompleted         : [UUID : CallTask]             = [UUID : CallTask]()   // Queue for calls that have been completed
    
    //***************************************************************
    //***************        func reset()
    //***************************************************************
    func reset() {
        lgGeneralCallsQueue.removeAll()
        lgGeneralCallsCompleted.removeAll()
    }  // func reset()

    //***************************************************************
    //***************        func callStateChange( calltask  : CallHandler.CallTask, state     : CallHandler.CallStates  )
    //***************************************************************
    func callStateChange( calltask  : CallHandler.CallTask, state     : CallHandler.CallStates  ) {
        DispatchQueue.main.async {
            self.lgCallQueueUserHooksDelegate?.CallStateChange( calltask  : calltask, state : state )
        }
    }  // func callStateChange( calltask  : CallHandler.CallTask, state     : CallHandler.CallStates  )
    
    //***************************************************************
    //***************        func queueGETStringURI( u : String)
    //***************************************************************
    func queueGETStringURI( t : String, u : String) -> UUID {
        
        let myUUID = UUID()
        let myTask : CallTask = CallTask(   UsersTag                      : t,
                                            TaskUUID                      : myUUID,
                                            MethodlType                   : methodtype.GET,
                                            Endpoint                      : u,
                                            WithJSONObject                : nil )
        
        queueRESTTask( theTask : myTask )
        //self.gLog(msg: "Fyi: queueGETStringURI TaskUUID: (\(myUUID): {\(u)}")
        
        return myUUID
    }  //func queueGETStringURI( u : String)
    
    //***************************************************************
    //***************        func queuePOSTStringURI( u : String)
    //***************************************************************
    func queuePOSTStringURI( t : String, u : String, o: Any ) -> UUID {
        
        let myUUID = UUID()
        let myTask : CallTask = CallTask(   UsersTag                      : t,
                                            TaskUUID                      : myUUID,
                                            MethodlType                   : methodtype.POST,
                                            Endpoint                      : u,
                                            WithJSONObject                : o)
        
        queueRESTTask( theTask : myTask )
        
        return myUUID
    }  //func queuePOSTStringURI( u : String)
    
    //***************************************************************
    //***************        func queuePUTStringURI( u : String)
    //***************************************************************
    func queuePUTStringURI( t : String, u : String, o: Any ) -> UUID {
        
        let myUUID = UUID()
        let myTask : CallTask = CallTask(   UsersTag                      : t,
                                            TaskUUID                      : myUUID,
                                            MethodlType                   : methodtype.PUT,
                                            Endpoint                      : u,
                                            WithJSONObject                : o )
        
        queueRESTTask( theTask : myTask )
        
        return myUUID
    }  //func queuePOSTStringURI( u : String)
    
    //***************************************************************
    //***************        func func queueURIRequest( r : request)
    //***************************************************************
    func queueURIRequest( t : String, r : CallRequest) -> UUID {
        let myEndpointURI = r.renderURI()
        
        let myUUID = UUID()
        let myTask : CallTask = CallTask( UsersTag                      : t,
                                          TaskUUID                      : myUUID,
                                          MethodlType                   : r.rMethod,
                                          Endpoint                      : myEndpointURI,
                                          WithJSONObject                : nil )
        
        queueRESTTask( theTask : myTask )
        
        return myUUID
    }  //func queueURIRequest( r : request)
    
    //***************************************************************
    //***************        override init(frame: CGRect)
    //***************************************************************
    func queueRESTTask( theTask : CallTask ) {
        lgGeneralCallsQueue.append( theTask )
        gMsgLog.Log(msg: "FYI: QUEUED TASK\n\t ID:\t\(theTask.TaskUUID);\n\tTAG:\t\(theTask.UsersTag ?? "");\n\tEP:\t\"\(theTask.Endpoint)\"\n")
    }  //gGeneralRESTCallsQueue.append( theTask )
    
    //***************************************************************
    //***************        func executeCallTask( task : CallTask, completion: () -> Void )
    //***************************************************************
    func executeCallTask( task : CallTask, completion: () -> Void ) {
        
            switch task.MethodlType {
            case methodtype.OPTIONS :
                self.makeGeneralOptionsCall( theCallTask : task ) { theCallTask, theOptionsCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralOptionsCall function
                    //we have given the longhand variable names for readability and troubleshooting
                    //the completion handler will be called from within makeGeneralOptionsCall in the event of an error that
                    //stops us from pursuing the GET call OR in the event of a successful completion
                    //the parameter represent all the feedback from the synchronous and async calls
                    //myOptionsCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralOptionsCall function. Every attempt should be made to keep future code changes within myOptionsCompletionFunc
                    //This same strategy should work for all the call types below
                    let myCompletedTask = self.myOptionsCompletionFunc( calltask    : theCallTask,
                                                                        outcomes    : theOptionsCallOutcomes,
                                                                        data        : theData,
                                                                        response    : theURLResponse,
                                                                        error       : theError )
                    
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
                } //makeGeneralOptionsCall closure for completion
                
            case methodtype.GET :
                self.makeGeneralGetCall( theCallTask : task ) { theCallTask, theGetCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralGetCall function
                    //we have given the longhand variable names for readability and troubleshooting
                    //the completion handler will be called from within makeGeneralGetCall in the event of an error that
                    //stops us from pursuing the GET call OR in the event of a successful completion
                    //the parameter represent all the feedback from the synchronous and async calls
                    //myGetCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralGetCall function. Every attempt should be made to keep future code changes within myGetCompletionFunc
                    //This same strategy should work for all the call types below
                    let myCompletedTask = self.myGetCompletionFunc( calltask    : theCallTask,
                                                                    outcomes    : theGetCallOutcomes,
                                                                    data        : theData,
                                                                    response    : theURLResponse,
                                                                    error       : theError )
                    
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
                } //makeGeneralGetCall closure for completion
                
            case methodtype.HEAD :
                self.makeGeneralHeadCall( theCallTask : task ) { theCallTask, theHeadCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralHeadCall function
                    //we have given the longhand variable names for readability and troubleshooting
                    //the completion handler will be called from within makeGeneralHeadCall in the event of an error that
                    //stops us from pursuing the GET call OR in the event of a successful completion
                    //the parameter represent all the feedback from the synchronous and async calls
                    //myHeadCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralHeadCall function. Every attempt should be made to keep future code changes within myHeadCompletionFunc
                    //This same strategy should work for all the call types below
                    let myCompletedTask = self.myHeadCompletionFunc( calltask    : theCallTask,
                                                                        outcomes    : theHeadCallOutcomes,
                                                                        data        : theData,
                                                                        response    : theURLResponse,
                                                                        error       : theError )
                    
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
            } //makeGeneralHeadCall closure for completion
                
            case methodtype.POST :
                self.makeGeneralPostCall( theCallTask : task ) { theCallTask, thePostCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralPostCall function
                    //myPostCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralPostCall function. Every attempt should be made to keep future code changes within myPostCompletionFunc
                    //--see previous comment above
                    let myCompletedTask = self.myPostCompletionFunc( calltask   : theCallTask,
                                                                     outcomes   : thePostCallOutcomes,
                                                                     data       : theData,
                                                                     response   : theURLResponse,
                                                                     error      : theError )
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
                }  //makeGeneralPostCall closure for completion
                
            case methodtype.PUT :
                self.makeGeneralPutCall( theCallTask : task ) { theCallTask, thePutCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralPutCall function
                    //myPutCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralPutCall function. Every attempt should be made to keep future code changes within myPutCompletionFunc
                    //--see previous comment above
                    let myCompletedTask = self.myPutCompletionFunc( calltask   : theCallTask,
                                                                     outcomes   : thePutCallOutcomes,
                                                                     data       : theData,
                                                                     response   : theURLResponse,
                                                                     error      : theError )
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
                }  //makeGeneralPutCall closure for completion
            
            case methodtype.PATCH :
                self.makeGeneralPatchCall( theCallTask : task ) { theCallTask, thePatchCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralPatchCall function
                    //myPatchCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralPatchCall function. Every attempt should be made to keep future code changes within myPatchCompletionFunc
                    //--see previous comment above
                    let myCompletedTask = self.myPatchCompletionFunc( calltask   : theCallTask,
                                                                      outcomes   : thePatchCallOutcomes,
                                                                      data       : theData,
                                                                      response   : theURLResponse,
                                                                      error      : theError )
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
            }  //makeGeneralPutCall closure for completion
                
            case methodtype.DELETE :
                self.makeGeneralDeleteCall( theCallTask : task ) { theCallTask, theDeleteCallOutcomes, theData, theURLResponse, theError in
                    
                    //we have added a completion handler to the declaration of our makeGeneralDeleteCall function
                    //myDeleteCompletionFunc should have all the available information via this closure and there should be no reason to ever
                    //edit the makeGeneralDeleteCall function. Every attempt should be made to keep future code changes within myDeleteCompletionFunc
                    //--see previous comment above
                    let myCompletedTask = self.myDeleteCompletionFunc( calltask : theCallTask,
                                                                       outcomes : theDeleteCallOutcomes,
                                                                       data     : theData,
                                                                       response : theURLResponse,
                                                                       error    : theError )
                    self.lgGeneralCallsCompleted[myCompletedTask.TaskUUID] = myCompletedTask
                    
                    self.callStateChange( calltask  : theCallTask, state : CallHandler.CallStates.Complete )
                    self.lgSemaphore?.signal() // releasing the resource
                }  //makeGeneralPostCall closure for completion
                
            case methodtype.NONESPECIFIED :
                gMsgLog.Log(msg: "ERROR: func executeRESTCallsQueue cannot create URL")

                self.lgSemaphore?.signal() // releasing the resource
            }  //switch myTask.TaskCallType
            
    }  // func executeCallTask( task : CallTask, completion: () -> Void )
    
    //***************************************************************
    //***************        makeGeneralOptionsCall( theCallTask, completion )
    //***************************************************************
    func makeGeneralOptionsCall( theCallTask : CallTask, completion: @escaping (_ theCallTask : CallTask, _ theOptionsCallOutcomes : OptionsCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : OptionsCallOutcomes    = OptionsCallOutcomes()
        myOutcomes.UsersTag                     = theCallTask.UsersTag
        myOutcomes.TaskUUIDString               = theCallTask.TaskUUID.uuidString
        
        gettimeofday(&myOutcomes.CallStartTime , nil)
        
        guard let url = URL(string: theCallTask.Endpoint) else {
            myOutcomes.urlCreationError = "ERROR: func makeGeneralOptionsCall cannot create URL"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  // guard let url = URL(string: theCallTask.Endpoint) else
        
        let urlRequest  = URLRequest(url: url)
        
        // set up the session
        let config      = URLSessionConfiguration.default
        let session     = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            gettimeofday(&myOutcomes.CallEndTime , nil)
            completion(theCallTask, myOutcomes, data, response, error)
        }  //let task = session.dataTask(with: urlRequest)
        
        task.resume()
        session.finishTasksAndInvalidate()
        
        //There is no need to call the completion handler here since dataTask has called the completion handler and
        //passed all data and errors along from its own completion handler
    }  // makeGeneralOptionsCall( theCallTask, completion )
    
    //***************************************************************
    //***************        makeGeneralGetCall( theCallTask, completion )
    //***************************************************************
    func makeGeneralGetCall( theCallTask : CallTask, completion: @escaping (_ theCallTask : CallTask, _ theGetCallOutcomes : GetCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : GetCallOutcomes = GetCallOutcomes()
        myOutcomes.UsersTag              = theCallTask.UsersTag
        myOutcomes.TaskUUIDString        = theCallTask.TaskUUID.uuidString
        
        gettimeofday(&myOutcomes.CallStartTime , nil)
        
        guard let url = URL(string: theCallTask.Endpoint) else {
            myOutcomes.urlCreationError = "ERROR: func makeGeneralGetCall cannot create URL"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  // guard let url = URL(string: theCallTask.Endpoint) else
        
        let urlRequest  = URLRequest(url: url)
        
        // set up the session
        let config      = URLSessionConfiguration.default
        let session     = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            gettimeofday(&myOutcomes.CallEndTime , nil)
            completion(theCallTask, myOutcomes, data, response, error)
        }  //let task = session.dataTask(with: urlRequest)
        
        task.resume()
        session.finishTasksAndInvalidate()
        
        //There is no need to call the completion handler here since dataTask has called the completion handler and
        //passed all data and errors along from its own completion handler
    }  // makeGeneralGetCall( theCallTask, completion )
    
    //***************************************************************
    //***************        makeGeneralHeadCall( theCallTask, completion )
    //***************************************************************
    func makeGeneralHeadCall( theCallTask : CallTask, completion: @escaping (_ theCallTask : CallTask, _ theHeadCallOutcomes : HeadCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : HeadCallOutcomes       = HeadCallOutcomes()
        myOutcomes.UsersTag                     = theCallTask.UsersTag
        myOutcomes.TaskUUIDString               = theCallTask.TaskUUID.uuidString
        
        gettimeofday(&myOutcomes.CallStartTime , nil)
        
        guard let url = URL(string: theCallTask.Endpoint) else {
            myOutcomes.urlCreationError = "ERROR: func makeGeneralHeadCall cannot create URL"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  // guard let url = URL(string: theCallTask.Endpoint) else
        
        var urlRequest  = URLRequest(url: url)
        urlRequest.httpMethod   = "HEAD"

        // set up the session
        let config      = URLSessionConfiguration.default
        let session     = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            gettimeofday(&myOutcomes.CallEndTime , nil)
            completion(theCallTask, myOutcomes, data, response, error)
        }  //let task = session.dataTask(with: urlRequest)
        
        task.resume()
        session.finishTasksAndInvalidate()
        
        //There is no need to call the completion handler here since dataTask has called the completion handler and
        //passed all data and errors along from its own completion handler
    }  //makeGeneralHeadCall( theCallTask, completion )
    
    //***************************************************************
    //***************        func makeGeneralPostCall( theCallTask : CallTask )
    //***************************************************************
    func makeGeneralPostCall( theCallTask : CallTask,
                              completion  : @escaping (_ theCallTask : CallTask, _ thePostCallOutcomes : PostCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : PostCallOutcomes   = PostCallOutcomes()
        myOutcomes.UsersTag                 = theCallTask.UsersTag
        myOutcomes.TaskUUIDString           = theCallTask.TaskUUID.uuidString
        
        gettimeofday(&myOutcomes.CallStartTime , nil)
        
        guard let postURL = URL(string: theCallTask.Endpoint) else {
            myOutcomes.urlCreationError = "ERROR: makeGeneralPostCall cannot create URL using: URL(string: theCallTask.Endpoint)"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  // guard let postURL = URL(string: theCallTask.Endpoint) else
        
        var postURLRequest          = URLRequest(url: postURL)
        postURLRequest.httpMethod   = "POST"
        
        //This needs to be passed as a property of theCallTask
        //Both the newTodo withJSONObject and the objects data need to be passed as a single JSONObject
        //So, this implies we will need to create a function that outputs JSONObjects of varying types for
        //all the posible calls that we may make. i.e. we will have to parse swagger API definitions into jsonobjects. ugh
        //let newTodo     : [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        
        if let myObject = theCallTask.WithJSONObject {
            let jsonPOST    : Data
            
            do {
                jsonPOST = try JSONSerialization.data(withJSONObject: myObject, options: [])
                myOutcomes.httpBodyJSONData         = jsonPOST
                postURLRequest.httpBody             = jsonPOST
            } catch {
                myOutcomes.urlCreationError = "ERROR: makeGeneralPostCall cannot create JSON using: JSONSerialization.data(withJSONObject: myObject, options: [])"
                completion(theCallTask, myOutcomes, nil, nil, nil)
                return
            }  //do catch
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: postURLRequest) {
                (data, response, error) in
                gettimeofday(&myOutcomes.CallEndTime , nil)
                completion(theCallTask, myOutcomes, data, response, error)
            }  //let task = session.dataTask
            
            task.resume()
        } else {
            myOutcomes.urlCreationError = "ERROR: makeGeneralPostCall theCallTask.WithJSONObject is nil"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  //if let myObject = theCallTask.WithJSONObject
        
    }  //func makeGeneralPostCall( theEndpoint : String )
    
    //***************************************************************
    //***************        func makeGeneralPutCall( theCallTask : CallTask )
    //***************************************************************
    func makeGeneralPutCall( theCallTask : CallTask,
                              completion  : @escaping (_ theCallTask : CallTask, _ thePutCallOutcomes : PutCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : PutCallOutcomes    = PutCallOutcomes()
        myOutcomes.UsersTag                 = theCallTask.UsersTag
        myOutcomes.TaskUUIDString           = theCallTask.TaskUUID.uuidString
        
        gettimeofday(&myOutcomes.CallStartTime , nil)
        
        guard let putURL = URL(string: theCallTask.Endpoint) else {
            myOutcomes.urlCreationError = "ERROR: makeGeneralPutCall cannot create URL using: URL(string: theCallTask.Endpoint)"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  // guard let putURL = URL(string: theCallTask.Endpoint) else
        
        var putURLRequest          = URLRequest(url: putURL)
        putURLRequest.httpMethod   = "PUT"
        
        //This needs to be passed as a property of theCallTask
        //Both the newTodo withJSONObject and the objects data need to be passed as a single JSONObject
        //So, this implies we will need to create a function that outputs JSONObjects of varying types for
        //all the posible calls that we may make. i.e. we will have to parse swagger API definitions into jsonobjects. ugh
        //let newTodo     : [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        
        if let myObject = theCallTask.WithJSONObject {
            let jsonPUT    : Data
            
            do {
                jsonPUT = try JSONSerialization.data(withJSONObject: myObject, options: [])
                myOutcomes.httpBodyJSONData         = jsonPUT
                putURLRequest.httpBody              = jsonPUT
            } catch {
                myOutcomes.urlCreationError = "ERROR: makeGeneralPutCall cannot create JSON using: JSONSerialization.data(withJSONObject: myObject, options: [])"
                completion(theCallTask, myOutcomes, nil, nil, nil)
                return
            }  //do catch
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: putURLRequest) {
                (data, response, error) in
                gettimeofday(&myOutcomes.CallEndTime , nil)
                completion(theCallTask, myOutcomes, data, response, error)
            }  //let task = session.dataTask
            
            task.resume()
        } else {
            myOutcomes.urlCreationError = "ERROR: makeGeneralPutCall theCallTask.WithJSONObject is nil"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  //if let myObject = theCallTask.WithJSONObject
        
    }  //func makeGeneralPutCall( theEndpoint : String )
    
    //***************************************************************
    //***************        func makeGeneralPutCall( theCallTask : CallTask )
    //***************************************************************
    func makeGeneralPatchCall( theCallTask : CallTask,
                               completion  : @escaping (_ theCallTask : CallTask, _ thePatchCallOutcomes : PatchCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : PatchCallOutcomes      = PatchCallOutcomes()
        myOutcomes.UsersTag                     = theCallTask.UsersTag
        myOutcomes.TaskUUIDString               = theCallTask.TaskUUID.uuidString
        
        gettimeofday(&myOutcomes.CallStartTime , nil)
        
        guard let patchURL = URL(string: theCallTask.Endpoint) else {
            myOutcomes.urlCreationError = "ERROR: makeGeneralPatchCall cannot create URL using: URL(string: theCallTask.Endpoint)"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  // guard let patchURL = URL(string: theCallTask.Endpoint) else
        
        var patchURLRequest          = URLRequest(url: patchURL)
        patchURLRequest.httpMethod   = "PATCH"
        
        //This needs to be passed as a property of theCallTask
        //Both the newTodo withJSONObject and the objects data need to be passed as a single JSONObject
        //So, this implies we will need to create a function that outputs JSONObjects of varying types for
        //all the posible calls that we may make. i.e. we will have to parse swagger API definitions into jsonobjects. ugh
        //let newTodo     : [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        
        if let myObject = theCallTask.WithJSONObject {
            let jsonPATCH    : Data
            
            do {
                jsonPATCH = try JSONSerialization.data(withJSONObject: myObject, options: [])
                myOutcomes.httpBodyJSONData         = jsonPATCH
                patchURLRequest.httpBody              = jsonPATCH
            } catch {
                myOutcomes.urlCreationError = "ERROR: makeGeneralPatchCall cannot create JSON using: JSONSerialization.data(withJSONObject: myObject, options: [])"
                completion(theCallTask, myOutcomes, nil, nil, nil)
                return
            }  //do catch
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: patchURLRequest) {
                (data, response, error) in
                gettimeofday(&myOutcomes.CallEndTime , nil)
                completion(theCallTask, myOutcomes, data, response, error)
            }  //let task = session.dataTask
            
            task.resume()
        } else {
            myOutcomes.urlCreationError = "ERROR: makeGeneralPatchCall theCallTask.WithJSONObject is nil"
            completion(theCallTask, myOutcomes, nil, nil, nil)
            return
        }  //if let myObject = theCallTask.WithJSONObject
        
    }  //func makeGeneralPatchCall( theEndpoint : String )
    
    
    //***************************************************************
    //***************        func makeGeneralDeleteCall( theCallTask : CallTask )
    //***************************************************************
    func makeGeneralDeleteCall( theCallTask : CallTask,
                                completion: @escaping (_ theCallTask : CallTask, _ theDeleteCallOutcomes : DeleteCallOutcomes, _ theData : Data?, _ theURLResponse : URLResponse?, _ theError: Error? ) -> Void ) {
        
        let myOutcomes : DeleteCallOutcomes = DeleteCallOutcomes()
        myOutcomes.UsersTag                 = theCallTask.UsersTag
        myOutcomes.TaskUUIDString           = theCallTask.TaskUUID.uuidString
        
        //let todosEndpoint: String = "https://jsonplaceholder.typicode.com/todos"
        guard let todosURL = URL(string: theCallTask.Endpoint) else {
            //1) CAPTURE THIS OUTPUT IN TASK AS urlCreationError
            myOutcomes.urlCreationError = "Error: cannot create URL"
            completion( theCallTask, myOutcomes, nil, nil, nil)
            return
        }  //guard let todosURL
        
        //let firstTodoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        var firstTodoUrlRequest         = URLRequest(url: todosURL)
        firstTodoUrlRequest.httpMethod  = "DELETE"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: firstTodoUrlRequest) {
            (data, response, error) in
            
            //Send Everything we have to the completion handler that should execute at some time in the future
            completion(theCallTask, myOutcomes, data, response, error)
            
        }  //let task = session.dataTask(with: firstTodoUrlRequest)
        
        task.resume()
        return
    }  //func makeGeneralDeleteCall( theEndpoint : String )
    
    //***************************************************************
    //***************        func myOptionsCompletionFunc
    //***************************************************************
    //One way or the other this task is over. So we have to compile all the results into a copy of the CallTask for future analysis
    //Take in all the various outputs from the call and combine them into a single CallTask with the inputs and outputs
    //This CallTask will be placed in the completed task pile for future use, analysis, or processing
    //But before we do that we will attempt to preprocess some things:
    //  We will attempt to determine any dataTaskError or responseDataError
    //  We will attach the responseData to the CallTask
    //  We will attempt a basic JSONSerialization and capture any JSONSerializationError
    //  We will attach any valid JSON to the CallTask (aka: todo)
    //  If we have any issue parsing JSON from the data then we will register a parsingRespnseDataError
    func myOptionsCompletionFunc( calltask  : CallTask,
                                  outcomes  : OptionsCallOutcomes,
                                  data      : Data?,
                                  response  : URLResponse?,
                                  error     : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask               = CallTask()
        var myOutcomes : OptionsCallOutcomes    = OptionsCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.OPTIONSCallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                          = calltask
        myOutcomes                          = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Options_Outcome = myOutcomes
        
        if myCallTask.CallType_Get_Outcome?.urlCreationError == nil {
            
            // check for any errors
            guard error == nil else {
                myCallTask.CallType_Get_Outcome?.dataTaskError = "ERROR: \(error!)"
                myYieldToDelegate()
                return myCallTask
            }  //guard error == nil
            
            // make sure we got data
            guard let myResponseData = data else {
                myCallTask.CallType_Options_Outcome?.responseDataError = "ERROR: myOptionsCompletionFunc did not receive data for Task: \(myCallTask.TaskUUID)"
                myYieldToDelegate()
                return myCallTask
            }  //guard let myResponseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS
            myCallTask.CallType_Options_Outcome?.responseData   = myResponseData
            myCallTask.CallType_Options_Outcome?.urlResponse    = response
            
        } //if myCallTask.CallType_Get_Outcome?.urlCreationError == nil
        
        myYieldToDelegate()
        
        return myCallTask
    }  //func myOptionsCompletionFunc
    
    //***************************************************************
    //***************        func myGetCompletionFunc
    //***************************************************************
    //One way or the other this task is over. So we have to compile all the results into a copy of the CallTask for future analysis
    //Take in all the various outputs from the call and combine them into a single CallTask with the inputs and outputs
    //This CallTask will be placed in the completed task pile for future use, analysis, or processing
    //But before we do that we will attempt to preprocess some things:
    //  We will attempt to determine any dataTaskError or responseDataError
    //  We will attach the responseData to the CallTask
    //  We will attempt a basic JSONSerialization and capture any JSONSerializationError
    //  We will attach any valid JSON to the CallTask (aka: todo)
    //  If we have any issue parsing JSON from the data then we will register a parsingRespnseDataError
    func myGetCompletionFunc( calltask  : CallTask,
                              outcomes  : GetCallOutcomes,
                              data      : Data?,
                              response  : URLResponse?,
                              error     : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask           = CallTask()
        var myOutcomes : GetCallOutcomes    = GetCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.GETCallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                          = calltask
        myOutcomes                          = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Get_Outcome     = myOutcomes
        
        if myCallTask.CallType_Get_Outcome?.urlCreationError == nil {
            
            // check for any errors
            guard error == nil else {
                myCallTask.CallType_Get_Outcome?.dataTaskError = "ERROR: \(error!)"
                myYieldToDelegate()
                return myCallTask
            }  //guard error == nil
            
            // make sure we got data
            guard let myResponseData = data else {
                myCallTask.CallType_Get_Outcome?.responseDataError = "ERROR: myGetCompletionFunc did not receive data for Task: \(myCallTask.TaskUUID)"
                myYieldToDelegate()
                return myCallTask
            }  //guard let myResponseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS responseData
            myCallTask.CallType_Get_Outcome?.urlResponse    = response
            myCallTask.CallType_Get_Outcome?.responseData   = myResponseData
            
        } //if myCallTask.CallType_Get_Outcome?.urlCreationError == nil
         
        myYieldToDelegate()
        
        return myCallTask
    }  //func myGetCompletionFunc
    
    //***************************************************************
    //***************        func myHeadCompletionFunc
    //***************************************************************
    func myHeadCompletionFunc( calltask  : CallTask,
                               outcomes  : HeadCallOutcomes,
                               data      : Data?,
                               response  : URLResponse?,
                               error     : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask           = CallTask()
        var myOutcomes : HeadCallOutcomes   = HeadCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.HEADCallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                          = calltask
        myOutcomes                          = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Head_Outcome     = myOutcomes
        
        if myCallTask.CallType_Head_Outcome?.urlCreationError == nil {
            
            // check for any errors
            guard error == nil else {
                myCallTask.CallType_Head_Outcome?.dataTaskError = "ERROR: \(error!)"
                myYieldToDelegate()
                return myCallTask
            }  //guard error == nil
            
            // make sure we got data
            guard let myResponseData = data else {
                myCallTask.CallType_Head_Outcome?.responseDataError = "ERROR: myHeadCompletionFunc did not receive data for Task: \(myCallTask.TaskUUID)"
                myYieldToDelegate()
                return myCallTask
            }  //guard let myResponseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS responseData
            myCallTask.CallType_Head_Outcome?.urlResponse   = response
            myCallTask.CallType_Head_Outcome?.responseData  = myResponseData
            
        } //if myCallTask.CallType_Head_Outcome?.urlCreationError == nil
        
        myYieldToDelegate()
        
        return myCallTask
    }  //func myHeadCompletionFunc
    
    //***************************************************************
    //***************        func myPostCompletionFunc
    //***************************************************************
    // This function is called from within the completion handler of the datatask and therefore all the async execution for this call has been completed.  The completed
    // call tasks are placed in the completed queue in the order completed. Network and server delays will cause calls in the completed queue to be in a different order
    // that the uncompleted queue. If there is an interdependancy of calls then you will have to check the completed que to make sure the prerequisite calls have executed.
    //
    func myPostCompletionFunc( calltask  : CallTask,
                               outcomes  : PostCallOutcomes,
                               data      : Data?,
                               response  : URLResponse?,
                               error     : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask           = CallTask()
        var myOutcomes : PostCallOutcomes   = PostCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.POSTCallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                          = calltask
        myOutcomes                          = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Post_Outcome    = myOutcomes
        
        if myCallTask.CallType_Post_Outcome?.urlCreationError == nil {
            
            guard error == nil else {
                //4) CAPTURE THIS OUTPUT IN TASK AS dataTaskError
                myCallTask.CallType_Post_Outcome?.dataTaskError = "ERROR: myPostCompletionFunc \(error!)"
                myYieldToDelegate()
                return myCallTask
            }  //guard error == nil
            
            guard let myResponseData = data else {
                //5) CAPTURE THIS OUTPUT IN TASK AS responseDataError
                myCallTask.CallType_Post_Outcome?.responseDataError = "Error: myPostCompletionFunc did not receive data"
                myYieldToDelegate()
                return myCallTask
            }  //guard let responseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS responseData
            myCallTask.CallType_Post_Outcome?.urlResponse    = response
            myCallTask.CallType_Post_Outcome?.responseData   = myResponseData
            
        }  //if myCallTask.CallType_Post_Outcome?.urlCreationError == nil
        
        myYieldToDelegate()
        
        return myCallTask
    }  //func myPostCompletionFunc
    
    //***************************************************************
    //***************        func myPutCompletionFunc
    //***************************************************************
    // This function is called from within the completion handler of the datatask and therefore all the async execution for this call has been completed.  The completed
    // call tasks are placed in the completed queue in the order completed. Network and server delays will cause calls in the completed queue to be in a different order
    // that the uncompleted queue. If there is an interdependancy of calls then you will have to check the completed que to make sure the prerequisite calls have executed.
    //
    func myPutCompletionFunc(  calltask  : CallTask,
                               outcomes  : PutCallOutcomes,
                               data      : Data?,
                               response  : URLResponse?,
                               error     : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask           = CallTask()
        var myOutcomes : PutCallOutcomes    = PutCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.PUTCallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                          = calltask
        myOutcomes                          = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Put_Outcome    = myOutcomes
        
        if myCallTask.CallType_Put_Outcome?.urlCreationError == nil {
            
            guard error == nil else {
                //4) CAPTURE THIS OUTPUT IN TASK AS dataTaskError
                myCallTask.CallType_Put_Outcome?.dataTaskError = "ERROR: myPutCompletionFunc \(error!)"
                myYieldToDelegate()
                return myCallTask
            }  //guard error == nil
            
            guard let myResponseData = data else {
                //5) CAPTURE THIS OUTPUT IN TASK AS responseDataError
                myCallTask.CallType_Put_Outcome?.responseDataError = "Error: myPutCompletionFunc did not receive data"
                myYieldToDelegate()
                return myCallTask
            }  //guard let responseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS responseData
            myCallTask.CallType_Put_Outcome?.urlResponse    = response
            myCallTask.CallType_Put_Outcome?.responseData   = myResponseData
            
        }  //if myCallTask.CallType_Put_Outcome?.urlCreationError == nil
        
        myYieldToDelegate()
        
        return myCallTask
    }  //func myPutCompletionFunc
    
    //***************************************************************
    //***************        func myPatchCompletionFunc
    //***************************************************************
    // This function is called from within the completion handler of the datatask and therefore all the async execution for this call has been completed.  The completed
    // call tasks are placed in the completed queue in the order completed. Network and server delays will cause calls in the completed queue to be in a different order
    // that the uncompleted queue. If there is an interdependancy of calls then you will have to check the completed que to make sure the prerequisite calls have executed.
    //
    func myPatchCompletionFunc(  calltask  : CallTask,
                                 outcomes  : PatchCallOutcomes,
                                 data      : Data?,
                                 response  : URLResponse?,
                                 error     : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask           = CallTask()
        var myOutcomes : PatchCallOutcomes  = PatchCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.PATCHCallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                          = calltask
        myOutcomes                          = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Patch_Outcome    = myOutcomes
        
        if myCallTask.CallType_Patch_Outcome?.urlCreationError == nil {
            
            guard error == nil else {
                //4) CAPTURE THIS OUTPUT IN TASK AS dataTaskError
                myCallTask.CallType_Patch_Outcome?.dataTaskError = "ERROR: myPatchCompletionFunc \(error!)"
                myYieldToDelegate()
                return myCallTask
            }  //guard error == nil
            
            guard let myResponseData = data else {
                //5) CAPTURE THIS OUTPUT IN TASK AS responseDataError
                myCallTask.CallType_Patch_Outcome?.responseDataError = "Error: myPatchCompletionFunc did not receive data"
                myYieldToDelegate()
                return myCallTask
            }  //guard let responseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS responseData
            myCallTask.CallType_Patch_Outcome?.urlResponse    = response
            myCallTask.CallType_Patch_Outcome?.responseData   = myResponseData
            
        }  //if myCallTask.CallType_Patch_Outcome?.urlCreationError == nil
        
        myYieldToDelegate()
        
        return myCallTask
    }  //func myPatchCompletionFunc
    
    //***************************************************************
    //***************        func myDeleteCompletionFunc
    //***************************************************************
    func myDeleteCompletionFunc( calltask : CallTask,
                                 outcomes : DeleteCallOutcomes,
                                 data     : Data?,
                                 response : URLResponse?,
                                 error    : Error? ) -> CallTask {
        
        //Allocate a local variable storage
        var myCallTask : CallTask             = CallTask()
        var myOutcomes : DeleteCallOutcomes   = DeleteCallOutcomes()
        
        //***************************************************************
        //***************        NESTED func myYieldToDelegate()
        //***************************************************************
        func myYieldToDelegate() {
            gettimeofday(&myOutcomes.CallUserProcStartTime, nil)
            lgCallQueueUserHooksDelegate?.DELETECallCompleted( calltask: myCallTask, outcomes: myOutcomes )
            gettimeofday(&myOutcomes.CallProcEndTime , nil)
        }  // NESTED func myYieldToDelegate()
        
        //Copy Values
        myCallTask                            = calltask
        myOutcomes                            = outcomes
        
        //Get a completion time...for reference this could be done earlier in the execution to be more accurate
        gettimeofday(&myOutcomes.CallProcStartTime , nil)
        
        //Assemble Local Copy
        myCallTask.CallType_Delete_Outcome  = myOutcomes
        
        if myCallTask.CallType_Delete_Outcome?.urlCreationError == nil {
            
            guard let _ = data else {
                //2) CAPTURE THIS OUTPUT IN TASK AS responseDataError
                myCallTask.CallType_Delete_Outcome?.responseDataError = "Error: myDeleteCompletionFunc did not receive data"
                myYieldToDelegate()
                return myCallTask
            }
            
            guard let myResponseData = data else {
                //5) CAPTURE THIS OUTPUT IN TASK AS responseDataError
                myCallTask.CallType_Delete_Outcome?.responseDataError = "Error: myDeleteCompletionFunc did not receive data"
                myYieldToDelegate()
                return myCallTask
            }  //guard let responseData = data
            
            //4) CAPTURE responseData OUTPUT IN TASK AS responseData
            myCallTask.CallType_Delete_Outcome?.urlResponse    = response
            myCallTask.CallType_Delete_Outcome?.responseData   = myResponseData
            
        }  //if myCallTask.CallType_Delete_Outcome?.urlCreationError == nil
        
        myYieldToDelegate()
        
        return myCallTask
    }  //func myDeleteCompletionFunc
    
    //***************************************************************
    //***************        func executeCallsSerially()
    //***************************************************************
    func executeCallsSerially() {
        
        executeCallTaskQueueSerially() {
            self.lgCallQueueUserHooksDelegate?.AllCallsCompleted( callhandler: self )
        }  // closure executeRESTCallsQueueSerially()
        
    }  //func executeCallsSerially()
    
    //***************************************************************
    //***************        func executeCallsConcurrently()
    //***************************************************************
    func executeCallsConcurrently() {
        
        executeCallTaskQueueConcurrently() {
            self.lgCallQueueUserHooksDelegate?.AllCallsCompleted( callhandler: self )
        }  // closure executeCallTaskQueueConcurrently()
        
    }  //func executeCallsConcurrently()
    
    //***************************************************************
    //***************        func executeCallTaskQueueConcurrently(completionHandler: @escaping () -> Void)
    //***************************************************************
    //DispatchGroup Array Extension
    //DispatchGroup provides a nice and easy way to synchronize a group of asynchronous operations while still remaining asynchronous
    func executeCallTaskQueueConcurrently(completionHandler: @escaping () -> Void) {
        let group           : DispatchGroup   = DispatchGroup()
        
        for myTask in lgGeneralCallsQueue {
            group.enter()
            self.callStateChange( calltask  : myTask, state : CallHandler.CallStates.Executing )
            
            executeCallTask( task : myTask ) {
                group.leave()
            }  // closure executeCallTask
            
        }  // for myTask in gGeneralCallsQueue
        
        group.notify( queue: .main ) {
            completionHandler()
        }  // group.notify(queue: .main)
        
    }  // func loadConcurrently(completionHandler: @escaping (NoteCollection) -> Void)
    
    //***************************************************************
    //***************        func executeCallTaskQueueSerially(completionHandler: @escaping () -> Void)
    //***************************************************************
    //DispatchSemaphore Array Extension
    //DispatchSemaphore provides a way to synchronously wait for a group of asynchronous tasks.
    func executeCallTaskQueueSerially( completionHandler: @escaping () -> Void) {
        
        // We create a new queue to do our work on, since calling wait() on
        // the semaphore will cause it to block the current queue
        let myExecutionQueue  : DispatchQueue     = DispatchQueue( label: "com.charleszillmann.calltaskqueue", attributes: .concurrent)
        let mySemaphore       : DispatchSemaphore = DispatchSemaphore(value: 1)
        
        lgSemaphore = mySemaphore
        
        for myTask in lgGeneralCallsQueue {
            
            myExecutionQueue.async {
                
                self.callStateChange( calltask  : myTask, state : CallHandler.CallStates.Waiting )
                self.lgSemaphore?.wait()  // requesting the resource
                
                self.callStateChange( calltask  : myTask, state : CallHandler.CallStates.Executing )
                
                self.executeCallTask( task : myTask ) {
                }  //self.executeCallTask( task : myTask )
                
            }  // executionQueue.async
            
        }  // for myTask in gGeneralCallsQueue
        
    }  // func executeCallTaskQueueSerially(completionHandler: @escaping (NoteCollection) -> Void)
    

}  // CallHandler

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallHandler.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
