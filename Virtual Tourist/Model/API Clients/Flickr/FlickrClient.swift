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
    let session = URLSession.shared
    var pinLat: Double!
    var pinLong: Double!
    
    //Mark: TaskForGetMethod - Will send a get request to the flickr API and return a JSON object of photos
    func taskForGetMethod(_ completionHandlerForGet: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: flickrURLFromParameters(buildURLParamters()))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)

            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[FlickrConstants.FlickrResponseKeys.Status] as? String, stat == FlickrConstants.FlickrResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult[FlickrConstants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                displayError("Cannot find keys '\(FlickrConstants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            completionHandlerForGet(photosDictionary, nil)

        }
        
        // start the task!
        task.resume()
        return task
    }
    
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
        if let latitude = pinLat, let longitude = pinLong {
            let minimumLon = max(longitude - FlickrConstants.Flickr.SearchBBoxHalfWidth, FlickrConstants.Flickr.SearchLonRange.0)
            let minimumLat = max(latitude - FlickrConstants.Flickr.SearchBBoxHalfHeight, FlickrConstants.Flickr.SearchLatRange.0)
            let maximumLon = min(longitude + FlickrConstants.Flickr.SearchBBoxHalfWidth, FlickrConstants.Flickr.SearchLonRange.1)
            let maximumLat = min(latitude + FlickrConstants.Flickr.SearchBBoxHalfHeight, FlickrConstants.Flickr.SearchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        } else {
            return "0,0,0,0"
        }
        
        //return ("-81.281566, 25.300159, -79.281566, 27.300159")
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

        return components.url!
    }
    
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
}
