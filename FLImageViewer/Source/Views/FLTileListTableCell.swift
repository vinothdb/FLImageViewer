//
//  TileListTableCell.swift
//  FLImageViewer
//
//  Created by Vinoth on 17/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class FLImageTableCell : UITableViewCell {
    
    class func cell<T: UITableViewCell>(forTable table:UITableView, indexPath: IndexPath, identifier: String) -> T {
        
        let cell : T
        
        if let dequeuedCell = table.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
            cell = dequeuedCell
        } else {
            cell = T(style: .default, reuseIdentifier: identifier)
        }
        cell.transform = CGAffineTransform(rotationAngle: .pi/2)
        return cell
    }
}

class FLTileListCell: FLImageTableCell {

    @IBOutlet weak var fl_imageview: FLImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fl_imageview.disableZoom()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSelected(_ select:Bool) {
        fl_imageview.layer.borderColor = select ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        fl_imageview.layer.borderWidth = select ? 1 : 0
    }
}
