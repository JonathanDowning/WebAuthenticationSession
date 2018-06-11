//
//  WebAuthenticationSession.swift
//
//  Created by Jonathan Downing on 11/06/2018.
//

import AuthenticationServices
import SafariServices

/**
 A WebAuthenticationSession object can be used to authenticate a user with a web service, even if the web service is run by a third party. WebAuthenticationSession puts the user in control of whether they want to use their existing logged-in session from Safari. The app provides a URL that points to the authentication webpage. The page will be loaded in a secure view controller. From the webpage, the user can authenticate herself and grant access to the app.
 
 On completion, the service will send a callback URL with an authentication token, and this URL will be passed to the app by completion handler.
 
 The callback URL usually has a custom URL scheme. For the app to receive the callback URL, it needs to either register the custom URL scheme in its Info.plist, or set the scheme to `callbackURLScheme` argument in the initializer.
 
 If the user has already logged into the web service in Safari or other apps via WebAuthenticationSession, it is possible to share the existing login information. An alert will be presented to get the user's consent for sharing their existing login information. If the user cancels the alert, the session will be canceled, and the completion handler will be called with the error `WebAuthenticationSession.Error.canceledLogin`.
 
 If the user taps Cancel when showing the login webpage for the web service, the session will be canceled, and the completion handler will be called with the error `WebAuthenticationSession.Error.canceledLogin`.
 
 The app can cancel the session by calling `cancel`. This will also dismiss the view controller that is showing the web service's login page.
 */
public final class WebAuthenticationSession {
    
    public enum Error: Swift.Error {
        case canceledLogin
    }
    
    private enum Session {
        @available(iOS 12.0, *)
        case asWebAuthenticationSession(ASWebAuthenticationSession)
        case sfAuthenticationSession(SFAuthenticationSession)
    }
    
    private let session: Session
    
    /**
     Returns a WebAuthenticationSession object.
     
     - Parameter url: The initial URL pointing to the authentication webpage. Only supports URLs with http:// or https:// schemes.
     - Parameter callbackURLScheme: The custom URL scheme that the app expects in the callback URL.
     - Parameter completionHandler: The completion handler which is called when the session is completed successfully or canceled by user.
     - Parameter responseURL: The URL returned once authentication has succeeded or failed.
     - Parameter error: The error if WebAuthenticationSession was unable to authenticate.
     */
    public init(url: URL, callbackURLScheme: String?, completionHandler handler: @escaping (_ responseURL: URL?, _ error: Swift.Error?) -> ()) {
        let completionHandler = { (url: URL?, error: Swift.Error?) in
            if #available(iOS 12.0, *), case ASWebAuthenticationSessionError.canceledLogin? = error {
                handler(url, Error.canceledLogin)
            } else if case SFAuthenticationError.canceledLogin? = error {
                handler(url, Error.canceledLogin)
            } else {
                handler(url, error)
            }
        }
        
        if #available(iOS 12.0, *) {
            self.session = .asWebAuthenticationSession(ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler))
        } else {
            self.session = .sfAuthenticationSession(SFAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler))
        }
    }
    
    /**
     Starts the WebAuthenticationSession instance after it is instantiated.
     
     Start can only be called once for an WebAuthenticationSession instance. This also means calling start on a canceled session will fail.
     
     - Returns: Returns `true` if the session starts successfully.
     */
    @discardableResult public func start() -> Bool {
        switch session {
        case let .asWebAuthenticationSession(session):
            return session.start()
        case let .sfAuthenticationSession(session):
            return session.start()
        }
    }
    
    /**
     Cancel a WebAuthenticationSession. If the view controller is already presented to load the webpage for authentication, it will be dismissed. Calling cancel on an already canceled session will have no effect.
     */
    public func cancel() {
        switch session {
        case let .asWebAuthenticationSession(session):
            session.cancel()
        case let .sfAuthenticationSession(session):
            session.cancel()
        }
    }
    
}
