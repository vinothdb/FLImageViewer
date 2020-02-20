//
//  FLViewerController.swift
//  FLImageViewer
//
//  Created by Vinoth on 13/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class FLViewerController: UIViewController {

    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var actionsAtTopStack: UIStackView!
    @IBOutlet private weak var topActionStackDummyView: UIView!
    @IBOutlet private weak var actionsAtBottonStack: UIStackView!
    @IBOutlet private weak var buttomActionStackDummyView: UIView!
    
    @IBOutlet private weak var viewerTable: UITableView!
    @IBOutlet private weak var tileListTable: UITableView!
    
    @IBOutlet private weak var tileListWidthConstraint: NSLayoutConstraint!
    
    var images: [FLImage] = []
    var tileCellSize: CGFloat = 0
    var actions : [(button:FLButton, align:Alignment)] = []
    
    private var showTileList : Bool {
        return tileCellSize != 0
    }
    
    private var topActionStackDummyViewIndex = 0
    private var bottomActionStackDummyViewIndex = 0
    
    @available(iOS 13.0, *)
    private lazy var viewerTableDatasource: FLImageDataSource = {
        FLImageDataSource(tableView: self.viewerTable) { (table, indexPath, _) in
            
            let cell : ViewerTableCell = .cell(forTable: table, indexPath: indexPath, identifier: "ViewerTableCellId")
            cell.fl_imageview.image = self.images[indexPath.row].image
            
            return cell
        }
    }()
    
    @available(iOS 13.0, *)
    private lazy var tileListTableDatasource: FLImageDataSource = {
        FLImageDataSource(tableView: self.tileListTable) { (table, indexPath, _) in
            
            let cell : TileListCell = .cell(forTable: table, indexPath: indexPath, identifier: "TileListTableCellId")
            cell.fl_imageview.contentMode = .scaleToFill
            cell.fl_imageview.image = self.images[indexPath.row].image
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    private func setUpView() {
        defer {
            self.setUpActionList()
        }
        
        self.tileListTable.isHidden = !self.showTileList
        self.containerView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        self.viewerTable.delegate = self
        
        self.reloadTables()
    }
    
    private func reloadTables() {
       
        if #available(iOS 13, *) {
            self.viewerTableDatasource.apply(images: self.images)
        } else {
            self.viewerTable.dataSource = self
            self.viewerTable.reloadData()
        }
        
        guard self.showTileList else {
            return
        }
        
        self.tileListTable.delegate = self
        self.tileListWidthConstraint.constant = tileCellSize
        
        if #available(iOS 13, *) {
            self.tileListTableDatasource.apply(images: self.images)
        } else {
            self.tileListTable.dataSource = self
            self.tileListTable.reloadData()
        }
    }
    
    private func setUpActionList() {
        for action in self.actions {
            switch action.align {
            case .topLeft:
                self.actionsAtTopStack.insertArrangedSubview(action.button, at: topActionStackDummyViewIndex)
                self.topActionStackDummyViewIndex += 1
            case .topRight:
                self.actionsAtTopStack.insertArrangedSubview(action.button, at: topActionStackDummyViewIndex+1)
            case .bottomLeft:
                self.actionsAtBottonStack.insertArrangedSubview(action.button, at: bottomActionStackDummyViewIndex)
                self.bottomActionStackDummyViewIndex += 1
            case .bottomRight:
                self.actionsAtBottonStack.insertArrangedSubview(action.button, at: bottomActionStackDummyViewIndex+1)
            }
        }
    }
}

//MARK:- Viewer table actions
extension FLViewerController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableView {
        case self.viewerTable:
            return tableView.bounds.height
        case self.tileListTable:
            return tableView.bounds.width
        default:
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.showTileList, scrollView == self.viewerTable else {
            return
        }
        
        guard let viewerTableScrolledToIndexPath = self.viewerTable.indexPathForRow(at: scrollView.contentOffset),
            self.tileListTable.indexPathForSelectedRow !=  viewerTableScrolledToIndexPath else {
                return
        }
        
        self.tileListTable.selectRow(at: viewerTableScrolledToIndexPath, animated: true, scrollPosition: .middle)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        guard tableView == self.tileListTable else {
            return
        }
        
        self.viewerTable.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension FLViewerController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        
        case self.viewerTable:
            let cell : ViewerTableCell = .cell(forTable: tableView, indexPath: indexPath, identifier: "ViewerTableCellId")
            cell.fl_imageview.image = self.images[indexPath.row].image
            
            return cell
        
        case self.tileListTable:
            let cell : TileListCell = .cell(forTable: tableView, indexPath: indexPath, identifier: "TileListTableCellId")
            cell.fl_imageview.contentMode = .scaleToFill
            cell.fl_imageview.image = self.images[indexPath.row].image
            
            return cell
        
        default: return UITableViewCell()
        }
    }
}


extension FLViewerController {
    
    func currentImageIndex() -> Int? {
        return self.viewerTable.indexPathForRow(at: self.viewerTable.contentOffset)?.row
    }
    
    func reloadImages(images: [FLImage]) {
        self.images = images
        self.reloadTables()
    }
}
