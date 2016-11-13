//
//  TWTextExtractor.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/7/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

enum TWTextExtractionAlgorithm {
    case textToTagRatio
    case jusText
}

class TWTextExtractor {
    var preferedAlgorithm:TWTextExtractionAlgorithm = TWTextExtractionAlgorithm.jusText
    
    func extractArticle(htmlString:String?) -> String {
        switch self.preferedAlgorithm {
        case TWTextExtractionAlgorithm.jusText:
            return self.extractArticleJusText(htmlString: htmlString)
        case TWTextExtractionAlgorithm.textToTagRatio:
            return self.extractArticleTTR(htmlString: htmlString)
        }
    }
    
    func extractArticleJusText(htmlString:String?) -> String {
        if let htmlString = htmlString {
            let stopWordsPath = self.jusTextStopWordsFilePath()
            let jusTextExtractor = TextExractor(html: htmlString, stopWordsFile: stopWordsPath)
            let extractedText = jusTextExtractor?.extractedText
            let nonEscapedText = extractedText?.gtm_stringByUnescapingFromHTML()
            return nonEscapedText!
        }
        else {
            return ""
        }
    }
    
    func extractArticleTTR(htmlString:String?) -> String {
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
        let filePath = Bundle.main.path(forResource: "English", ofType: "txt")
        return filePath
    }
}
