//
//  ViewController.swift
//  InstaGive
//
//  Created by ben on 12/12/2014.
//  Copyright (c) 2014 Ben Chamla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate,  UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    var photoSelected = false
    var profilePicture = UIImage(named: "Profil.png")
    
    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
  
    @IBOutlet weak var pickedImage: UIImageView!

    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var addProfilePicture: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var alreadyRegistered: UILabel!
    
    @IBOutlet weak var toggleSignUp: UIButton!

    @IBOutlet weak var passwordYconstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameYconstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpYconstraint: NSLayoutConstraint!
    @IBOutlet weak var emailYconstraint: NSLayoutConstraint!
    @IBOutlet weak var addPictureYConstraint: NSLayoutConstraint!
    @IBOutlet weak var WellcomeYconstraint: NSLayoutConstraint!
    @IBOutlet weak var InstagiveYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var wayToPostImageChoiceView: UIVisualEffectView!
    var keyboardCount = 0
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpActive = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wayToPostImageChoiceView.hidden = true
        
        // in the if: how to use object in parse, how to creat alert and spinner and how to use images from cameraroll and camera.
        if true {
        // Do any additional setup after loading the view, typically from a nib.
        
   
        
        /*  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView() (this is out of the viewdidload
            var score = PFObject(className: "score")
        score.setObject("Ben", forKey: "name")
        score.setObject(95, forKey: "number")
        score.saveInBackgroundWithBlock{(success:Bool!, error:NSError!) -> Void in
            if success == true {
                
                println("Score created with ID: \(score.objectId)")
                
            }else{
            println(error)
            }
        }*/
        
        /*
        var query = PFQuery(className: "score")
        query.getObjectInBackgroundWithId("ZdzQopzTe4"){(score:PFObject!, error:NSError!) -> Void in
            if error == nil {
                
             //   println(score.objectForKey("name") as NSString)
                score["name"] = "Robert"
                score["score"] = "100"
                score.saveInBackgroundWithBlock(nil)
                
            }else{
                println(error)
            }
        } 
            // don't forget to put the UIImagePickerControllerDelegate and UINavigationControllerDelegate in the class:viewcontroller (like for the UITexfFieldViewController
            @IBAction func pickImageButtonPressed(sender: AnyObject) {
            // this allow the user to pick an image in the camera roll
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary //to use the camera roll, change "PhotoLibrary" to "Camera"
            image.allowsEditing = false
            
            self.presentViewController(image, animated: true, completion: nil)
            
            
            }
            
            // this fuction is used when the user picked an image (like the 'didreturn' for keybard
            func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
            println("Image selected")
            // This take the camerarole out, like the self.doneediting for heyboard
            self.dismissViewControllerAnimated(true, completion: nil)
            
            pickedImage.image = image
            
            }
            
            @IBAction func pauseAppButtonPressed(sender: AnyObject) {
            //this is to to a spinner
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            // this is to disable the app..
            //  UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            }
            @IBAction func restoreAppButtonPressed(sender: AnyObject) {
            
            activityIndicator.stopAnimating()
            //this take the app functionality back
            //  UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            }
            @IBAction func creatAlert(sender: AnyObject) {
            
            // this is to creat an alert
            var alert = UIAlertController(title: "Hey There", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            // this is how to ad a button to it to dismiss the alert
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
            } ))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            }
            

            */
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        println(PFUser.currentUser())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        var error = ""
        
        if (userNameTextField.text == "" || passwordTextField.text == "" || profilePicture == UIImage(named: "Profil.png") ) {
            error = "Please enter a profile picture, valid email address, a username and a password"
        }
        if error != "" {
            displayAlert("Error", error: error)
        }else{
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            if signUpActive == true {
                var user = PFUser()
                user.username = userNameTextField.text
                user.password = passwordTextField.text
                user.email = emailTextField.text
                
                let imageData = UIImagePNGRepresentation(self.profilePicture)
                let imageFile = PFFile(name: "profilePicture.png", data: imageData)
                
                user["profilePicture"] = imageFile
                
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signUpError: NSError!) -> Void in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                
                    if signUpError == nil {
                        println("signed up")
                        self.performSegueWithIdentifier("JumpToNewsFeed", sender: self)
                    } else {
                        if let errorString = signUpError.userInfo?["error"] as? NSString{
                            // Show the errorString somewhere and let the user try again.
                            error = errorString
                        }else {
                            error = "Please try later"
                        }
                        self.displayAlert("Could not Sign Up", error: error)
                        }
                    }
            }else{
                
                PFUser.logInWithUsernameInBackground(userNameTextField.text, password:passwordTextField.text) {
                    (user: PFUser!, logInError: NSError!) -> Void in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if logInError == nil {
                       println("logged in")
                       self.performSegueWithIdentifier("JumpToNewsFeed", sender: self)
                    } else {
                        if let errorString = logInError.userInfo?["error"] as? NSString{
                            // Show the errorString somewhere and let the user try again.
                            error = errorString
                        }else {
                            error = "Please try later"
                        }
                        self.displayAlert("Could not Log In ", error: error)
                    }
                }
            }
        }
        
    }
    
    @IBAction func toggleSighUpButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        if signUpActive == false {
            
            signUpActive = true
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Not an Instagiver already?"
            toggleSignUp.setTitle("Log In", forState: UIControlState.Normal)
            emailTextField.hidden = false
            
            
        }else{
            signUpActive = false
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already an Instagiver?"
            toggleSignUp.setTitle("Sign Up", forState: UIControlState.Normal)
            emailTextField.hidden = true
        }
        
    }
    
 
    
    @IBAction func AddProfilePicButtonPressed(sender: AnyObject) {
        wayToPostImageChoiceView.hidden = false
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if self.keyboardCount == 0{ self.passwordYconstraint.constant = keyboardFrame.size.height + self.passwordYconstraint.constant
            self.signUpYconstraint.constant = keyboardFrame.size.height + self.signUpYconstraint.constant
            self.usernameYconstraint.constant = keyboardFrame.size.height + self.usernameYconstraint.constant
            self.emailYconstraint.constant = keyboardFrame.size.height + self.emailYconstraint.constant
            self.addPictureYConstraint.constant = keyboardFrame.size.height + self.addPictureYConstraint.constant
            self.WellcomeYconstraint.constant = keyboardFrame.size.height + self.WellcomeYconstraint.constant
            self.InstagiveYConstraint.constant = keyboardFrame.size.height + self.InstagiveYConstraint.constant
                
                self.keyboardCount++}
            
            
            
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if self.keyboardCount != 0{
            self.passwordYconstraint.constant = -keyboardFrame.size.height + self.passwordYconstraint.constant
            self.signUpYconstraint.constant = -keyboardFrame.size.height + self.signUpYconstraint.constant
            self.usernameYconstraint.constant = -keyboardFrame.size.height + self.usernameYconstraint.constant
            self.emailYconstraint.constant = -keyboardFrame.size.height + self.emailYconstraint.constant
            self.addPictureYConstraint.constant = -keyboardFrame.size.height + self.addPictureYConstraint.constant
            self.WellcomeYconstraint.constant = -keyboardFrame.size.height + self.WellcomeYconstraint.constant
            self.InstagiveYConstraint.constant = -keyboardFrame.size.height + self.InstagiveYConstraint.constant
            self.keyboardCount = 0
            }
        })
    }
    
    func displayAlert(title:String, error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()  != nil {
            self.performSegueWithIdentifier("JumpToNewsFeed", sender: self)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func cameraRollAccessButtonPressed(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary //to use the camera roll, change "PhotoLibrary" to "Camera"
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBAction func cameraAccessButtonPressed(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera //to use the camera roll, change "PhotoLibrary" to "Camera"
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBAction func closeImageOptionButtonPressed(sender: AnyObject) {
        wayToPostImageChoiceView.hidden = true
       
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        // This take the camerarole out, like the self.doneediting for heyboard
        self.dismissViewControllerAnimated(true, completion: nil)
        
        profilePicture = image
        addProfilePicture.setImage(profilePicture, forState: .Normal)
        wayToPostImageChoiceView.hidden = true
        photoSelected = true
        
    }

    
}

