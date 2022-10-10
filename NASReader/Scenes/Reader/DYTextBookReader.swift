//
//  DYTextBookReader.swift
//  TextBookDemo
//
//  Created by oneko.c on 2022/9/16.
//

import UIKit
import DTCoreText

class DYTextBookReader {
    enum State {
        case closed, opening, didOpen
    }
    
    private let readerQueue = DispatchQueue(label: "TextBookReaderQueue")
    private(set) var chapterList: [DYTextChapter] = []
    private(set) var error: Error?
    private(set) var state: State = .closed
    var fontSize: CGFloat = 10.0
    var lineHeightMultiple: CGFloat = 1.5
    var pageSize: CGSize = CGSize(width: 300, height: 600)
    var textColor: UIColor = .black
    
    func openFile(_ file: String, completion: @escaping () -> Void) {
        if #available(iOS 12.0, *) {
            if let style = UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle, case .dark = style {
                textColor = .white
            }
        }
        
        self.state = .opening
        readerQueue.async {
            let url = URL(fileURLWithPath: file)
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                let titleResults = self.matchTitleWith(content: content)
                for (index, result) in titleResults.enumerated() {
                    var endLocation = 0
                    if titleResults.indices.contains(index + 1) {
                        endLocation = titleResults[index + 1].range.location
                    }
                    self.chapterList.append(self.createChapter(content: content, result: result, endLocation: endLocation))
                }
                self.state = .didOpen
                DispatchQueue.main.async {
                    completion()
                }
            } catch let err {
                self.error = err
                self.state = .closed
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private func matchTitleWith(content: String) -> [NSTextCheckingResult] {
        let pattern = "第[ ]*[0-9一二三四五六七八九十百千]*[ ]*[章回].*"
        let regExp = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let results = regExp.matches(in: content, options: .reportCompletion, range: NSMakeRange(0, content.count))
        return results
    }
    
    private func createChapter(content: String, result: NSTextCheckingResult, endLocation: Int) -> DYTextChapter {
        let startIndex = content.index(content.startIndex, offsetBy: result.range.location)
        let endIndex = content.index(startIndex, offsetBy: result.range.length)
        let title = String(content[startIndex...endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
        let contentStartIndex = content.index(content.startIndex, offsetBy: result.range.upperBound)
        let contentEndIndex = endLocation > 0 ? content.index(content.startIndex, offsetBy: endLocation) : content.endIndex
        let content = String(content[contentStartIndex..<contentEndIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
        var chapter = DYTextChapter(title: title, content: content)
        chapter.cutPages(titleFont: .boldSystemFont(ofSize: self.titleFont), contentFont: .systemFont(ofSize: self.fontSize), lineHeightMultipler: self.lineHeightMultiple, textColor: self.textColor, size: self.pageSize)
        return chapter
    }
    
    func getPage(chapterIndex: Int, pageIndex: Int) -> UIView? {
        var page: UIView?
        if (chapterList.indices.contains(chapterIndex)) {
            let chapter = chapterList[chapterIndex]
            page = chapter.getPage(at: pageIndex)
        }
        return page
    }
    
    func cutPages(font: UIFont, lineHeightMultipler: CGFloat, textColor: UIColor, size: CGSize, completion: @escaping () -> Void) {
        readerQueue.async {
            self.chapterList.indices.forEach {
                self.chapterList[$0].cutPages(titleFont: UIFont.boldSystemFont(ofSize: self.titleFont),
                                              contentFont: font,
                                              lineHeightMultipler: lineHeightMultipler,
                                              textColor: textColor,
                                              size: size)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

extension DYTextBookReader {
    struct Constant {
        static let titleFont: CGFloat = 19.0
    }
    
    var titleFont: CGFloat {
        return Constant.titleFont
    }
}
