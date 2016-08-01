//
//  ViewController.swift
//  NoMoreStorage
//
//  Created by Lukas Böhler on 01/08/16.
//  Copyright © 2016 Lukas Böhler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var freeStorageLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var aimedFreeStorage: UITextField!
    
    var writeBullshit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startButton.layer.cornerRadius = 3.0
        aimedFreeStorage.layer.cornerRadius = 3.0
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func update() {
        // Check diskstorage.
        let freeSpaceInMBytes = deviceRemainingFreeSpaceInMBytes()
        freeStorageLabel.text = "\(freeSpaceInMBytes!)"
        
        if let aimedFreeSpace = Int(aimedFreeStorage.text!) {
            if(freeSpaceInMBytes! < aimedFreeSpace) {
                self.writeBullshit = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deviceRemainingFreeSpaceInMBytes() -> Int? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if let systemAttributes = try? NSFileManager.defaultManager().attributesOfFileSystemForPath(documentDirectoryPath.last!) {
            if let freeSize = systemAttributes[NSFileSystemFreeSize] as? NSNumber {
                return (Int(freeSize.longLongValue) / 1000000)
            }
        }
        // something failed
        return nil
    }
    
    @IBAction func startWrittingBullshit() {
        self.writeBullshit = true
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // write file.
            let shit = "💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩"
            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let path = documents.URLByAppendingPathComponent("big.bullshit").path!
            
            if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
                outputStream.open()
                
                while self.writeBullshit {
                    outputStream.write(shit)
                }
                
                outputStream.close()
            } else {
                print("Unable to open file")
            }
        }
    }
}

extension NSOutputStream {
    /// http://stackoverflow.com/questions/26989493/how-to-open-file-and-append-a-string-in-it-swift
    /// Write String to outputStream
    ///
    /// - parameter string:                The string to write.
    /// - parameter encoding:              The NSStringEncoding to use when writing the string. This will default to UTF8.
    /// - parameter allowLossyConversion:  Whether to permit lossy conversion when writing the string.
    ///
    /// - returns:                         Return total number of bytes written upon success. Return -1 upon failure.
    
    func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> Int {
        if let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = UnsafePointer<UInt8>(data.bytes)
            var bytesRemaining = data.length
            var totalBytesWritten = 0
            
            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }
                
                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }
            
            return totalBytesWritten
        }
        
        return -1
    }
    
}

