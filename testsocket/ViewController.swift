//
//  ViewController.swift
//  testsocket
//
//  Created by clm on 2017/7/9.
//  Copyright © 2017年 clm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let host = "192.168.0.129"
    let port = 8234
    var client: TCPClient?
    var pidP=7
    var ss:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client = TCPClient(address: host, port: Int32(port))
    }
  
    @IBOutlet weak var testView: UITextView!
    @IBAction func SendMessage(_ sender: Any) {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            ss=String(format: "%03d",pidP)
            if let response = sendRequest(string: ss, using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }

        
    }
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        appendToTextField(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    private func appendToTextField(string: String) {
        print(string)
        testView.text = testView.text.appending("\n\(string)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

