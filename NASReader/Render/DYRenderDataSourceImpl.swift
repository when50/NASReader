//
//  DYRenderDataSourceImpl.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/27.
//

import Foundation

struct DYRenderDataSourceImpl: DYRenderDataSource {
    var currentPageIdx: Int {
        get {
            return Int(reader.pageIdx)
        }
    }
    var currentChapterIdx: Int {
        get {
            return reader.getChapterIndex(pageIndex: currentPageIdx) ?? 0
        }
    }
    var pageNum: Int {
        get {
            return Int(reader.pageNum)
        }
    }
    private let reader: DYBookReader
    let pageSize: CGSize
    
    init(reader: DYBookReader, pageSize: CGSize) {
        self.reader = reader
        self.pageSize = pageSize
    }
    
    func getPageAt(index: Int) -> UIView? {
        return reader.getPageView(atPage: Int32(index), size: pageSize)
    }
    
    func getCurrentPage() -> UIView? {
        return getPageAt(index: currentPageIdx)
    }
    
    func getChapterIndex(pageIndex: Int) -> Int? {
        return reader.getChapterIndex(pageIndex: pageIndex)
    }
}

extension DYBookReader {
    func getChapterIndex(pageIndex: Int) -> Int? {
        var chapterIndex: Int? = nil
        for i in chapterList.indices {
            if let chapter = chapterList[i] as? DYChapter, chapter.pageIdx >= pageIndex {
                chapterIndex = i
                break
            }
        }
        return chapterIndex
    }
}
