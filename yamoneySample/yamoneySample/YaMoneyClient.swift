//
//  YaMoneyClient.swift
//  yamoneySample
//
//  Created by Artem Lobanov on 19/08/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

import Foundation

class YaMoneyClient {
    
    let url: NSURL! = NSURL(string: "https://money.yandex.ru/api/categories-list")
    
    static let sharedClient = YaMoneyClient()
    
    private init() {}
    
    func getCategoriesWithCompletion(completionHandler: (jsonData: NSData?, error: NSError?) -> Void) {
        let request = NSURLRequest(URL: url)
        
        var session = NSURLSession.sharedSession()
        
        (session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let downloadErr = downloadError {
                println("Networking error, \(downloadErr.description)");
                completionHandler(jsonData: nil, error: downloadError)
            } else {
                if let httpResp = response as? NSHTTPURLResponse {
                    if httpResp.statusCode != 200 {
                        println("Request error, status code \(httpResp.statusCode)");
                        completionHandler(jsonData: nil, error: NSError())
                    } else {
                        completionHandler(jsonData: data, error: nil)
                    }
                }
            }
        })).resume()
    }
}