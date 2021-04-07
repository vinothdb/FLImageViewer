//
//  FLViewerController.swift
//  FLImageViewer
//
//  Created by Vinoth on 13/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

protocol FLViewControllerDelegate: AnyObject {
	func didChangeSelectedImageIndex()
}

class FLViewerController: UIViewController {

    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var actionsAtTopStack: UIStackView!
    @IBOutlet private weak var topActionStackDummyView: UIView!
    @IBOutlet private weak var actionsAtBottonStack: UIStackView!
    @IBOutlet private weak var buttomActionStackDummyView: UIView!
    
    @IBOutlet weak var viewerTable: UITableView!
    @IBOutlet private weak var tileListTable: UITableView!
    
    @IBOutlet private weak var tileListWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageStackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerAlignImageStackConstraint: NSLayoutConstraint!
	
    var images: [FLImage] = []
    var tileCellSize: CGFloat = 0
    var actions: [(button:FLButton, align:Alignment)] = [] {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            self.setUpActionList()
        }
    }
    
    private var showTileList : Bool {
        return tileCellSize != 0
    }
    
    private var topActionStackDummyViewIndex = 0
    private var bottomActionStackDummyViewIndex = 0
    private var viewerTable_isAutoScrolling = false
    private var tileListSelectedIndexpath = IndexPath(row: 0, section: 0) {
        willSet(value) {
            self.updateTileListCellSelected(self.tileListSelectedIndexpath, new: value)
        }
		didSet {
			self.delegate?.didChangeSelectedImageIndex()
		}
    }
    
    @available(iOS 13.0, *)
    private lazy var viewerTableDatasource: FLImageDataSource = {
        FLImageDataSource(tableView: self.viewerTable) { (table, indexPath, _) in
            
            let cell : FLViewerTableCell = .cell(forTable: table, indexPath: indexPath, identifier: "FLViewerTableCellId")
            cell.fl_imageview.image = self.images[indexPath.row].image
            cell.fl_imageview.resetZoom()
            
            return cell
        }
    }()
    
    @available(iOS 13.0, *)
    private lazy var tileListTableDatasource: FLImageDataSource = {
        FLImageDataSource(tableView: self.tileListTable) { (table, indexPath, _) in
            
            let cell : FLTileListCell = .cell(forTable: table, indexPath: indexPath, identifier: "FLTileListCellId")
            cell.fl_imageview.contentMode = .scaleAspectFill
            cell.fl_imageview.image = self.images[indexPath.row].image
            cell.setSelected(indexPath == self.tileListSelectedIndexpath)
            
            return cell
        }
    }()
	
	weak var interfaceDelegate: FLImageViewDelegate?
	weak var delegate: FLViewControllerDelegate?
    
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
    
    func reloadTables() {
       
        if #available(iOS 13, *) {
            self.viewerTableDatasource.apply(images: self.images)
        } else {
            self.viewerTable.dataSource = self
            self.viewerTable.reloadData()
        }
        
        guard self.showTileList else {
            return
        }
        
        let highlightCurrentCell = {
            guard self.viewerTable.hasIndexPath(self.tileListSelectedIndexpath) else {
                if let newIndexPath = self.viewerTable.indexPathForRow(at: self.viewerTable.contentOffset) {
                    self.tileListSelectedIndexpath = newIndexPath
                }
                return
            }
            //Highlight first cell as selected
            self.updateTileListCellSelected(nil, new: self.tileListSelectedIndexpath)
        }
        
        self.tileListTable.delegate = self
        self.tileListWidthConstraint.constant = tileCellSize
        
        if #available(iOS 13, *) {
            self.tileListTableDatasource.apply(images: self.images) {
                highlightCurrentCell()
            }
        } else {
            self.tileListTable.dataSource = self
            self.tileListTable.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: highlightCurrentCell)
        }
        self.setTilesTableEdgeInsets()
    }
    
    //Aligns cell to the center of Table
    private func setTilesTableEdgeInsets() {
        
        var inset = self.tileListTable.bounds.height
        let totalCellsHeight = self.tileListTable.bounds.width * CGFloat(self.images.count)
        
        if totalCellsHeight < inset {
            inset -= totalCellsHeight
        }
        self.tileListTable.contentInset = UIEdgeInsets(top: inset/2, left: 0, bottom: inset/2, right: 0)
    }
    
    private func setUpActionList() {
		self.topActionStackDummyViewIndex = 0
		self.bottomActionStackDummyViewIndex = 0
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
        switch (self.actionsAtTopStack.subviews.count == 1, self.actionsAtBottonStack.subviews.count == 1) {
        case (true, true):
            self.imageStackHeightConstraint.constant += FLSizeConstants.action * 2
        case (false, true):
            self.imageStackHeightConstraint.constant += FLSizeConstants.action
            self.centerAlignImageStackConstraint.constant = FLSizeConstants.action / 2
        case (true, false):
            self.imageStackHeightConstraint.constant += FLSizeConstants.action
            self.centerAlignImageStackConstraint.constant = -FLSizeConstants.action / 2
        case (false, false): break
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == self.viewerTable else { return }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == self.viewerTable else { return }
        viewerTable_isAutoScrolling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.showTileList, !self.viewerTable_isAutoScrolling,
            scrollView == self.viewerTable,
            let viewerTableScrolledToIndexPath = self.viewerTable.indexPathForRow(at: scrollView.contentOffset) else {
                return
        }
        
        self.tileListSelectedIndexpath = viewerTableScrolledToIndexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard tableView == self.tileListTable, self.tileListSelectedIndexpath != indexPath else {
            return
        }
        self.viewerTable_isAutoScrolling = true
        self.viewerTable.scrollToRow(at: indexPath, at: .middle, animated: true)
        self.tileListSelectedIndexpath = indexPath
    }
    
    func updateTileListCellSelected(_ old: IndexPath?, new: IndexPath) {
        guard old !=  new else {
            return
        }
        if let oldIndexPath = old, let prevCell = self.tileListTable.cellForRow(at: oldIndexPath) as? FLTileListCell {
            prevCell.setSelected(false)
        }
		
		// when tried to add more images, scroll the tile list table to last and selected the first image in image view the tile list is not scrolling to the first, as the cell is return nil
        if let cell = self.tileListTable.cellForRow(at: new) as? FLTileListCell {
            cell.setSelected(true)
            self.tileListTable.scrollToRow(at: new, at: .middle, animated: true)
        }
        
    }
}

extension FLViewerController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        
        case self.viewerTable:
            let cell : FLViewerTableCell = .cell(forTable: tableView, indexPath: indexPath, identifier: "FLViewerTableCellId")
            cell.fl_imageview.image = self.images[indexPath.row].image
            
            return cell
        
        case self.tileListTable:
            let cell : FLTileListCell = .cell(forTable: tableView, indexPath: indexPath, identifier: "FLTileListCellId")
            cell.fl_imageview.contentMode = .scaleAspectFill
            cell.fl_imageview.image = self.images[indexPath.row].image
            
            return cell
        
        default: return UITableViewCell()
        }
    }
}


extension FLViewerController: FLImageViewProtocol {
	
    func currentImageIndex() -> Int {
        return self.viewerTable.indexPathForRow(at: self.viewerTable.contentOffset)?.row ?? 0
    }
    
    func reloadImages(images: [FLImage]) {
        self.images = images
        self.reloadTables()
    }
}
