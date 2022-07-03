//
//  DQPageMaker.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/3.
//

import Foundation

protocol DQPageMaker {
    func getPage(page: Int, size: CGSize) -> UIView
}
