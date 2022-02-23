//
//  ViewController.swift
//  ContactBook
//
//  Created by Tamta Topuria on 1/6/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    var dbContext = DBManager.shared.persistentContainer.viewContext
    
    var frc: NSFetchedResultsController<Contact>!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(
            UINib(nibName: "contactCell", bundle: nil),
            forCellWithReuseIdentifier: "contactCell"
        )
        fetchContacts()
        collectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPressGesture(gesture:))
            )
        )
    }
    
    func deleteAlert(contact: Contact){
        var surname = ""
        if let sur = contact.surname, !surname.isEmpty {
            surname = " " + sur
        }
        let alert = UIAlertController(
            title: "Delete Contact",
            message: "Contact " + String(contact.name!) + surname + " will be deleted",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: {[unowned self] _ in
                    dbContext.delete(contact)
                    do {
                        try dbContext.save()
                    } catch {}
                }
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func handleLongPressGesture(gesture: UILongPressGestureRecognizer){
        if gesture.state != .began {return}
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            if let contact = frc.fetchedObjects?[indexPath.row] {
                deleteAlert(contact: contact)
            }
        }
    }
    
    func fetchContacts() {
        let request = Contact.fetchRequest() as NSFetchRequest
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dbContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            collectionView.reloadData()
        } catch {}
    }

    @IBAction func add(){
        let alert = UIAlertController(title: "Add Contact", message: nil, preferredStyle: .alert)
        
        var fullnameField: UITextField!
        var phoneNumberField: UITextField!
        alert.addTextField { fullnameTextfield in
            fullnameTextfield.placeholder = "Contact Name"
            fullnameField = fullnameTextfield
        }
        
        alert.addTextField {numberTextfield in
            numberTextfield.placeholder = "Contact Number"
            phoneNumberField = numberTextfield
        }
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Save",
                style: .default,
                handler: {[unowned self] _ in
                    guard let fullname = fullnameField.text, let phoneNumber = phoneNumberField.text, Int(phoneNumber) != nil, !fullname.isEmpty, !phoneNumber.isEmpty
                    else { return }
                    
                    let fullnameArr = fullname.components(separatedBy: [" "])
                    
                    
                    let contact = Contact(context: dbContext)
                    contact.name = fullnameArr[0]
                    if fullnameArr.count > 1 {
                        contact.surname = fullnameArr[1]
                    }
                    contact.phoneNumber = phoneNumber
                    
                    do {
                        try dbContext.save()
                    } catch {}
                }
            )
        )
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: 0, right: Constants.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frc.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as! contactCell
        let contact = frc.fetchedObjects?[indexPath.row]
        cell.name.text = contact?.name
        cell.phoneNumber.text = contact?.phoneNumber
        cell.initials.text = String((contact?.name?[0])!)
        if let surname = contact?.surname, !surname.isEmpty {
            cell.initials.text! += String(surname[0])
        }
        return cell
    }
    
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spareWidth = collectionView.frame.width - 2*Constants.spacing - (Constants.itemCountInLine - 1)*Constants.spacing
        return CGSize(
            width: spareWidth/Constants.itemCountInLine,
            height: spareWidth/Constants.itemCountInLine*1.5
        )
    }
}

extension ViewController {
    
    struct Constants {
        static let spacing: CGFloat = 20
        static let itemCountInLine: CGFloat = 3
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                collectionView.insertItems(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
        default:
            break
        }
    }
}
