//
//  FilenameCell.swift
//  Sample-CompressedFile
//
//  Created by Ronaldo GomesJr on 14/08/2015.
//  Copyright © 2015 Technophile IT. All rights reserved.
//

import UIKit

class FilenameCell: UITableViewCell {

    var fileURL:NSURL?
    
    @IBOutlet var filename:UILabel!
    @IBOutlet var unzippedFilename:UILabel!
    
    func setupCell(fileURL:NSURL) {
        self.fileURL = fileURL
        self.filename.text = (self.fileURL!.path?.pathComponents.last)!
    }
    
    func progressComplete(filename:String) {
        self.unzippedFilename.text = filename
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
