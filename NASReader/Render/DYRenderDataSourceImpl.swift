//
//  DYRenderDataSourceImpl.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/27.
//

import Foundation

struct DYRenderDataSourceImpl: DYRenderDataSource {
    var pageSize: CGSize {
        return reader.pageSize
    }
    var currentPageIdx: Int {
        return Int(reader.pageIdx)
    }
    var currentChapterIdx: Int {
        return Int(reader.getChapterIndex(withPageIndex: Int32(currentPageIdx)))
    }
    var pageNum: Int {
        return Int(reader.pageNum)
    }
    private let reader: DYBookReader
    init(reader: DYBookReader) {
        self.reader = reader
    }
    
    func getPageAt(index: Int) -> UIView? {
        guard index >= 0 && index < reader.pageNum else { return nil }
        return reader.getPageView(atPage: Int32(index))
    }
    
    func getCurrentPage() -> UIView? {
        return getPageAt(index: currentPageIdx)
    }
    
    func getChapterIndex(pageIndex: Int) -> Int? {
        return Int(reader.getChapterIndex(withPageIndex: Int32(pageIndex)))
    }
}
