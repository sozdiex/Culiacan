//
//  DetPredialViewController.swift
//  Culiacan
//
//  Created by Armando Trujillo Zazueta  on 17/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class DetPredialViewController: UIViewController, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var arrayTitulos : NSMutableArray!
    private var arrayContenido : NSMutableArray!
    var arrayDeuda: NSMutableArray!
    private var checkPeriodo : Int!
    
    var id_predial: String!
    private var dicInfo : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayTitulos = [["Nombre","Domicilio","Cle. Catastral"],["Lugar", "Colonia", "Población", "Valor Catastral", "Sup. Terreno", "Sup. Contruída", "Tipo"],["uno","dos","tres","Cuatro","Total"]]
        
        println("numero predial: " + id_predial)
        
        callService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Hard Code
    func callService() {
        if Reachability.isConnectedToNetwork() {
            var downloadQueue :dispatch_queue_t = dispatch_queue_create("callListSesion", nil)
            
            var spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            spinner.center = CGPointMake(UIScreen.mainScreen().applicationFrame.size.width/2.0, UIScreen.mainScreen().applicationFrame.size.height/2.0)
            spinner.color = UIColor.blackColor()
            self.view.addSubview(spinner)
            spinner.startAnimating()
            
            dispatch_async(downloadQueue, {
                var dic : NSDictionary = Fetcher.callPredialBy(self.id_predial)
                
                dispatch_async(dispatch_get_main_queue(), {
                    if dic != NSDictionary() {
                        if dic.objectForKey("Id_Contribuyente") as! String == "0"{
                            UIAlertView(title: "Advertencia", message: "La clave no es válida", delegate: self, cancelButtonTitle: "Aceptar").show()
                        }else{
                            println(dic)
                            self.dicInfo = dic
                            // Reload TableView
                            self.makeRows()
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        UIAlertView(title: "Advertencia", message: "La clave no es válida", delegate: self, cancelButtonTitle: "Aceptar").show()
                    }
                    
                    spinner.stopAnimating()
                })
            })
            
        }else{
            Fetcher.alertMensajeNoInternet().show()
        }
    }
    
    func makeRows(){
        arrayContenido = []
        var arrayAux : NSMutableArray!
        
        arrayAux = []
        arrayAux[0] = dicInfo.objectForKey("Nombre_Propietario") as! String
        arrayAux[1] = dicInfo.objectForKey("Domicilio_Propiedad") as! String
        arrayAux[2] = dicInfo.objectForKey("Cve_Catastral") as! String
        arrayContenido[0] = arrayAux
        
        arrayAux = []
        arrayAux[0] = dicInfo.objectForKey("Ubicacion_Propiedad") as! String
        arrayAux[1] = dicInfo.objectForKey("Colonia_Propiedad") as! String
        arrayAux[2] = dicInfo.objectForKey("Poblacion_Propiedad") as! String
        arrayAux[3] = dicInfo.objectForKey("Valor_Catastral") as! String
        arrayAux[4] = dicInfo.objectForKey("Superficie_Terreno") as! String
        arrayAux[5] = dicInfo.objectForKey("Superficie_Construccion") as! String
        arrayAux[6] = dicInfo.objectForKey("Tipo_Subsidio") as! String
        arrayContenido[1] = arrayAux
        
        arrayDeuda = dicInfo.objectForKey("Detalle")?.objectForKey("Detalle") as! NSMutableArray
        
        checkPeriodo = arrayDeuda.count - 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrayTitulos.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return arrayDeuda.count + 2
        }
        
        return arrayTitulos[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section <= 1 {
            var cell : dosLabelsCell  = tableView.dequeueReusableCellWithIdentifier("dosLabelsCell") as! dosLabelsCell
            
            cell.lblTitulo.text = arrayTitulos[indexPath.section][indexPath.row] as? String
            cell.lblDescripcion.text = arrayContenido[indexPath.section][indexPath.row] as? String
            
            return cell
        } else if indexPath.section == 2 && indexPath.row < arrayDeuda.count  {
            var cell : PeriodoCell = tableView.dequeueReusableCellWithIdentifier("PeriodoCell") as! PeriodoCell
            cell.viewPrincipal.layer.borderWidth = 1
            cell.viewPrincipal.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.viewPrincipal.layer.shadowRadius = 3
            cell.viewPrincipal.layer.shadowColor  = UIColor.blackColor().CGColor
            cell.viewPrincipal.layer.shadowOpacity = 0.3
            
            var dic : NSDictionary = arrayDeuda.objectAtIndex(indexPath.row) as! NSDictionary
            var fecha = dic.objectForKey("anio") as! String + "-"
            fecha += dic.objectForKey("trimestre") as! String
            cell.lblPeriodo.text = "Periodo: " + fecha
            
            var Princiapl = dic.objectForKey("principal") as! NSString
            cell.lblPrincipal.text = "Principal: " + floatToMoney(Princiapl)
            
            var social = dic.objectForKey("asistencia_social") as! NSString!
            cell.lblSocial.text = "A. Social: " + floatToMoney(social)
            
            var desct = dic.objectForKey("descuento") as! NSString!
            cell.lblDesct.text = "Desct: " + floatToMoney(desct)
            
            var prontoP =  dic.objectForKey("prontopago") as! NSString!
            cell.lblProntoPago.text = "Pronto P.: " + floatToMoney(prontoP)
            
            var jubilados = dic.objectForKey("jubilados") as! NSString!
            cell.lblJubilados.text = "Jubilados: " + floatToMoney(jubilados)
            
            var recargos = dic.objectForKey("recargos") as! NSString
            cell.lblRecargos.text = "Recargos: " + floatToMoney(recargos)
            
            var multas =  dic.objectForKey("multas") as! NSString
            cell.lblMultas.text = "Multas: " + floatToMoney(multas)
            
            var total = social.doubleValue + multas.doubleValue + recargos.doubleValue + prontoP.doubleValue + desct.doubleValue + Princiapl.doubleValue
            
            cell.lblTotal.text = "Total: " + floatToMoney("\(total)")
            
            if indexPath.row <= checkPeriodo {
                cell.imageCheck.image = UIImage(named: "check")
            }else{
                cell.imageCheck.image = UIImage(named: "unCheck")
            }
            
            
            return cell
        } else if indexPath.section == 2 && indexPath.row == arrayDeuda.count  {
            var cell : unLabelCell = tableView.dequeueReusableCellWithIdentifier("TotalCell") as! unLabelCell
            var TotalPeriodos : Double = 0.00
            
            if checkPeriodo >= 0 {
                for index in 0...checkPeriodo {
                    var dic : NSDictionary = arrayDeuda.objectAtIndex(index) as! NSDictionary
                    var Princiapl = dic.objectForKey("principal") as! NSString
                    var social = dic.objectForKey("asistencia_social") as! NSString!
                    var desct = dic.objectForKey("descuento") as! NSString!
                    var prontoP =  dic.objectForKey("prontopago") as! NSString!
                    var jubilados = dic.objectForKey("jubilados") as! NSString!
                    var recargos = dic.objectForKey("recargos") as! NSString
                    var multas =  dic.objectForKey("multas") as! NSString
                    var total = social.doubleValue + multas.doubleValue + recargos.doubleValue + prontoP.doubleValue + desct.doubleValue + Princiapl.doubleValue
                    TotalPeriodos = TotalPeriodos + total
                }
            }
            
            cell.lblUno.text = "Total a pagar: " + floatToMoney("\(TotalPeriodos)")
            return cell
        }else if indexPath.section == 2 && indexPath.row == arrayDeuda.count + 1 {
            return tableView.dequeueReusableCellWithIdentifier("EnviarCell") as! UITableViewCell
        }else {
            return tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        }
        
    }
    
    func floatToMoney(stringNumber: NSString) -> String {
        var precio = stringNumber.floatValue
        var commas : NSNumberFormatter = NSNumberFormatter() as NSNumberFormatter
        commas.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        commas.maximumFractionDigits = 2
        var precioString : NSString =  commas.stringFromNumber(NSNumber(float: precio))!
        return precioString as String
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row < arrayDeuda.count {
            return 110
        }
        return 46
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var HeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        HeaderView.backgroundColor = UIColor.whiteColor()
        
        var label = UILabel(frame: CGRect(x: 10, y: 15, width: 300, height: 21))
        label.font = UIFont.boldSystemFontOfSize(18.0)
        if section == 0 {
            label.text = "Datos del contribuyente"
        } else if section == 1 {
            label.text = "Datos del predio"
        } else if section == 2 {
            label.text = "Periodos de la deuda"
        }
        
        HeaderView.addSubview(label)
        return HeaderView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row < arrayDeuda.count {
            if checkPeriodo == indexPath.row {
                checkPeriodo = indexPath.row - 1
            }else{
                if checkPeriodo < indexPath.row{
                    checkPeriodo = indexPath.row
                }else {
                    checkPeriodo = indexPath.row - 1
                }
            }
            tableView.reloadData()
        }else if indexPath.section == 2 && indexPath.row == arrayDeuda.count + 1 {
            self.performSegueWithIdentifier("pushRecibo", sender: self)
        }
    }
    
    // MARK: - UIAlertView Delegeate
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        self.performSegueWithIdentifier("unWind", sender: self)
    }
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushRecibo" {
            var viewController = segue.destinationViewController as! ReciboViewController
            
            var dic : NSDictionary = arrayDeuda.objectAtIndex(checkPeriodo) as! NSDictionary
            var fecha = dic.objectForKey("anio") as! String
            fecha += dic.objectForKey("trimestre") as! String
            viewController.urlArchivo = "https://pagos.culiacan.gob.mx/mirecibo/\(id_predial)/\(fecha)"
            
        }
     }
    
    @IBAction func unWind(Segue: UIStoryboardSegue){
        
    }
}
