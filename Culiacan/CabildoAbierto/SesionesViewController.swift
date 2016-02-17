
//
//  SesionesViewController.swift
//  Culiacan
//
//  Created by Armando Trujillo on 09/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class SesionesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var arraySesiones : NSMutableArray!
    var arrayYearSesiones : NSMutableArray!
    var id_SesionSelected : Int!
    private var viewReload: UIView!
    
    
    override func viewDidLoad() {
        self.arraySesiones = NSMutableArray()
        super.viewDidLoad()
        initViewRefresh()
        loadList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushProblematicas" {
            var sesionVC : ProblematicasViewController = segue.destinationViewController as! ProblematicasViewController
            sesionVC.id_sesion = id_SesionSelected
        }
    }
    
    @IBAction func unWind(segue :UIStoryboardSegue){
        hideSideMenuView()
    }
    
    // MARK: - IBActions Buttons
    @IBAction func actionShowMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - hard code
    func initViewRefresh(){
        viewReload = UIView(frame: self.view.frame)
        viewReload.backgroundColor = UIColor.whiteColor()
        
        let imageViewReload: UIImageView = UIImageView(image: UIImage(named: "icoRefresh"))
        imageViewReload.center = CGPointMake(viewReload.bounds.width/2, viewReload.bounds.height/4)
        
        let label: UILabel = UILabel()
        label.text = "Toque para recargar la pantalla"
        label.sizeToFit()
        label.center = CGPointMake(viewReload.bounds.width/2,  imageViewReload.frame.size.height + imageViewReload.frame.origin.y+30)
        viewReload.addSubview(label)
        viewReload.addSubview(imageViewReload)
        
        
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapRefresh"))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewReload.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(viewReload)
    }
    
    func loadList(){
        if Reachability.isConnectedToNetwork() {
            viewReload.hidden = true
            var downloadQueue :dispatch_queue_t = dispatch_queue_create("callListSesion", nil)
            
            var spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            spinner.center = CGPointMake(UIScreen.mainScreen().applicationFrame.size.width/2.0, UIScreen.mainScreen().applicationFrame.size.height/2.0)
            spinner.color = UIColor.blackColor()
            self.view.addSubview(spinner)
            spinner.startAnimating()
            
            dispatch_async(downloadQueue, {
                self.arraySesiones = []
                var dic : NSDictionary = Fetcher.callListSesiones()
                if (dic.objectForKey("objects") != nil){
                    var arraySesionesTemp = dic.objectForKey("objects") as! NSMutableArray
                    var yearFormmater : NSDateFormatter = NSDateFormatter()
                    yearFormmater.dateFormat = "yyyy"
                    var formmater : NSDateFormatter = NSDateFormatter()
                    formmater.dateFormat = "yyyy-mm-DD"
                    
                    self.arraySesiones = NSMutableArray()
                    self.arrayYearSesiones = NSMutableArray()
                    let yearNow : Int  = yearFormmater.stringFromDate(NSDate()).toInt()!
                    for anio in 2012...yearNow {
                        var arrayTemp : NSMutableArray = NSMutableArray()
                        for dic in arraySesionesTemp {
                            var currentYear : Int = yearFormmater.stringFromDate(formmater.dateFromString(dic.objectForKey("fecha") as! String) as NSDate!).toInt()!
                            if anio == currentYear {
                                arrayTemp.addObject(dic)
                            }
                        }
                        
                        if arrayTemp.count > 0 {
                            self.arraySesiones.addObject(arrayTemp)
                            self.arrayYearSesiones.addObject(String(anio))
                        }
                    }
                }else{
                    self.viewReload.hidden = false
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    spinner.stopAnimating()
                })
            })

        }else{
            Fetcher.alertMensajeNoInternet().show()
            viewReload.hidden = false
        }
    }
    
    func tapRefresh(){
        loadList()
    }
    
    // MARK: - collectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.arraySesiones.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySesiones.objectAtIndex(section).count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionHeader {
            var reusableHeaderView : UICollectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! UICollectionHeaderView
            var title : String = self.arrayYearSesiones.objectAtIndex(indexPath.section) as! String
            reusableHeaderView.lblSesion.text =  "SESIONES " + title
            reusableView = reusableHeaderView;
        }
        
        return reusableView
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : SesionesCell = collectionView.dequeueReusableCellWithReuseIdentifier("SesionesCell", forIndexPath: indexPath) as! SesionesCell
        var dic : NSDictionary = arraySesiones.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! NSDictionary
        var formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var date : NSDate = formatter.dateFromString(dic.objectForKey("fecha") as! String)!
        formatter.dateFormat = "MMMM"
        formatter.locale = NSLocale(localeIdentifier: "es_GB")
        cell.lblMes.text = formatter.stringFromDate(date)
        cell.lblSesion.text = String(indexPath.row + 1)
        
        var viewBack : UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
        viewBack.backgroundColor = Colors.tinto()
        cell.selectedBackgroundView = viewBack
        
        if UIScreen.mainScreen().applicationFrame.size.width == 320 {
            cell.lblMes.font = UIFont(name: "System", size: 17)
        }
        
        return cell
    }
    
    // MARK: - CollecionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var dic : NSDictionary = arraySesiones.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! NSDictionary
        id_SesionSelected = dic.objectForKey("id_sesion") as! Int
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("pushProblematicas", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        var cell : SesionesCell = collectionView.dequeueReusableCellWithReuseIdentifier("SesionesCell", forIndexPath: indexPath) as! SesionesCell
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set cell width to 100%
        let collectionViewWidth = self.collectionView.bounds.size.width

        if collectionViewWidth == 414 {
            //iPhone 6 Plus
            return CGSize(width: 94, height: 94)
        }else if collectionViewWidth == 375 {
            // iPhone 6
            return CGSize(width: 84, height: 84)
        }else{
            // iPhone 5 y 4
            return CGSize(width: 90, height: 90)
        }

    }

}
