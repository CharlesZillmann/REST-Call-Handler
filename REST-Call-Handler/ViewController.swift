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
        lgCallGroupUser?.QueueFailingTestCalls()
        lgCallGroupUser?.QueuePassingTestCalls()
        
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
        lgCallGroupUser?.QueueFailingTestCalls()
        lgCallGroupUser?.QueuePassingTestCalls()
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

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END ViewController.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
