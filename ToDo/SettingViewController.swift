//
//  SettingViewController.swift
//  ToDo
//
//  Created by zunda on 2021/04/11.
//

import UIKit
import Firebase
import GoogleSignIn

var isMFAEnabled = false
class SettingViewController: UIViewController {
    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SettingViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("\(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in (resolver.hints) {
                        displayNameString += tmpFactorInfo.displayName ?? ""
                        displayNameString += " "
                    }
                    self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
                        var selectedHint: PhoneMultiFactorInfo?
                        for tmpFactorInfo in resolver.hints {
                            if (displayName == tmpFactorInfo.displayName) {
                                selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                            }
                        }
                        PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
                            if error != nil {
                                print("Multi factor start sign in failed. Error: \(error.debugDescription)")
                            } else {
                                self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
                                    let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
                                    let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
                                    resolver.resolveSignIn(with: assertion!) { authResult, error in
                                        if error != nil {
                                            print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
                                        } else {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                })
                            }
                        }
                    })
                } else {
                    self.showMessagePrompt(error.localizedDescription)
                    return
                }
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
}

private class SaveAlertHandle {
  static var alertHandle: UIAlertController?

  class func set(_ handle: UIAlertController) {
    alertHandle = handle
  }

  class func clear() {
    alertHandle = nil
  }

  class func get() -> UIAlertController? {
    return alertHandle
  }
}

extension UIViewController {
  /*! @fn showMessagePrompt
   @brief Displays an alert with an 'OK' button and a message.
   @param message The message to display.
   */
  func showMessagePrompt(_ message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    present(alert, animated: false, completion: nil)
  }

  /*! @fn showTextInputPromptWithMessage
   @brief Shows a prompt with a text field and 'OK'/'Cancel' buttons.
   @param message The message to display.
   @param completion A block to call when the user taps 'OK' or 'Cancel'.
   */
  func showTextInputPrompt(withMessage message: String,
                           completionBlock: @escaping ((Bool, String?) -> Void)) {
    let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      completionBlock(false, nil)
    }
    weak var weakPrompt = prompt
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      guard let text = weakPrompt?.textFields?.first?.text else { return }
      completionBlock(true, text)
    }
    prompt.addTextField(configurationHandler: nil)
    prompt.addAction(cancelAction)
    prompt.addAction(okAction)
    present(prompt, animated: true, completion: nil)
  }

  /*! @fn showSpinner
   @brief Shows the please wait spinner.
   @param completion Called after the spinner has been hidden.
   */
  func showSpinner(_ completion: (() -> Void)?) {
    let alertController = UIAlertController(title: nil, message: "Please Wait...\n\n\n\n",
                                            preferredStyle: .alert)
    SaveAlertHandle.set(alertController)
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    spinner.color = UIColor(ciColor: .black)
    spinner.center = CGPoint(x: alertController.view.frame.midX,
                             y: alertController.view.frame.midY)
    spinner.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin,
                                .flexibleLeftMargin, .flexibleRightMargin]
    spinner.startAnimating()
    alertController.view.addSubview(spinner)
    present(alertController, animated: true, completion: completion)
  }

  /*! @fn hideSpinner
   @brief Hides the please wait spinner.
   @param completion Called after the spinner has been hidden.
   */
  func hideSpinner(_ completion: (() -> Void)?) {
    if let controller = SaveAlertHandle.get() {
      SaveAlertHandle.clear()
      controller.dismiss(animated: true, completion: completion)
    }
  }
}
