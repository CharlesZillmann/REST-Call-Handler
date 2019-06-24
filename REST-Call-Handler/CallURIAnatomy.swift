/*************************************************************************
 MIT License
 
 Copyright (c) 2019  CallURIAnatomy.swift Charles Zillmann charles.zillmann@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

//***************************************************************
//***************        enum methodtypes : String
//***************************************************************
enum methodtype : String {
    case OPTIONS        = "OPTIONS"
    case GET            = "GET"
    case HEAD           = "HEAD"
    case POST           = "POST"
    case PUT            = "PUT"
    case PATCH          = "PATCH"
    case DELETE         = "DELETE"
    case NONESPECIFIED  = "NONESPECIFIED"
}  //enum methodtypes

//***************************************************************
//***************        struct databody
//***************************************************************
struct databody {
    
    struct dataitem {
        var scheme              : String        = ""       //https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml
        var mediatype           : String        = ""       //https://www.iana.org/assignments/media-types/media-types.xhtml
        var base64extension     : String        = ""       // "" or ";base64"
        var dataforitem         : String        = ""
    }  //struct dataitem
    
    var dataitems               : [dataitem]    =  [dataitem]()
    
    //***************************************************************
    //***************        init( items: [dataitem]  )
    //***************************************************************
    init( items: [dataitem]  ) {
        dataitems   = items
    } //init( items: [dataitem] )
    
    //***************************************************************
    //***************        func render () -> String
    //***************************************************************
    func render () -> String {
        //data:text/vnd-example+xyz;foo=bar;base64,R0lGODdh
        var myString = ""
        for item in dataitems {
            myString = myString + "data:\(item.scheme);\(item.mediatype);\(item.base64extension),\(item.dataforitem)"
        }  //for item in dataitems
        
        return myString
    }  //func render ()
    
}  //struct databody

//***************************************************************
//***************        class headers
//***************************************************************
class headers {
    var pvpairs : [String:Any]    =  [String:Any]() //"Content-Type: application/json"
    
    //***************************************************************
    //***************        init( pairs: [String:Any] )
    //***************************************************************
    init( pairs: [String:Any] ) {
        pvpairs        = pairs
    } //init( pairs: [String:Any] )
    
    //***************************************************************
    //***************        func render () -> String
    //***************************************************************
    func render () -> String {
        
        var myString = ""
        for item in pvpairs {
            myString = myString + "\"\(item.key): \(item.value)\""
        } //for item in pvpairs
        
        return myString
    }  //func render ()
    
}  //class headers

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class path
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class path {
    var pVariables          : [String:Any]      =  [String:Any]() ///users/:username/repos -> https://api.github.com/users/zellwk/repos
    var pQueryParameters    : [String:Any]      =  [String:Any]() //render to: ?query1=value1&query2=value2
    
    //***************************************************************
    //***************        init( v: [String:Any], q: [String:Any] )
    //***************************************************************
    init( v: [String:Any], q: [String:Any] ) {
        pVariables        = v
        pQueryParameters  = q
    } //init( s: String, r: String, p: path )
    
    //***************************************************************
    //***************        func render () -> String
    //***************************************************************
    func render ( rootendpoint: String ) -> String {
        var myString = rootendpoint
        
        //Substitute Variables
        for item in pVariables {
            
            let myVar = ":\(item.key)/"
            let myVal = "\(item.value)/"
            myString = myString.replacingOccurrences(of: myVar, with: myVal)
            
        }  //for item in pVariables
        
        //Append Query Parameters and Values
        if pQueryParameters.count > 0 {
            myString = myString + "?"
            
            for item in pQueryParameters {
                myString = myString + "\(item.key)=\(item.value)&"
            }  //for item in pQueryParameters
            
            myString.removeLast() // removeLast "&"
            
        }  //if pQueryParameters.count > 0
        
        return myString
    }  //func render ()
    
}  //class path

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class authority
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class authority {
    var ausername               : String    = ""
    var apassword               : String    = ""
    var ahost                   : String    = ""
    var aport                   : String    = ""
    
    //***************************************************************
    //***************        init( u: String, h: String, p: String )
    //***************************************************************
    init( user: String, pw: String, h: String, p: String ) {
        ausername        = user
        apassword        = pw
        ahost            = h
        aport            = p
    } //init( s: String, r: String, p: path )
    
    //***************************************************************
    //***************        func render () -> String
    //***************************************************************
    func render () -> String {
        
        if ausername != "" && apassword != "" {
            return "//" + ausername + ":" + apassword + "@" + ahost + ":" + aport
        } else if ausername != "" {
            return "//" + ausername + "@" + ahost + ":" + aport
        } else if aport != "" {
            return "//" + ahost + ":" + aport
        } else {
            return "//" + ahost
        }  // if auserinfo != ""
        
    }  //func render ()
    
}  //class authority

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class endpoint
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
class endpoint {
    // Components
    private var epScheme                  : String      = ""                                // "https:", "http:" etc.
    private var epAuthority               : authority   = authority( user: "", pw: "", h: "", p: "" )  //
    private var epRootEndpoint            : String      = ""                                // "/users/:username/repos"
    private var epPath                    : path        = path( v: [:], q : [:] )           // "/users/:username/repos"
    
    //***************************************************************
    //***************        init( v: [String:Any], q: [String:Any] )
    //***************************************************************
    init( s: String, a: authority, r: String, p: path ) {
        epScheme        = s
        epAuthority     = a
        epRootEndpoint  = r
        epPath          = p
    } //init( s: String, r: String, p: path )
    
    //***************************************************************
    //***************        func render () -> String
    //***************************************************************
    func renderURI () -> String {
        
        // Step 1: render epPath to substitute values for variables e.g. "/users/:username/repos" -> /users/zellwk/repos
        // "https:" + "/users/:username/repos" <-rendering epPath will substitute values for variables
        
        return epScheme + epAuthority.render() + epPath.render( rootendpoint : epRootEndpoint )
    }  //func render ()
    
}  //class endpoint

//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//***************        class request
//*******************************************************************************************
//*******************************************************************************************
//*******************************************************************************************
//  http://username:password@api.github.com/users/:variablename/?query1=value1&query2=value2
class CallRequest {
    // Rendered for use
    var rendered_URL     : String = ""
    
    // Components
    var rEndPoint        : endpoint          = endpoint( s : "", a: authority( user: "", pw: "", h: "", p: "" ),  r: "",  p : path( v: [:], q : [:] ) )
    var rMethod          : methodtype        = methodtype.NONESPECIFIED
    var rHeaders         : headers           = headers( pairs: [:] )
    var rDataBody        : databody          = databody( items: [] )
    
    //***************************************************************
    //***************        init( e: endpoint, m: methodtypes, h: headers, d: databody )
    //***************************************************************
    init( e: endpoint, m: methodtype, h: headers, d: databody ) {
        rEndPoint   = e
        rMethod     = m
        rHeaders    = h
        rDataBody   = d
    }  //init( e: endpoint, m: methodtypes, h: headers, d: databody )
    
    //***************************************************************
    //***************        func renderHTTPRequest () -> String
    //***************************************************************
    func renderURI () -> String {
        return rEndPoint.renderURI() +  rHeaders.render() + rDataBody.render()
    }  //func renderHTTPRequest () -> String
    
    //***************************************************************
    //***************        func renderHTTPRequest () -> String
    //***************************************************************
    func renderHTTPRequest () -> String {
        return rMethod.rawValue + " " + rEndPoint.renderURI() +  rHeaders.render() + rDataBody.render()
    }  //func renderHTTPRequest () -> String
    
}  //class request

//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//******************************************  END CallURIAnatomy.swift
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
//*************************************************************************************************************************
