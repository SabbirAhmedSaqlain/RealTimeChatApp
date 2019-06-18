//
//  LoginControllerHandler.swift
//  GameOfChat
//
//  Created by Sabbir on 16/6/19.
//  Copyright © 2019 Sabbir. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import Foundation

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @objc func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!)
              //  print("not ok\n\n\n\n\n\n")
                return
                
            }
          //  print("User Auth Done\n\n\n\n\n\n")
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png")
            
           
           // let uploadData = UIImage.pngData(self.profileImage.image!)
            
            
            if let uploadData = self.profileImage.image?.jpegData(compressionQuality: 0.1) as NSData? {
                storageRef.putData(uploadData as Data, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                    //   print("not ok\n\n\n\n\n\n")
                        print(error!)
                        return
                        
                    }else {
                       // print("Image Uploaded Done\n\n\n\n\n\n")
                        //print(metadata!)
                    }

                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil {
                          //  print("URL not ok\n\n\n\n\n\n")
                          //  print(error!)
                            return
                            
                        }
                        
                        
                        if let downloadURL = url {
                           // print("URL taken Done1\n\n\n\n\n\n")
                            //print(downloadURL)
                            
                            let imgURL = "\(downloadURL)"
                            
                            
                            let values = ["name" : name, "email": email, "profileImageUrl": imgURL ]
                            self.registerUserIntoDatabase(values: values as [String : Any])
                          //  print("URL taken Done2\n\n\n\n\n\n")
                        }else {
                          //  print("URL Errrrrrrrooooo\n\n\n\n\n\n")
                        }
                    }

                })
            }
 
        }
        
    }
    
    
    
    
    private func registerUserIntoDatabase(values: [String: Any]){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userReferance = ref.child("users").child(Auth.auth().currentUser!.uid)
       //
        userReferance.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
               // print("not ok\n\n\n\n\n\n")
                
                return
                
            }else {
                
                //self.messagesController.fetchUserAndSetUpNavbarTitle()
                self.navigationController?.navigationItem.title = values["name"] as? String
                print("Fire saving done\n")
                self.dismiss(animated: true, completion: nil)
                
            }
            
        })
    }
    
 
    @objc func handleSelectProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true , completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       // print(info)
        var selectedIamgeFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedIamgeFromPicker = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage {
            selectedIamgeFromPicker = originalImage
        }
        
        
        if let selectedImage = selectedIamgeFromPicker {
            profileImage.image = selectedImage
        }
        
        /*guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          //  print(selectedImage.size)
        }*/
        dismiss(animated: true, completion: nil)
 
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//print("cancel Picker")
        
        dismiss(animated: true, completion: nil)
    }
 
}







