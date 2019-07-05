/*************************************************************************
 MIT License
 
 Copyright (c) 2019  ViewController.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class ViewController: UIViewController, gMsgLogDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class ViewController : UIViewController, gMsgLogDelegate {
    var lgCallGroupUser                   : CallGroupUser?          = CallGroupUser()
    
    @IBOutlet weak var callGroupProgress    : GroupProgressIndicator!
    @IBOutlet weak var callsTableView       : UITableView!
    @IBOutlet weak var btnLog               : UIBarButtonItem!
    
    
    @IBAction func btnLogPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowLogSeque", sender: self)
    }
    
    //***************************************************************
    //***************        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //***************************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowLogSeque" {
            //            if let nextViewController = segue.destination as? LogViewController {
            //                nextViewController.navBar.  .valueOfxyz = "XYZ" //Or pass any values
            //                nextViewController.valueOf123 = 123
            //            }
        }  // if segue.identifier == "MySegueId"
        
    }  // override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    //***************************************************************
    //***************        override func viewDidLoad()
    //***************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        callsTableView.register( CallTableViewCell.self, forCellReuseIdentifier: "QueuedCallCell" )
        
        // Do any additional setup after loading the view.
        gMsgLog.lgDelegate                          = self
        callsTableView.dataSource                   = self
        callsTableView.delegate                     = self
        
        lgCallGroupUser?.lgCallStateUIDelegate    = self
        lgCallGroupUser?.lgProgressIndicator      = callGroupProgress
        QueueFailingTestCalls()
        QueuePassingTestCalls()
        
        gMsgLog.ClearLog()
        btnLog.title = "Log(0)"
    }  // override func viewDidLoad()
    
    //***************************************************************
    //***************        @IBAction func btnReset(_ sender: Any)
    //***************************************************************
    @IBAction func btnReset(_ sender: Any) {
        gMsgLog.ClearLog()
        btnLog.title = "Log(0)"
        
        lgCallGroupUser?.reset()
        QueueFailingTestCalls()
        QueuePassingTestCalls()
        callsTableView.reloadData()
    }  // @IBAction func btnReset(_ sender: Any)
    
    //***************************************************************
    //***************        @IBAction func btnRun(_ sender: Any)
    //***************************************************************
    @IBAction func btnRun(_ sender: Any) {
        
        if let myCallGroup = lgCallGroupUser {
            gMsgLog.ClearLog()
            btnLog.title = "Log(0)"
            
            myCallGroup.MakeCalls()
        }  // if let myCallGroup = CallGroup
        
    }  // @IBAction func btnRun(_ sender: Any)
    
    //***************************************************************
    //***************        func newMsgLogged()
    //***************************************************************
    func newMsgLogged() {
        btnLog.title = "Log(\(gMsgLog.lgMsgLog.count))"
    }  // func newMsgLogged()
    
}  // class ViewController: UIViewController

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        extension ViewController: UITableViewDataSource, UITableViewDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    //***************************************************************
    //***************        override func tableView heightForRowAt
    //***************************************************************
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }  //override func tableView heightForRowAt
    
    //***************************************************************
    //***************        func tableView numberOfRowsInSection
    //***************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lgCallGroupUser?.queuedCallsCount() ?? 0
    }  // func tableView numberOfRowsInSection
    
    //***************************************************************
    //***************            func tableView cellForRowAt
    //***************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myEndpoint  : String        = ""
        var myTag       : String        = ""
        
        let myCell  : CallTableViewCell = tableView.dequeueReusableCell( withIdentifier: "QueuedCallCell", for: indexPath ) as! CallTableViewCell
        
        if let myUUID : UUID = lgCallGroupUser?.queuedCallsUUID( index : indexPath.row ) {
            
            if let myCallTask = lgCallGroupUser?.queuedCallTaskforUUID( uuid : myUUID ) {
                myEndpoint  = myCallTask.Endpoint
                myTag       = myCallTask.UsersTag ?? ""
                if myTag == "" { myTag       = "NO USER TAG" }
                
                if let myState = lgCallGroupUser?.queuedCallStateforUUID( uuid : myUUID ) {
                    myCell.SetCallCellState( state : myState )
                }  // if let myState
                
                myCell.lgIndexLabel.text              = indexPath.row.description
                myCell.lgNameLabel.text               = myTag
                myCell.lgDetailLabel.text             = myEndpoint
                
            }  // if let myCallTask
            
        }  // if let myUUID
        
        return myCell
    }  // func tableView cellForRowAt
    
}  // extension ViewController: UITableViewDataSource

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        extension ViewController : CallStateUIDelegate
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
extension ViewController : CallStateUIDelegate {
    
    //***************************************************************
    //***************            func CallStateUIChange(   index : Int,  uuid : UUID, state  : CallGroup.CallStates )
    //***************************************************************
    func CallStateUIChange( uuid : UUID, state  : CallGroup.CallStates ) {
        
        if let myIndex = lgCallGroupUser?.queuedCallIndexforUUID( uuid: uuid ) {
            
            if let myCell = callsTableView.cellForRow( at: IndexPath( row : myIndex, section : 0 ) ) as! CallTableViewCell? {
                myCell.SetCallCellState( state : state )
            } // if let myCell
            
        }  // if let myIndex
        
    }  // func CallStateUIChange(   index : Int,  uuid : UUID, state  : CallGroup.CallStates )
    
}  // extension ViewController : CallStateUIDelegate


extension ViewController {
    
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
        
        lgCallGroupUser?.queueURIRequest( t : "Generate an error with URL Creation: unsafe character }",
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
        
        lgCallGroupUser?.queueURIRequest(  t : "Generate an error with myGetCompletionFunc guard error == nil else",
                                      r : myErroredRequest2 )
        
        
        let myHEADRequest1     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                             a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                             r : "/api/v1/employees",
                                                                             p : path( v : [:],
                                                                                       q : [:] ) ),
                                                                m: methodtype.HEAD,
                                                                h: headers( pairs: [:] ),
                                                                d: databody( items: [] ) )
        
        lgCallGroupUser?.queueURIRequest( t: "Make a successful HEAD Request",
                                     r : myHEADRequest1 )
        
        let myHEADRequest2     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                             a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                             r : "/api/v1/employeet",
                                                                             p : path( v : [:],
                                                                                       q : [:] ) ),
                                                                m: methodtype.HEAD,
                                                                h: headers( pairs: [:] ),
                                                                d: databody( items: [] ) )
        
        lgCallGroupUser?.queueURIRequest( t: "Make an unsuccessful HEAD Request",
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
        lgCallGroupUser?.queueURIRequest( t: "", r : myRequest1 )
        
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
        
        //let myNewObj                    : [String: Any] = ["name":UUID().uuidString,"salary":"123","age":"23"]
        
        lgCallGroupUser?.queueURIRequest( t : "", r : myRequest2 )
        
        let myRequest3     : CallRequest     = CallRequest( e: endpoint( s : "https:",
                                                                         a : authority( user: "", pw: "", h: "dummy.restapiexample.com", p: "" ),
                                                                         r : "/api/v1/employees",
                                                                         p : path( v : [:],
                                                                                   q : [:] ) ),
                                                            m: methodtype.GET,
                                                            h: headers( pairs: [:] ),
                                                            d: databody( items: [] ) )
        lgCallGroupUser?.queueURIRequest( t: "", r : myRequest3 )
        
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
    
}

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END ViewController.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
