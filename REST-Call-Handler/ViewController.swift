/*************************************************************************
 MIT License
 
 Copyright (c) 2019  ViewController.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

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
        
        // Do any additional setup after loading the view.
        gMsgLog.lgDelegate                          = self
        outputTextView.text                         = ""
        callsTableView.dataSource                   = self
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

extension ViewController: UITableViewDataSource {
    
    //***************************************************************
    //***************        func tableView numberOfRowsInSection
    //***************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lgCallHandlerUser?.lgCallHandler.gGeneralCallsQueue.count  ?? 0
    }  // func tableView numberOfRowsInSection
    
    //***************************************************************
    //***************            func tableView cellForRowAt
    //***************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "QueuedCallCell", for: indexPath )
        let myEndpoint : String     = lgCallHandlerUser?.lgCallHandler.gGeneralCallsQueue[indexPath.row].Endpoint ?? ""
        let myTag      : String     = lgCallHandlerUser?.lgCallHandler.gGeneralCallsQueue[indexPath.row].UsersTag ?? ""

        cell.textLabel?.text        = indexPath.row.description + ": " + myTag
        cell.detailTextLabel?.text  = myEndpoint
        
        return cell
    }  // func tableView cellForRowAt
    
}  // extension ViewController: UITableViewDataSource

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END ViewController.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
