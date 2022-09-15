//
//  DYReaderCoordinator.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

@objc
public final class DYReaderCoordinator: NSObject, Coordinator, OutlineCoordinable, DYReaderCoordinatorProtocol  {
    public var bookPath: String?
    public var renderConfig: [String: AnyObject] = [:]
    public var pageIndex: Int = 0
    public var renderConfigChangedCallback: (([String: AnyObject]) -> Void)?
    public var pageIndexChangedCallback: ((Int) -> Void)?
    
    lazy var transitioningDelegate = SlideInPresentationManager()
    
    @objc
    var navigationController: UINavigationController
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    @objc
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @objc
    public func start() {
        let viewController = DYReaderController()
        viewController.coordinator = self
        viewController.bookPath = bookPath
        viewController.pageIndex = pageIndex
        viewController.renderConfig = renderConfig
        viewController.renderConfigChangedCallback = renderConfigChangedCallback
        viewController.pageIndexChangedCallback = pageIndexChangedCallback
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showOutline(for outline: OutlineProtocol, delegate: OutlineViewControllerDelegate, brightness: Float, deepColorIsOpen: Bool) {
        transitioningDelegate.direction = .left
        showOutline(for: outline,
                    delegate: delegate,
                    transitioningDelegate: transitioningDelegate,
                    brightness: brightness,
                    deepColorIsOpen: deepColorIsOpen)
    }
}
