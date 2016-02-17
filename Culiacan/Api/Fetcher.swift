//
//  Fetcher.swift
//  Culiacan
//
//  Created by Armando Trujillo on 09/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

let kAppUrl:String = "http://api.culiacan.gob.mx/cabildoabierto/v1"
let kAppUrlPredial = "http://pagos.culiacan.gob.mx"
//let kAppUrlOnly:String = "http://api.culiacan.gob.mx"

class Fetcher: NSObject {
    
    //MARK: - Cabildo Abierto
    class func callListSesiones() -> NSDictionary {
        let action = "/sesiones?limit=1000"
        let appUrlPath = kAppUrl+action
        println(appUrlPath)//Imprimir Url en Consola
        
        var url : NSURL = NSURL(string: appUrlPath)!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        
        request.HTTPMethod = "GET"
        
        let authStr : NSString = "zamarripa:s64QesxF6p"
        let authData : NSData = authStr.dataUsingEncoding(NSASCIIStringEncoding)!
        let base64String = "Basic " + authData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))

        request.setValue(base64String, forHTTPHeaderField: "Authorization")
        request.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSError?
        
        
        var returnData : NSData!
        returnData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)
        var err : NSError
        
        let str = NSString(data: returnData, encoding: NSUTF8StringEncoding)
        println(error?.description)
        
        if returnData != nil && returnData.length > 0 {
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            println(jsonResult)
            return jsonResult
        }
        
        return NSDictionary()
    }
    
    class func callListProblematicasBy(action: String) -> NSDictionary{
        let appUrlPath = kAppUrl + action
        println("url lista problematicas : \(appUrlPath)")
        
        var url : NSURL = NSURL(string: appUrlPath)!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSErrorPointer = nil
        
        var returnData : NSData!
        returnData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
        var err : NSError
        
        if returnData != nil {
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            println(jsonResult)
            return jsonResult
        }
        
        return NSDictionary()
        
    }
    
    class func callListAsignacionBy(id_problematicas: Int) -> NSDictionary {
        let action = "/asignaciones?id_problematica="
        let appUrlPath = kAppUrl + action + String(id_problematicas)
        println(appUrlPath)
        
        var url : NSURL = NSURL(string: appUrlPath)!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSErrorPointer = nil
        
        var returnData : NSData!
        returnData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
        var err : NSError
        
        if returnData != nil {
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            println(jsonResult)
            return jsonResult
        }
        
        return NSDictionary()
    }

    
    class func callListDepartamentos() -> NSDictionary {
        let action = "/departamentos?limit=1000"
        let appUrlPath = kAppUrl+action
        println(appUrlPath)//Imprimir Url en Consola
        
        var url : NSURL = NSURL(string: appUrlPath)!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSErrorPointer = nil
        
        var returnData : NSData!
        returnData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
        var err : NSError
        
        if returnData != nil {
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            println(jsonResult)
            return jsonResult
        }
        
        return NSDictionary()
    }
    
    class func callListComisiones() -> NSDictionary {
        let action = "/comisiones?limit=1000"
        let appUrlPath = kAppUrl+action
        println(appUrlPath)//Imprimir Url en Consola
        
        var url : NSURL = NSURL(string: appUrlPath)!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSErrorPointer = nil
        
        var returnData : NSData!
        returnData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
        var err : NSError
        
        if returnData != nil {
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            println(jsonResult)
            return jsonResult
        }
        
        return NSDictionary()
    }
    
    class func getHeightFrom(texto : String, font: UIFont, width: CGFloat) -> CGFloat{
        var labelTexto : UILabel = UILabel(frame: CGRectMake(0, 0, width, 9999))
        //var labelTexto : UILabel = UILabel(frame: CGRectMake(0, 0, 270.0, 9999))
        labelTexto.text = texto
        labelTexto.font = font
        //labelTexto.font = UIFont(name: "Arial", size: 19.0)
        labelTexto.numberOfLines = 0
        labelTexto.sizeToFit()
        return labelTexto.bounds.size.height;
    }
    
    class func alertMensajeNoInternet() -> UIAlertView{
        return UIAlertView(title: "Advertencia", message: "No cuenta con acceso a internet", delegate: nil, cancelButtonTitle: "Aceptar")
    }
    
    //MARK: - Prediale
    class func callPredialBy(num_predial : String) -> NSDictionary {
        let action = "/mipredio/"
        let appUrlPath = kAppUrlPredial + action + num_predial
        println(appUrlPath)
        
        var url : NSURL = NSURL(string: appUrlPath)!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSErrorPointer = nil
        
        var returnData : NSData!
        returnData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
        var err : NSError
        
        if returnData != nil {
            if var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                println(jsonResult)
                return jsonResult
            }
        }
        
        return NSDictionary()
    }
    
    class func funcEjemplo(Num: Int){
        println(Num)
    }
}
