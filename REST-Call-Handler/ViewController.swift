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
            
            let cell        : CallTableViewCell = tableView.dequeueReusableCell( withIdentifier: "QueuedCallCell", for: indexPath ) as! CallTableViewCell
            let myEndpoint  : String            = lgCallHandlerUser?.lgCallHandler.lgGeneralCallsQueue[indexPath.row].Endpoint ?? ""
            let myTag       : String            = lgCallHandlerUser?.lgCallHandler.lgGeneralCallsQueue[indexPath.row].UsersTag ?? ""

            cell.lgIndexLabel.text      = indexPath.row.description + ": "
            cell.lgNameLabel.text       = myTag
            cell.lgDetailLabel.text     = myEndpoint
            cell.lgActivityView.backgroundColor = UIColor.lightGray

            return cell
        }  // func tableView cellForRowAt
        
    }  // extension ViewController: UITableViewDataSource

    extension ViewController : CallStateUIDelegate {
        
        func CallStateUIChange(   index : Int,  uuid : UUID, state  : CallHandler.CallStates ) {

            if let myCell = callsTableView.cellForRow( at: IndexPath( row : index, section : 0 ) ) as! CallTableViewCell? {
                switch state {
                case .Queued:
                    //myCell.lgSpinner.start(from: myCell.lgActivityView )
                    myCell.lgActivityView.startAnimating()
                    myCell.lgIndexLabel.backgroundColor = .white
                case .Waiting:
                    myCell.lgIndexLabel.backgroundColor = .red
                case .Executing:
                    myCell.lgIndexLabel.backgroundColor = .green
                case .Complete:
                    //myCell.lgSpinner.stop()
                    myCell.lgActivityView.stopAnimating()
                    myCell.lgIndexLabel.backgroundColor = .blue
                }
            }
            
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
