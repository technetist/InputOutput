//
//  InterfaceController.swift
//  InputOutput WatchKit Extension
//
//  Created by Adrien Maranville on 8/28/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var imgBottom: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func btnDictatePressed() {
        presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { result in
            guard let result = result?.first as? String else { return }

            print(result)
        }
    }
    @IBAction func btnMultiPressed() {
        presentTextInputController(withSuggestions: ["Adrien is cool!", "What's up homie?", "nom", "Roxy!"], allowedInputMode: .allowAnimatedEmoji) { result in
            if let result = result?.first as? String {
                print(result)
            } else if let result = result?.first as? Data {
                guard let imageData = UIImage(data: result) else { return }
                self.imgBottom.setImage(imageData)
            }
        }
    }
    @IBAction func btnRecordPressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        let name = myStringafd
        print(name + ".wav")
        let saveURL = getDocumentsDirectory().appendingPathComponent(name + ".wav")
        if FileManager.default.fileExists(atPath: saveURL.path){
            let options = [WKMediaPlayerControllerOptionsAutoplayKey: "true"]
            
            presentMediaPlayerController(with: saveURL, options: options) { didPlayToEnd, endTime, error in
                
            }
            
        } else {
                let options: [String: Any] = [WKAudioRecorderControllerOptionsMaximumDurationKey : 60, WKAudioRecorderControllerOptionsActionTitleKey: "Done"]
                presentAudioRecorderController(withOutputURL: saveURL, preset: .narrowBandSpeech, options: options) { success, error in
                    if success {
                        print("Save Success! ", saveURL)
                    } else {
                        print(error?.localizedDescription ?? "Unknown Error")
                    }
                }
            }
        }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
