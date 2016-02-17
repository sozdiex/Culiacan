//
//  DetalleViewController.swift
//  Culiacan
//
//  Created by Armando Trujillo on 09/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var id_problematica : Int!
    var urlArchivo : String!
    @IBOutlet weak var tableView: UITableView!
    
    private var array : NSMutableArray = []
    private var arrayTitulos : NSMutableArray = []
    private var urlArchivoAux : NSString!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hardCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushDescarga" {
            var SolicitudVC: SolicitudViewController = segue.destinationViewController as! SolicitudViewController
            SolicitudVC.urlArchivo = urlArchivo;
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
            self.callServices()
            dispatch_async(dispatch_get_main_queue(), {
               self.tableView.dataSource = self
               self.tableView.delegate = self
               self.tableView.reloadData()
               spinner.stopAnimating()
            })
        })
        
    }
    
    func callServices(){
        var arrayDepartamentos : NSMutableArray = []
        var arrayComisiones : NSMutableArray = []
        
        var dic : NSDictionary = Fetcher.callListDepartamentos()
        var arrayDep : NSMutableArray = dic.objectForKey("objects") as! NSMutableArray
        
        dic = Fetcher.callListComisiones()
        var arrayCom : NSMutableArray = dic.objectForKey("objects") as! NSMutableArray
        
        dic = Fetcher.callListAsignacionBy(id_problematica)
        
        for dicFor in dic.objectForKey("objects") as! NSMutableArray {
            var MutDic : NSMutableDictionary = NSMutableDictionary()
            if dicFor.objectForKey("tipo") as! String == "DEPARTAMENTO"{
                for dicDep in arrayDep {
                    if dicFor.objectForKey("asignada") as! Int == dicDep.objectForKey("id_departamento")  as! Int{
                        MutDic.setObject(dicDep.objectForKey("departamento")!, forKey: "titulo")
                        MutDic.setObject("departamento", forKey: "tipo")
                        MutDic.setObject(dicFor.objectForKey("peticion")!, forKey: "descripcion")
                        arrayDepartamentos.addObject(MutDic)
                        break;
                    }
                }
            }else if dicFor.objectForKey("tipo") as! String == "COMISION"{
                for dicCom in arrayCom {
                    if dicFor.objectForKey("asignada") as! Int == dicCom.objectForKey("id_comision")  as! Int{
                        MutDic.setObject(dicCom.objectForKey("comision")!, forKey: "titulo")
                        MutDic.setObject("comision", forKey: "tipo")
                        MutDic.setObject(dicFor.objectForKey("peticion")!, forKey: "descripcion")
                        arrayComisiones.addObject(MutDic)
                        break;
                    }
                }
            }
        }
        arrayTitulos = []
        if arrayDepartamentos.count > 0 {
            array.addObject(arrayDepartamentos)
            arrayTitulos.addObject("DEPARTAMENTOS")
        }
        
        if arrayComisiones.count > 0 {
            array.addObject(arrayComisiones)
            arrayTitulos.addObject("COMISIONES")
        }
        
        var dicDescarga : NSDictionary = ["tipo": "descarga", "titulo": "Solicitud"]
        var arrayDescarga : NSMutableArray = NSMutableArray()
        arrayDescarga.addObject(dicDescarga)
        array.addObject(arrayDescarga)
        arrayTitulos.addObject("ACCIONES")
        
        println(array)
        
    }
    
    // MARK: - TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (array.objectAtIndex(section) as! NSArray).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrayTitulos.objectAtIndex(section) as? String
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var dic : NSDictionary = (array.objectAtIndex(indexPath.section) as! NSMutableArray).objectAtIndex(indexPath.row) as! NSDictionary
        
        if dic.objectForKey("tipo") as! String == "descarga"{
            var cellDescarga : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            return cellDescarga;
        }
        
        var cell : dosLabelsCell = tableView.dequeueReusableCellWithIdentifier("dosLabelsCell") as! dosLabelsCell
        cell.lblTitulo.text = dic.objectForKey("titulo") as? String
        cell.lblTitulo.textAlignment = NSTextAlignment.Center
        cell.lblDescripcion.text = dic.objectForKey("descripcion") as? String
        return cell;
    }
    
    // MARK: - TableView Delegate 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == array.count-1  {
            self.performSegueWithIdentifier("pushDescarga", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var dic : NSDictionary = (array.objectAtIndex(indexPath.section) as! NSMutableArray).objectAtIndex(indexPath.row) as! NSDictionary
        
        if dic.objectForKey("tipo") as! String != "descarga"{
            var height: CGFloat = 0
            height += Fetcher.getHeightFrom(dic.objectForKey("descripcion") as! String, font: UIFont.systemFontOfSize(17), width: 270.0)
            height += Fetcher.getHeightFrom(dic.objectForKey("titulo") as! String, font: UIFont.boldSystemFontOfSize(17), width: 270.0)
            
           /* if Fetcher.getHeightFrom(dic.objectForKey("titulo") as String, font: UIFont(name: "Arial", size: 19.0)!, width: 270.0) > 25{
                height -= 10
            }*/
            
            return height
        }
        return 50
    }
    
    //MARK: - IBActions Buttons
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
}
