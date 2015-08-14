//
//  ViewController.swift
//  Sample-CompressedFile
//
//  Created by Ronaldo GomesJr on 11/08/2015.
//  Copyright © 2015 Technophile IT. All rights reserved.
//

import UIKit
import ZipZap

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var unzipButton: UIBarButtonItem!
    
    private var files:[NSURL] = []
    private var selectedCell:FilenameCell?
    private var selectedCellIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.files = listZipFilesInDisk()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.unzipButton.enabled = true
        
        if let selectedIndexPath = self.selectedCellIndexPath {
            self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
        
        self.selectedCellIndexPath = indexPath
        self.selectedCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as? FilenameCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FilenameCell
        cell.setupCell(self.files[indexPath.row])
        return cell
    }

    private func listZipFilesInDisk() -> [NSURL] {
        let fileManager = NSFileManager.defaultManager()
        let bundle = NSBundle.mainBundle()
        var zipFiles:[NSURL] = []
        
        do {
            let content = try fileManager.contentsOfDirectoryAtURL(bundle.resourceURL!, includingPropertiesForKeys: [NSURLFileResourceTypeKey], options: .SkipsHiddenFiles)
            zipFiles = content.filter({ (element:NSURL) -> Bool in
                return element.pathExtension == "zip"
            })
        }
        catch {
        }

//        let search = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return zipFiles
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

    @IBAction func cleanButtonTapped(sender: AnyObject) {
        let fileManager = NSFileManager.defaultManager()
        let bundle = NSBundle.mainBundle()
        var zipFiles:[NSURL] = []
        
        do {
            let content = try fileManager.contentsOfDirectoryAtURL(bundle.resourceURL!, includingPropertiesForKeys: [NSURLFileResourceTypeKey], options: .SkipsHiddenFiles)
            zipFiles = content.filter({ (element:NSURL) -> Bool in
                return element.pathExtension == "json"
            })
            for file:NSURL in zipFiles {
                try fileManager.removeItemAtPath(file.path!)
            }
        }
        catch {
        }
        
    }
    
    @IBAction func unzipPDFButtonTapped(sender: AnyObject) {
        do {
            let bundle = NSBundle.mainBundle()
            print(bundle.resourcePath!)

            let archive = try ZZArchive(URL: self.selectedCell!.fileURL!)
            let entries = archive.entries as! [ZZArchiveEntry]
            for entry:ZZArchiveEntry in entries {
                let data = try entry.newData()
                data.writeToURL(NSURL(fileURLWithPath: bundle.resourcePath!.stringByAppendingPathComponent(entry.fileName)), atomically: false)
                self.selectedCell!.progressComplete(entry.fileName)
            }
            
        } catch {
            print(error)
        }
    }
}

