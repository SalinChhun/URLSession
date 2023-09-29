//
//  ViewController.swift
//  URLSession
//
//  Created by PVH_002 on 18/9/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var profile: UITextField!
    
    @IBOutlet weak var imageShow: UIImageView!
    
    let url = URL(string: "http://8.219.139.67:6654/api/v1/users")!
    var params: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPost()
        postData()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        params = [
            "username": username.text,
            "email": email.text,
            "profile": profile.text,
            "telephone": telephone.text,
                "roles": [
                role.text
            ]
        ]
        postData()
    }
    
    @IBAction func chooseImg(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageShow.image = image
            print("--------\(image)")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func getPost() {
        guard let url = URL(string: "http://8.219.139.67:6654/api/v1/users?page=1&size=5") else {
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let jsonRes = try? JSONSerialization.jsonObject(with: data!, options: [])
                print("The response: \(jsonRes)")
            }
        }.resume()
    }

    
    func postData() {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            } else {
                let jsonRes = try? JSONSerialization.jsonObject(with: data!, options: [])
                print("It worked: \(jsonRes)")
            }
        }
        session.resume()
    }
}

