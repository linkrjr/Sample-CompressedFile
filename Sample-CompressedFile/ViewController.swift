//
//  ViewController.swift
//  Sample-CompressedFile
//
//  Created by Ronaldo GomesJr on 11/08/2015.
//  Copyright © 2015 Technophile IT. All rights reserved.
//

import UIKit
import ZipZap

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func zipPDFButtonTapped(sender: AnyObject) {
        do {
            let bundle = NSBundle.mainBundle()
            let newArchive = try ZZArchive(URL: NSURL.fileURLWithPath(bundle.resourcePath!.stringByAppendingPathComponent("/pdf.zip")), options: [ZZOpenOptionsCreateIfMissingKey: true])
            
            let entries:[ZZArchiveEntry] = [ZZArchiveEntry(fileName: "MeteorBook.pdf", compress: true, dataBlock: { (error) -> NSData! in
                return NSData(contentsOfFile: bundle.pathForResource("MeteorBook", ofType: "pdf")!)
            })]
            try newArchive.updateEntries(entries)
            
        } catch {
            print(error)
        }
        
    }

    @IBAction func unzipPDFButtonTapped(sender: AnyObject) {
        do {
            
            let bundle = NSBundle.mainBundle()
            
            let archive = try ZZArchive(URL: NSURL(fileURLWithPath: bundle.resourcePath!.stringByAppendingPathComponent("pdf.zip")))
            
//            bundle.resourcePath!.stringByAppendingPathComponent("unzipped.pdf")
            
            for entry in archive.entries {
                
                let data = try (entry as! ZZArchiveEntry).newData()
                data.writeToURL(NSURL(fileURLWithPath: bundle.resourcePath!.stringByAppendingPathComponent("unzipped.pdf")), atomically: false)
                
            }
            
        } catch {
            print(error)
        }
    }
}

