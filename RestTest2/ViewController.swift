//
//  ViewController.swift
//  RestTest
//
//  Created by paciffic on 2015. 6. 18..
//  Copyright (c) 2015년 paciffic. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var btnGet: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBAction func tfUsername_Return(sender: AnyObject) {
            sender.resignFirstResponder()
    }
    
    @IBAction func tfEmail_Return(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func tfFirstName_Return(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func tfLastName_Return(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func btnSend_Pushed(sender: AnyObject) {
        print("Send Button was pushed!!!")
        json_encoding()
    }
    
    @IBAction func btnGet_Pushed(sender: AnyObject) {
        print("Get Button was pushed!!!")
        
        json_parsing()
        
//    var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888")!)
//            httpGet(request){
//                (data, error) -> Void in
//                if error != nil {
//                    println(error)
//                    self.tfMsg.text = error
//                } else {
//                    println(data)
//                    self.tfMsg.text = "success"
//                    self.tfContent.text = data
//                }
//        }
    
    }
    
    // response받은 데이터를 json에서 parsing하는 함수
    func json_parsing()
    {
        let urlAsString = "http://localhost:8888/send"
        let url = NSURL(string:urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err : NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if(err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            
            let jsonUsername : String! =  jsonResult["username"] as String
            let jsonEmail : String! = jsonResult["email"] as String
            let jsonFirstName : String! = jsonResult["firstName"] as String
            let jsonLastName : String! = jsonResult["lastName"] as String
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tfUsername.text = jsonUsername
                self.tfEmail.text = jsonEmail
                self.tfFirstName.text = jsonFirstName
                self.tfLastName.text = jsonLastName
            })
        })
        
        jsonQuery.resume()
    }
    
    // json 타입으로 encoding하는 함수
    func json_encoding()
    {
        let urlAsString = "http://localhost:8888/get"
        let url = NSURL(string:urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        var jsonObject : [AnyObject]
        
        if (tfUsername.text == "")
        {
            jsonObject = [
                ["username":"babo", "email":"babo@gmail.com", "firstName":"Babo", "lastName":"Na"]]
            
        }
        else
        {
            jsonObject = [
                ["username":tfUsername.text, "email":tfEmail.text, "firstName":tfFirstName.text, "lastName":tfLastName.text]]
        }
        
        let jsonString = JSONStringify(jsonObject)
        print(jsonString)
        
        //let jsonStringPretty = JSONStringify(jsonObject, prettyPrinted: true)
        //print(jsonStringPretty)
        
        var request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response : NSURLResponse?
        var err : NSError?
        var queue : NSOperationQueue = NSOperationQueue()
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        //print(request.HTTPBody)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            })
        
        if response == nil{
            print("\nrequest is successed!!")
        } else {
            print("\nrequest is failed!")
        }
        
        
        //        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
//            if (error != nil) {
//                println(error.localizedDescription)
//            }
//            var err : NSError?
//            
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
//            
//            if(err != nil) {
//                print("JSON Error \(err!.localizedDescription)")
//            }
//            
// 
//            })
//       
//        jsonQuery.resume()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        tfUsername.endEditing(true) || tfEmail.endEditing(true) || tfFirstName.endEditing(true) || tfLastName.endEditing(true)
  
    }
    
    // JSON String화를 위한 함수
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string
            }
          }
        }
        return ""
    }
    
    // http Get처리 함수
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
            var session = NSURLSession.sharedSession()
            var task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    callback("", error.localizedDescription)
                } else {
                    var result = NSString(data: data, encoding:
                        NSASCIIStringEncoding)!
                    callback(result as String, nil)
                }
            }
            task.resume()
    }


}

