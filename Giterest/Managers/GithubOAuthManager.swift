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
  
  private var clientID: String?
  private var clientSecret: String?
  private var accessToken: String?
  
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
    // giterest://auth.url?code=klasjdlkasjdlaksjdalskj
    
    var accessCode: String = ""
    
    // 1. create a URLComponent
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
      
      // 2. check its query items
      for queryItem in components.queryItems! {
        
        // 3. look for "code"
        if queryItem.name == "code" {
          accessCode = queryItem.value!
        }
      }
    }
    print("Access Code: \(accessCode)")
    
    // Required params:
    // 1. client_id
    // 2. client_secret
    // 3. access_code
    // 4. redirect_uri
    
    // Request is good
    // Correct: httpMethod, url, headers
    // Incorrect: we don't end up using it! and no query items
    var request = URLRequest(url: GithubOAuthManager.accessTokenURL)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let clientIDQuery = URLQueryItem(name: "client_id", value: self.clientID!)
    let clientSecretQuery = URLQueryItem(name: "client_secret", value: self.clientSecret!)
    let codeQuery = URLQueryItem(name: "code", value: accessCode)
    let redirectURIQuery = URLQueryItem(name: "redirect_uri", value: GithubOAuthManager.redirectURL.absoluteString)
    
    // Components is good
    // Correct: url, query items
    // Incorrect: httpMethod, headers
    var components = URLComponents(string: GithubOAuthManager.accessTokenURL.absoluteString)
    components?.queryItems = [
      clientIDQuery,
      clientSecretQuery,
      codeQuery,
      redirectURIQuery
    ]
    
    request.url = components?.url
    
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      
      if error != nil {
        print("ERROR: \(error!)")
      }
      
      if response != nil {
        print(response!)
      }
      
      
      if data != nil {
        
//        if let accessTokenString = String(data: data!, encoding: String.Encoding.utf8) {
//          
//          // TODO: add parsing
//          
//        }
        
        
        do {
          let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
          
          if let validJson = json {
            print(validJson)
            
            // valid json is of type [String : Any]
            // we need "access_token"
            // assign self.accessToken = access_token!
            self.accessToken = validJson["access_token"] as? String
          }
        
        }
        catch {
          print("Error parsing: \(error)")
        }
      }
      
      }.resume()

    
    
    // ** Use URLComponents + URLQueryItems to build request URL ** 
    
    // 1. Make the POST request to the auth token endpoint
    // 2. Get the response to the point where it is Data
  }
  
}
