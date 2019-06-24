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
class ViewController: UIViewController, gMsgLogDelegate {
    var lgCallHandlerUser   : CallHandlerUser?              = CallHandlerUser()
    var lgSpinner           : CallActivityIndicator         = CallActivityIndicator()
    
    @IBOutlet weak var callActivityIndicator    : UIView!
    
    @IBOutlet weak var callGroupProgress        : GroupProgressIndicator!
    
    @IBOutlet weak var callsTableView : UITableView!
    
    @IBOutlet weak var outputTextView : UITextView!
    
    //***************************************************************
    //***************        override func viewDidLoad()
    //***************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        callsTableView.register( CallTableViewCell.self, forCellReuseIdentifier: "QueuedCallCell" )
        
        // Do any additional setup after loading the view.
        gMsgLog.lgDelegate                          = self
        outputTextView.text                         = ""
        callsTableView.dataSource                   = self
        callsTableView.delegate                     = self
        
        lgCallHandlerUser?.lgCallStateUIDelegate    = self
        lgCallHandlerUser?.lgProgressIndicator      = callGroupProgress
        lgCallHandlerUser?.QueueFailingTestCalls()
        lgCallHandlerUser?.QueuePassingTestCalls()
        
    }  // override func viewDidLoad()
    
    //***************************************************************
    //***************        @IBAction func btnReset(_ sender: Any)
    //***************************************************************
    @IBAction func btnReset(_ sender: Any) {
        gMsgLog.ClearLog()
        outputTextView.text = ""
        lgCallHandlerUser?.ClearCallQueue()
        lgCallHandlerUser?.QueueFailingTestCalls()
        lgCallHandlerUser?.QueuePassingTestCalls()
        callsTableView.reloadData()
        
    }  // @IBAction func btnReset(_ sender: Any)
    
    //***************************************************************
    //***************        @IBAction func btnRun(_ sender: Any)
    //***************************************************************
    @IBAction func btnRun(_ sender: Any) {
        lgSpinner.start( from: callActivityIndicator )
        
        if let myCallHandler = lgCallHandlerUser {
            outputTextView.text = ""
            myCallHandler.MakeCalls()
            outputTextView.text = gMsgLog.LogAsText()
        }  // if let myCallHandler = callHandler
        
    }  // @IBAction func btnRun(_ sender: Any)
    
    //***************************************************************
    //***************        func newMsgLogged()
    //***************************************************************
    func newMsgLogged() {
        self.outputTextView.text = gMsgLog.LogAsText()
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
        return 100.0
    }  //override func tableView heightForRowAt
    
    //***************************************************************
    //***************        func tableView numberOfRowsInSection
    //***************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lgCallHandlerUser?.lgCallHandler.lgGeneralCallsQueue.count  ?? 0
    }  // func tableView numberOfRowsInSection
    
    //***************************************************************
    //***************            func tableView cellForRowAt
    //***************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell  : CallTableViewCell = tableView.dequeueReusableCell( withIdentifier: "QueuedCallCell", for: indexPath ) as! CallTableViewCell
        
        if let myUUID : UUID = lgCallHandlerUser?.lgCallHandler.lgGeneralCallsQueue[indexPath.row].TaskUUID {
            
            let myEndpoint  : String        = lgCallHandlerUser?.lgCallHandler.lgGeneralCallsQueue[indexPath.row].Endpoint ?? ""
            let myTag       : String        = lgCallHandlerUser?.lgCallHandler.lgGeneralCallsQueue[indexPath.row].UsersTag ?? ""
            
            if let myState  : CallHandler.CallStates = lgCallHandlerUser?.GetStateForCall( uuid : myUUID ) {
                SetCallCellState( cell : myCell, state : myState )
            }  // if let myState
            
            myCell.lgIndexLabel.text              = indexPath.row.description + ": "
            myCell.lgNameLabel.text               = myTag
            myCell.lgDetailLabel.text             = myEndpoint
        }
        
        return myCell
    }  // func tableView cellForRowAt
    
    //***************************************************************
    //***************            func SetCallCellState( cell : CallTableViewCell, state : CallHandler.CallStates )
    //***************************************************************
    func SetCallCellState( cell : CallTableViewCell, state : CallHandler.CallStates ) {
        
        switch state {
        case .Queued:
            //myCell.lgSpinner.start(from: myCell.lgActivityView )
            //cell.lgActivityView.startAnimating()
            cell.lgIndexLabel.backgroundColor = .white
        case .Waiting:
            cell.lgIndexLabel.backgroundColor = .yellow
        case .Executing:
            cell.lgIndexLabel.backgroundColor = .green
        case .Complete:
            //myCell.lgSpinner.stop()
            //cell.lgActivityView.stopAnimating()
            cell.lgIndexLabel.backgroundColor = .white
        }  // switch state
        
    }  // func SetCallCellState( cell : CallTableViewCell, state : CallHandler.CallStates )
    
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
    //***************            func CallStateUIChange(   index : Int,  uuid : UUID, state  : CallHandler.CallStates )
    //***************************************************************
    func CallStateUIChange(   index : Int,  uuid : UUID, state  : CallHandler.CallStates ) {
        
        if let myCell = callsTableView.cellForRow( at: IndexPath( row : index, section : 0 ) ) as! CallTableViewCell? {
            SetCallCellState( cell : myCell, state : state )
        }  // if let myCell
        
    }  // func CallStateUIChange(   index : Int,  uuid : UUID, state  : CallHandler.CallStates )
    
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
