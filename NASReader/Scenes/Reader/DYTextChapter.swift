//
//  DYTextChapter.swift
//  TextBookDemo
//
//  Created by oneko.c on 2022/9/16.
//

import UIKit
import DTCoreText

struct DYTextChapter {
    let title: String
    let content: String
    var pageSize: CGSize = .zero
    var pages: [NSAttributedString] = []
    
    mutating func cutPages(titleFont: UIFont, contentFont: UIFont, lineHeightMultipler: CGFloat, textColor: UIColor, size: CGSize) {
        pageSize = size
        pages.removeAll()
        
        let attributesContent = attributesString(titleFont: titleFont, contentFont: contentFont, lineHeightMultipler: lineHeightMultipler, textColor: textColor)
        let layouter = DTCoreTextLayouter(attributedString: attributesContent)
        let rect = CGRect(origin: .zero, size: size)
        
        var rangeOffset = 0
        repeat {
            var frame11 = layouter?.layoutFrame(with: rect, range: NSRange(location: rangeOffset, length: attributesContent.length))
            var visibleRange = frame11?.visibleStringRange()
            let pageAttributesString = attributesContent.attributedSubstring(from: visibleRange!)
            rangeOffset = visibleRange!.location + visibleRange!.length
            pages.append(pageAttributesString)
        } while rangeOffset < attributesContent.length && rangeOffset != 0
    }
    
    private func attributesString(titleFont: UIFont, contentFont: UIFont, lineHeightMultipler: CGFloat, textColor: UIColor) -> NSAttributedString {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .paragraphStyle: titleParagraphStyle,
            .foregroundColor: textColor
        ]
        let contentParagraphStyle = NSMutableParagraphStyle()
        contentParagraphStyle.alignment = .justified
        contentParagraphStyle.lineHeightMultiple = lineHeightMultipler
        
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: contentFont,
            .paragraphStyle: contentParagraphStyle,
            .foregroundColor: textColor
        ]
        let title = "\n\(title)\n\n"
        let titleAttributesString = NSAttributedString(string: title, attributes: titleAttributes)
        let contentAttributesString = NSAttributedString(string: content, attributes: contentAttributes)
        let chapterAttributesString = NSMutableAttributedString()
        chapterAttributesString.append(titleAttributesString)
        chapterAttributesString.append(contentAttributesString)
        return chapterAttributesString
    }
    
    func getPage(at index: Int) -> UIView? {
        var page: UIView?
        if pages.indices.contains(index) {
            let label = UILabel(frame: CGRect(origin: .zero, size: pageSize))
            label.numberOfLines = 0
            label.attributedText = pages[index]
            page = label
        }
        return page
    }
}
