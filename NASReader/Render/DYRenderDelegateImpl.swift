//
//  DYRenderDelegateImpl.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/27.
//

import Foundation

struct DYRenderDelegateImpl: DYRenderDelegate {
    private let reader: DYBookReader
    
    init(reader: DYBookReader) {
        self.reader = reader
    }
    
    func switchTo(chapterIndex: Int, pageIndex: Int) -> Bool {
        if reader.isValidPageIndex(pageIndex) && reader.isValidChapterIndex(chapterIndex) {
            reader.pageIdx = Int32(pageIndex)
            reader.chapterIdx = Int32(chapterIndex)
            return true
        } else {
            return false
        }
    }
    
    func switchPrevPage() -> Bool {
        let pageIdx = Int(reader.pageIdx) - 1
        guard pageIdx >= 0 else { return false }
        guard let chapterIdx = reader.getChapterIndex(pageIndex: pageIdx) else { return false }
        return switchTo(chapterIndex: chapterIdx, pageIndex: pageIdx)
    }
    
    func switchNextPage() -> Bool {
        let pageIdx = Int(reader.pageIdx) + 1
        guard pageIdx < reader.pageNum else { return false }
        guard let chapterIdx = reader.getChapterIndex(pageIndex: pageIdx) else { return false }
        return switchTo(chapterIndex: chapterIdx, pageIndex: pageIdx)
    }
}

extension DYBookReader {
    func isValidPageIndex(_ index: Int) -> Bool { (0..<Int(pageNum)).contains(index) }
    func isValidChapterIndex(_ index: Int) -> Bool { (0..<chapterList.count).contains(index) }
}
