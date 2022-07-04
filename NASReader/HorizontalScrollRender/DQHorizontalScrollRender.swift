//
//  DQHorizontalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/4.
//

import UIKit

class DQHorizontalScrollRender: UIViewController {
    enum ConstString: String {
        case cellReuseId = "cellReuseId"
    }
    
    var collectionView: UICollectionView!
    var pageNum = 0
    
    override func loadView() {
        let collectionView = UICollectionView(frame: UIScreen.main.bounds)
        collectionView.dataSource = self
        collectionView.register(DQPageCollectionViewCell.self, forCellWithReuseIdentifier: ConstString.cellReuseId.rawValue)
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DQHorizontalScrollRender: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstString.cellReuseId.rawValue, for: indexPath)
        if let cell = cell as? DQPageCollectionViewCell {
            
        }
        return cell
    }
    
    
}

extension DQHorizontalScrollRender: DQRender {
    func buildRender(parentController: UIViewController) {
        parentController.addChild(self)
        view.frame = parentController.view.bounds
        parentController.view.addSubview(view)
        didMove(toParent: parentController)
    }
    
    func clean() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
