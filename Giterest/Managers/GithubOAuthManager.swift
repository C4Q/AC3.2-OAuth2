//
//  GithubOAuthManager.swift
//  Giterest
//
//  Created by Louis Tur on 11/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum GithubScope: String {
  case user, public_repo
}

class GithubOAuthManager {
  
  // auth_code part
  static let authorizationURL: URL = URL(string: "https://github.com/login/oauth/authorize")!
  static let redirectURL: URL = URL(string: "giterest://auth.url")!
  
  // auth_token part
  static let accessTokenURL: URL = URL(string: "https://github.com/login/oauth/access_token")!
  
  // keep reference to values we may need to use later
  private var clientID: String?
  private var clientSecret: String?
  private var accessToken: String?
  
  // singleton
  static let shared: GithubOAuthManager = GithubOAuthManager()
  private init () {}
  
  // Class function to set up our manager (code design purely)
  class func configure(clientID: String, clientSecret: String) {
    shared.clientID = clientID
    shared.clientSecret = clientSecret
  }
  
  func requestAuthorization(scopes: [GithubScope]) throws {
    guard
      let clientID = self.clientID,
      let clientSecret = self.clientSecret
    else {
        throw NSError(domain: "Client ID/Client Secret not set", code: 1, userInfo: nil)
    }
    
    let clientIDQuery = URLQueryItem(name: "client_id", value: clientID)
    let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: GithubOAuthManager.redirectURL.absoluteString)
    let scopeQuery: URLQueryItem = URLQueryItem(name: "scope", value: scopes.flatMap { $0.rawValue }.joined(separator: " ") )
    
    
    var components = URLComponents(url: GithubOAuthManager.authorizationURL, resolvingAgainstBaseURL: true)
    components?.queryItems = [clientIDQuery, redirectURLQuery, scopeQuery]
    
    UIApplication.shared.open(components!.url!, options: [:], completionHandler: nil)
  }
  
  func requestAuthToken(url: URL) {
    
    // The url that gets passed into this function should look like: giterest://auth.url?code=klasjdlkasjdlaksjdalskj
    // We're really only interested in retrieving the actual value of the code, so we'll need to parse out the URL in some manner
    var accessCode: String = ""
    
    // 1. create a URLComponent
    // -> We can simplify what we need to do for parsing by creating a new URLComponent from our url
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
      
      // 2. check its query items
      // -> Just as we used URLQueryItem to build our URLComponent earlier, we can break down a URLComponents instance into its 
      // -> various properties, including .queryItems
      for queryItem in components.queryItems! {
        
        // 3. look for "code"
        // -> We simply iterate over our array of queryItems, looking for the item that has "code" as its .name property
        if queryItem.name == "code" {
          accessCode = queryItem.value!
        }
      }
    }
    print("Access Code: \(accessCode)")
    
    // --- Exercise Instructions -- //
    // ** Use URLComponents + URLQueryItems to build request URL **
    // 1. Make the POST request to the auth token endpoint
    // 2. Get the response to the point where it is Data
    
    // Required params for POST request
    // 1. client_id
    // 2. client_secret
    // 3. access_code
    // 4. redirect_uri
    
    // URLRequest is good, but:
    //    Correct: httpMethod, base url, headers
    //    Incorrect: we don't end up using it and no query items, so the full URL isn't correct
    var request = URLRequest(url: GithubOAuthManager.accessTokenURL)
    request.httpMethod = "POST"
    // this header value is optional; it will send back a String/URL compatible Data object if you don't specific application/json
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let clientIDQuery = URLQueryItem(name: "client_id", value: self.clientID!)
    let clientSecretQuery = URLQueryItem(name: "client_secret", value: self.clientSecret!)
    let codeQuery = URLQueryItem(name: "code", value: accessCode)
    let redirectURIQuery = URLQueryItem(name: "redirect_uri", value: GithubOAuthManager.redirectURL.absoluteString)
    
    // URLComponents is good, but:
    //    Correct: url, query items
    //    Incorrect: no httpMethod specified, no headers
    var components = URLComponents(string: GithubOAuthManager.accessTokenURL.absoluteString)
    components?.queryItems = [
      clientIDQuery,
      clientSecretQuery,
      codeQuery,
      redirectURIQuery
    ]
    
    /*
      You must draw an important distinction between URLComponents and URLRequest: 
        - URLComponents: used for building/deconstructing a URL, can be decomposed into its separate properties/components
        - URLRequest: details the entirety of a web-based request. One of those details is the URL, but there are many other:
          headers, http method, http body, etc. A URLRequest encapsulates all details of a request.
     */
    
    // This line is what tied our URLRequest together with our URLComponents
    request.url = components?.url
    
    // launch our URLSession
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      
      if error != nil {
        print("ERROR: \(error!)")
      }
      
      if response != nil {
        print(response!)
      }
      
      if data != nil {
        
        // If we dont specify an Accept value of application/json, we can still parse out the data into either a string or url
//        if let accessTokenString = String(data: data!, encoding: String.Encoding.utf8) {
//          
//          // TODO: add parsing
//          
//        }
        
        
        // If we set our application header to Accept application/json, we can parse out the response using JSONSerialization
        do {
          let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
          
          if let validJson = json {
            print(validJson)
            
            // valid json is of type [String : Any]
            // we need "access_token"
            self.accessToken = validJson["access_token"] as? String
          }
        
        }
        catch {
          print("Error parsing: \(error)")
        }
      }
      
      }.resume()
  }
  
}
