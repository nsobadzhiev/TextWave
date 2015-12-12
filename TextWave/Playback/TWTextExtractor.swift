//
//  TWTextExtractor.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/7/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

enum TWTextExtractionAlgorithm {
    case TextToTagRatio
    case JusText
}

class TWTextExtractor {
    var preferedAlgorithm:TWTextExtractionAlgorithm = TWTextExtractionAlgorithm.JusText
    
    func extractArticle(htmlString htmlString:String?) -> String {
        switch self.preferedAlgorithm {
        case TWTextExtractionAlgorithm.JusText:
            return self.extractArticleJusText(htmlString: htmlString)
        case TWTextExtractionAlgorithm.TextToTagRatio:
            return self.extractArticleTTR(htmlString: htmlString)
        }
    }
    
    func extractArticleJusText(htmlString htmlString:String?) -> String {
        if let htmlString = htmlString {
            let stopWordsPath = self.jusTextStopWordsFilePath()
            let jusTextExtractor = TextExractor(html: htmlString, stopWordsFile: stopWordsPath)
            let extractedText = jusTextExtractor.extractedText
            let nonEscapedText = extractedText.gtm_stringByUnescapingFromHTML()
            return nonEscapedText
        }
        else {
            return ""
        }
    }
    
    func extractArticleTTR(htmlString htmlString:String?) -> String {
        if let htmlString = htmlString {
            return TTRArticleExtractor.articleText(htmlString)
        }
        else {
            return ""
        }
    }
    
    // MARK: Private methods
    
    func jusTextStopWordsFilePath() -> String? {
        // For now, only English stop words are supported
        let filePath = NSBundle.mainBundle().pathForResource("English", ofType: "txt")
        return filePath
    }
}