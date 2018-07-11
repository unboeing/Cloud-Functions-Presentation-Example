//
//  ViewController.swift
//  FirestorePresentationExample
//
//  Created by Bufni on 5/8/18.
//  Copyright © 2018 Bufni. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityCapitalizedLabel: UILabel!
    
    var citiesSnapshotListener: FIRListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*========================================================================*/
        
        
         // Add a new document with a generated ID
         let db = Firestore.firestore()
         var ref: DocumentReference? = nil
         ref = db.collection("users").addDocument(data: [
         "first": "Ada",
         "last": "Lovelace",
         "born": 1815,
         "dateAdded": Date()
         ]) { err in
         if let err = err {
         print("Error adding document: \(err)")
         } else {
         print("Document added with ID: \(ref!.documentID)")
         }
         }
         
        
        /*========================================================================*/
        
        
         // Add a second document with a generated ID.
         ref = db.collection("users").addDocument(data: [
         "first": "Alan",
         "middle": "Mathison",
         "last": "Turing",
         "born": 1912,
         "dateAdded": Date()
         ]) { err in
         if let err = err {
         print("Error adding document: \(err)")
         } else {
         print("Document added with ID: \(ref!.documentID)")
         }
         }
         
        
        /*========================================================================*/
        
        /*
         // Read all the documents in the "users" collection
         db.collection("users").getDocuments() { (querySnapshot, err) in
         if let err = err {
         print("Error getting documents: \(err)")
         } else {
         for document in querySnapshot!.documents {
         print("\(document.documentID) => \(document.data())")
         }
         }
         }
         */
        
        /*========================================================================*/
        /*========================================================================*/
        
        
         // Let's create another collection
         let citiesRef = db.collection("cities")
         
         citiesRef.document("SF").setData([
         "name": "San Francisco",
         "state": "CA",
         "country": "USA",
         "capital": false,
         "population": 860000
         ])
         citiesRef.document("LA").setData([
         "name": "Los Angeles",
         "state": "CA",
         "country": "USA",
         "capital": false,
         "population": 3900000
         ])
         citiesRef.document("DC").setData([
         "name": "Washington D.C.",
         "country": "USA",
         "capital": true,
         "population": 680000
         ])
         citiesRef.document("TOK").setData([
         "name": "Tokyo",
         "country": "Japan",
         "capital": true,
         "population": 9000000
         ])
         citiesRef.document("BJ").setData([
         "name": "Beijing",
         "country": "China",
         "capital": true,
         "dateAdded": Date(),
         "population": 21500000
         ])
        
        
        /*========================================================================*/
        
        
         // Get a document"
        let docRef = db.collection("cities").document("SF")
        
         docRef.getDocument { (document, error) in
         if let document = document, document.exists {
         let dataDescription = String(describing: document.data())
         print("Document data: \(dataDescription)")
         } else {
         print("Document does not exist")
         }
         }
        
        
        /*========================================================================*/
        
        
         // Get multiple documents
         db.collection("cities").whereField("capital", isEqualTo: true)
         .getDocuments() { (querySnapshot, err) in
         if let err = err {
         print("Error getting documents: \(err)")
         } else {
         for document in querySnapshot!.documents {
         print("\(document.documentID) => \(document.data())")
         }
         }
         }
        
        /*========================================================================*/
        
        
         // Add a snapshot listener
         let _ = db.collection("cities").document("SF")
         .addSnapshotListener { documentSnapshot, error in
         guard let document = documentSnapshot else {
         print("Error fetching document: \(error!)")
         return
         }
         print("Current data: \(document.data())")
         }
        
        citiesSnapshotListener = db.collection("citiesCapitalized")
            .addSnapshotListener({ (querySnapshot, error) in
                if error != nil {
                    print("Error fetching documents")
                    return
                } else if let snapshot = querySnapshot {
                    if snapshot.documentChanges.count == 1 {
                        self.cityCapitalizedLabel.text = "Capitalized: \(snapshot.documentChanges[0].document.data()["name"] as! String)"
                    }
                }
            })
        
        /*========================================================================*/
        
        /*
         // Listen to multiple documents in a collection
         let multipleDocumentsListener = db.collection("cities").whereField("state", isEqualTo: "CA")
         .addSnapshotListener { querySnapshot, error in
         guard let documents = querySnapshot?.documents else {
         print("Error fetching documents: \(error!)")
         return
         }
         let cities = documents.map { $0["name"]! }
         print("Current cities in CA: \(cities)")
         }
         */
        
        /*========================================================================*/
        
        /*
         // View changes between snapshots
         let changesListener = db.collection("cities").whereField("state", isEqualTo: "CA")
         .addSnapshotListener { querySnapshot, error in
         guard let snapshot = querySnapshot else {
         print("Error fetching snapshots: \(error!)")
         return
         }
         snapshot.documentChanges.forEach { diff in
         if (diff.type == .added) {
         print("New city: \(diff.document.data())")
         }
         if (diff.type == .modified) {
         print("Modified city: \(diff.document.data())")
         }
         if (diff.type == .removed) {
         print("Removed city: \(diff.document.data())")
         }
         }
         }
         */
        
        /*========================================================================*/
        
        /*
         // Detach a listener
         listener.remove()
         multipleDocumentsListener.remove()
         changesListener.remove()
         */
        
        /*========================================================================*/
        
        /*
         // Create a query against the collection.
         print("Cali cities")
         let query = citiesRef.whereField("state", isEqualTo: "CA")
         query.getDocuments { (citiesQuerySnapshot, error) in
         if error != nil {
         print("Error fetching cities, \(error!.localizedDescription)")
         } else if let citiesQueryDocuments = citiesQuerySnapshot?.documents {
         for cityDocument in citiesQueryDocuments {
         print(cityDocument.data())
         }
         }
         }
         print("Capital cities")
         let capitalCities = db.collection("cities").whereField("capital", isEqualTo: true)
         capitalCities.getDocuments { (citiesQuerySnapshot, error) in
         if error != nil {
         print(error!.localizedDescription)
         } else if let citiesQueryDocuments = citiesQuerySnapshot?.documents {
         for cityDocument in citiesQueryDocuments {
         print(cityDocument.data())
         }
         }
         }
         */
        
        /*========================================================================*/
        
        /*
         // Order and limit data
         citiesRef
         .order(by: "state")
         .order(by: "population", descending: true)
         .limit(to: 2)
         
         // Valid range filter
         citiesRef
         .whereField("population", isGreaterThan: 100000)
         .order(by: "population")
         
         // Invalid range filter
         citiesRef
         .whereField("population", isGreaterThan: 100000)
         .order(by: "country")
         */
        
        /*========================================================================*/
        
        /*
         // Add a simple cursor to a query
         // Get all cities with population over one million, ordered by population.
         db.collection("cities")
         .order(by: "population")
         .start(at: [1000000])
         // Get all cities with population less than one million, ordered by population.
         db.collection("cities")
         .order(by: "population")
         .end(at: [1000000])
         
         // Use a document snapshot to define the query cursor
         db.collection("cities")
         .document("SF")
         .addSnapshotListener { (document, error) in
         guard let document = document else {
         print("Error retreving cities: \(error.debugDescription)")
         return
         }
         
         // Get all cities with a population greater than or equal to San Francisco.
         let sfSizeOrBigger = db.collection("cities")
         .order(by: "population")
         .start(atDocument: document)
         }
         */
        
        /*========================================================================*/
        
        /*
         // Paginate a query
         // Construct query for first 25 cities, ordered by population
         let first = db.collection("cities")
         .order(by: "population")
         .limit(to: 25)
         
         first.addSnapshotListener { (snapshot, error) in
         guard let snapshot = snapshot else {
         print("Error retreving cities: \(error.debugDescription)")
         return
         }
         
         guard let lastSnapshot = snapshot.documents.last else {
         // The collection is empty.
         return
         }
         
         // Construct a new query starting after this document,
         // retrieving the next 25 cities.
         let next = db.collection("cities")
         .order(by: "population")
         .start(afterDocument: lastSnapshot)
         
         // Use the query for pagination.
         // ...
         }
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if citiesSnapshotListener != nil {
            citiesSnapshotListener?.remove()
        }
    }
    
    @IBAction func addCityButtonTapped(_ sender: UIButton) {
        if cityNameTextField.text != "" {            
            var ref: DocumentReference? = nil
            ref = Firestore.firestore()
                .collection("cities").addDocument(data: ["name": cityNameTextField.text!]) { error in
                    if error != nil {
                        print("Error uploading new city. \(error!.localizedDescription)")
                    } else {
                        print("City \(self.cityNameTextField.text!) added with id \(ref!.documentID)")
                    }
            }
            cityNameTextField.text = ""
            cityNameTextField.resignFirstResponder()
        }
    }   
}

