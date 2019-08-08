//
//  ViewController.swift
//  realmPractise
//
//  Created by apple on 8/2/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var secondTableView: UITableView!
    
    var dataSourse :  Results<MealRealm>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
       
        secondTableView.delegate = self
        secondTableView.dataSource = self
        secondTableView.estimatedRowHeight = 300
        secondTableView.rowHeight = UITableView.automaticDimension
        
        if isInternetAvailable() {
            
            ClearBase()
            
           // downloadJsonWithURL(GetUrl: defaultUrl)
             requestData()
            
        }
        else{
            print("NO")
        }
        reloadTable()
        
        
        
        if let fileUrl = Realm.Configuration.defaultConfiguration.fileURL{
            print("FILE URL IS",fileUrl)
        }
        
        
    }

    func ClearBase(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func reloadTable(){
        do{
            dataSourse = realm.objects(MealRealm.self)
           secondTableView.reloadData()
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCell"
        
        guard let cell = secondTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? tableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
          let meal = dataSourse[indexPath.row]
     
        cell.titleLableLBL.text = meal.title
        cell.ingredientsTextView.text = meal.ingredients
      //  cell.photoImage.image = meal.image
        
        if (meal.image != "" && isInternetAvailable()) {
            let imgURL = NSURL(string: meal.image)

            if imgURL != nil {
                let data = NSData(contentsOf: (imgURL as URL?)!)

                cell.photoImage.image = UIImage(data: data! as Data)
            }
        } else {
            cell.photoImage.image = #imageLiteral(resourceName: "GV_App_flow_3-04_Tavola disegno 1.jpg")
        }

        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.width / 2
        cell.photoImage.clipsToBounds = true

        
        
        
        
        
        return cell
        
        
    }
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //secondTableView.rowHeight = UITableView.automaticDimension
        //secondTableView.estimatedRowHeight = 300
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
    }
    
    
    
    
  
    func requestData()
    {
    // calling service by using alamofire
    let manager = Alamofire.SessionManager.default
    // manager.session.configuration.timeoutIntervalForRequest = 20
    manager.request("http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3", method:.get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
    .responseJSON { (response) in
    switch response.result {
    case .success:
    if let JSON = response.result.value as? [String: Any] {
    
   
    var results  =  (JSON as AnyObject).object(forKey:"results") as! NSArray
    print(results)
        
        for dic in results
        {
            
            var titleValue:String?
          if let  title = (dic as AnyObject).object(forKey: "title") as?  String
          {
            titleValue = title
            
            }else
          {
            titleValue = ""
            
            
            }
            var  ingredientsValue:String?
            
         if let ingredients = (dic as AnyObject).object(forKey: "ingredients") as? String
         {
            ingredientsValue = ingredients
            
            
            }
            else
         {
            ingredientsValue = ""
            }
            
            var  thumbnailBValue:String
         if let thumbnail = (dic as AnyObject).object(forKey:"thumbnail") as? String
         {
            thumbnailBValue = thumbnail
            
            
            
            }else
         {
            thumbnailBValue = ""
            }
    
            
            // storing data into realm data base
            let item = MealRealm()
            item.title = titleValue!
            print(item.title)
            item.ingredients = ingredientsValue!
            print(item.ingredients)
            item.image = thumbnailBValue
            
            do{
                let realm = try Realm()
                try realm.write({
                    realm.add(item)
                })
                
         
                
                
                
            }catch
            {
                
                
            }
            
            OperationQueue.main.addOperation({
                self.secondTableView.reloadData()
            })
            
        }
   
    
    }
    case .failure(let error): break
    // error handling
  
    }
    
    
    
    
    
    }
    
    
    
    
    
    }
    
    

}// end of the class

