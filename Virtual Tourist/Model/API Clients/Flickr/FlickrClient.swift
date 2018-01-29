//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 1/28/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    //Mark: Variable Declaration
    var pinLat: Double!
    var pinLong: Double!
    
    //Mark: TaskForGetMethod - Will send a get request to the flickr API and return a JSON object of photos
//    func taskForGetMethod(_ completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        
//        
//    }
    
}

extension FlickrClient {
    
    func buildURLParamters() -> ([String:AnyObject]) {
        
        let methodParameters = [
            FlickrConstants.FlickrParameterKeys.Method: FlickrConstants.FlickrParameterValues.SearchMethod,
            FlickrConstants.FlickrParameterKeys.APIKey: FlickrConstants.FlickrParameterValues.APIKey,
            FlickrConstants.FlickrParameterKeys.BoundingBox: bboxString(),
            FlickrConstants.FlickrParameterKeys.SafeSearch: FlickrConstants.FlickrParameterValues.UseSafeSearch,
            FlickrConstants.FlickrParameterKeys.Extras: FlickrConstants.FlickrParameterValues.MediumURL,
            FlickrConstants.FlickrParameterKeys.Format: FlickrConstants.FlickrParameterValues.ResponseFormat,
            FlickrConstants.FlickrParameterKeys.NoJSONCallback: FlickrConstants.FlickrParameterValues.DisableJSONCallback
        ]
        return methodParameters as [String:AnyObject]
    }
    
    func bboxString() -> String {
        return ("-81.281566, 25.300159, -79.281566, 27.300159")
    }
    
    
    
    func flickrURLFromParameters(_ paramters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = FlickrConstants.Flickr.APIScheme
        components.host = FlickrConstants.Flickr.APIHost
        components.path = FlickrConstants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in paramters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
        print("1")
        return components.url!
    }
    
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
}
