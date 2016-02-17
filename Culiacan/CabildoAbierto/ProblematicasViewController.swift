//
//  ProblematicasViewController.swift
//  Culiacan
//
//  Created by Armando Trujillo on 09/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class ProblematicasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   /* NSMutableDictionary *dicMeta;
    NSMutableArray *arrayProblematicas;
    int id_problematica;
    NSString *nombreArchivo;
    UIActivityIndicatorView *spinnerFooter;*/
    
    @IBOutlet weak var tableView : UITableView!
    var id_sesion : Int!
    private var dicMeta : NSMutableDictionary!
    private var arrayProblematicas: NSMutableArray!
    private var nombreArchivo : String!
    private var id_problematica : Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hardCode()
        println("id sesion:\(id_sesion)")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushDetalles"{
            var DetalleVC : DetalleViewController = segue.destinationViewController as! DetalleViewController
            DetalleVC.id_problematica = id_problematica
            DetalleVC.urlArchivo = "http://apps.culiacan.gob.mx/cabildo-abierto/adjuntos/" + String(nombreArchivo)
        }
    }
    
    @IBAction func unWind(segue : UIStoryboardSegue){
        hideSideMenuView()
    }

    
    // MARK: - hard code
    
    func hardCode(){
        var downloadListProblematicas : dispatch_queue_t = dispatch_queue_create("callListProblematicas", nil)
        
        var spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinner.center = CGPointMake(UIScreen.mainScreen().applicationFrame.size.width/2, UIScreen.mainScreen().applicationFrame.size.height/2)
        spinner.color = UIColor.blackColor()
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        dispatch_async(downloadListProblematicas, {
            self.arrayProblematicas = []
            var dic : NSDictionary = Fetcher.callListProblematicasBy("/cabildoabierto/problematicas?id_sesion=\(self.id_sesion)")
            
            if dic.objectForKey("objects") != nil {
                self.arrayProblematicas = dic.objectForKey("objects") as! NSMutableArray
            }
            
            if dic.objectForKey("meta") != nil {
                self.dicMeta = dic.objectForKey("meta") as! NSMutableDictionary
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                spinner.stopAnimating()
            })
        })
    }

    func loadNext(){
        var downloandNext : dispatch_queue_t = dispatch_queue_create("callNextList", nil)
        dispatch_async(downloandNext, {
            var dic : NSDictionary = Fetcher.callListProblematicasBy(self.dicMeta.objectForKey("next") as! String) as NSDictionary
            
            if dic.objectForKey("objects") != nil{
                for dicFor in dic.objectForKey("objects") as! NSArray {
                    self.arrayProblematicas.addObject(dicFor)
                }
            }
            
            if dic.objectForKey("meta") != nil {
                self.dicMeta = dic.objectForKey("meta") as! NSMutableDictionary
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.tableFooterView = nil;
                self.tableView.reloadData()
            })
        })
    }
    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProblematicas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ProblematicaCell = tableView.dequeueReusableCellWithIdentifier("ProblematicaCell") as! ProblematicaCell
        var dic : NSDictionary = arrayProblematicas.objectAtIndex(indexPath.row) as! NSDictionary
        cell.lblFolio.text = String(dic.objectForKey("id_problematica") as! Int)
        cell.lblResponsable.text = dic.objectForKey("ponente_designado") as? String
        cell.lblProblema.text = dic.objectForKey("titulo") as? String
        
        if indexPath.row == arrayProblematicas.count - 1 {
            if (dicMeta.objectForKey("next") as? String != nil) {
                var spinnerFooter : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                spinnerFooter.frame = CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.size.width , 44)
                spinnerFooter.color = UIColor.blackColor()
                spinnerFooter.startAnimating()
                tableView.tableFooterView = spinnerFooter
                loadNext()
            }else{
                tableView.tableFooterView = nil
            }
            
        }
        
        return cell;
    }
    
    // MARK: - TableView Delegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var dic : NSDictionary = arrayProblematicas.objectAtIndex(indexPath.row) as! NSDictionary
        var height : CGFloat = 40
        height += Fetcher.getHeightFrom(dic.objectForKey("titulo") as! String, font: UIFont(name: "Arial", size: 19.0)!, width: 270.0)
        return height;
        //return 100;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var dic : NSDictionary = arrayProblematicas.objectAtIndex(indexPath.row) as! NSDictionary
        id_problematica = dic.objectForKey("id_problematica") as! Int
        nombreArchivo = dic.objectForKey("archivo") as! String
        
        self.performSegueWithIdentifier("pushDetalles", sender: self)
    }
    
    // MARK: - IBActions Buttons
    @IBAction func actionShowMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
}
