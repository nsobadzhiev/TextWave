//
//  TWPlaybackManagerTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

class TWPlaybackManagerTests: XCTestCase, TWPlaybackManagerDelegate {
    
    var wasNotifiedBeginItem = false
    var wasNotifiedFinishItem = false
    var wasNotifiedMovePosition = false
    
    var delegatedIndex = -1
    
    var source: TWMockPlaybackSource! = TWMockPlaybackSource(url: NSURL(string: "http://path/to/file"))
    var playback: TWMockPlaybackManager! = nil
    var textToSpeech: TWMockSpeechSynthesizer! = TWMockSpeechSynthesizer()

    override func setUp() {
        super.setUp()
        playback = TWMockPlaybackManager(dataSource: self.source)
        playback.delegate = self
        playback.speechSynthesizer = textToSpeech
        source.currentText = "test"
    }
    
    override func tearDown() {
        source = nil
        playback = nil
        textToSpeech = nil
        super.tearDown()
    }
    
    // MARK: TWPlaybackManagerDelegate methods
    
    func playbackManager(playback: TWPlaybackManager, didBeginItemAtIndex index: Int) {
        wasNotifiedBeginItem = true
        delegatedIndex = index
    }
    
    func playbackManager(playback: TWPlaybackManager, didFinishItemAtIndex index: Int) {
        wasNotifiedFinishItem = true
        delegatedIndex = index
    }
    
    func playbackManager(playback: TWPlaybackManager, didMoveToPosition index: Int) {
        wasNotifiedMovePosition = true
        delegatedIndex = index
    }

    func testCreatingSpeechSynthesizerAfterInit() {
        XCTAssertNotNil(playback.speechSynthesizer, "Should create an AVSpeechSynthesizer during initialization")
    }
    
    func testPausingSpeech() {
        playback.pause()
        XCTAssertTrue(textToSpeech.hasAskedToPause, "Should tell the speech synthesizer to pause whenever a playback manager is paused")
    }

    func testResumingSpeech() {
        playback.resume()
        XCTAssertTrue(textToSpeech.hasAskedToResume, "Should tell the speech synthesizer to resume whenever a playback manager is resumed")
    }

    func testGoingToNextSection() {
        let nextSpeechString = "Next section"
        source.currentText = nextSpeechString
        playback.next()
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(source.hasAskedNextSection, "Should have asked the playback source for the next section")
        XCTAssertTrue(source.hasAskedNextSection, "Should have asked the playback source for the next section")
        XCTAssertTrue(utteranceText == nextSpeechString, "Should have supplied the AVSpeechSynthesizer with the next section text retrieved from the playback source")
    }
    
    func testStoppingPlaybackBeforeGoingToNextSection() {
        playback.next()
        XCTAssertTrue(textToSpeech.hasAskedToStopPlayback, "When going to the next section, the AVSpeechSynthesizer has to be stopped so that it does not queue the next section until the current one is finished")
    }
    
    func testGoingToPreviousSection() {
        let previousSpeechString = "Previous section"
        source.previousSpeechString = previousSpeechString
        playback.previous()
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(source.hasAskedPreviousSection, "Should have asked the playback source for the next section")
        XCTAssertTrue(utteranceText == previousSpeechString, "Should have supplied the AVSpeechSynthesizer with the previous section text retrieved from the playback source")
    }
    
    func testStoppingPlaybackBeforeGoingToPreviousSection() {
        playback.previous()
        XCTAssertTrue(textToSpeech.hasAskedToStopPlayback, "When going to the a previous section, the AVSpeechSynthesizer has to be stopped so that it does not queue the next section until the current one is finished")
    }
    
    func testAbilityToSetSpeechRate() {
        let speakingRate: Float = 0.6
        playback.speechRate = speakingRate
        // go to the next section to make sure all subsequent sections will apply the same rate
        playback.next()
        if let usedRate = textToSpeech.suppliedUtterance?.rate {
            XCTAssertEqual(usedRate, speakingRate, "Should be able to set the rate an the AVSpeechSynthesizer")
        }
        else {
            XCTFail("Rate should not have no value")
        }
    }

    func testAbilityToSetSpeechPitch() {
        let speakingPitch: Float = 0.5
        playback.speechPitch = speakingPitch
        // go to the next section to make sure all subsequent sections will apply the same rate
        playback.next()
        if let usedPitch = textToSpeech.suppliedUtterance?.pitchMultiplier {
            XCTAssertEqual(usedPitch, speakingPitch, "Should be able to set the pitch an the AVSpeechSynthesizer")
        }
        else {
            XCTFail("pitchMultiplier should not have no value")
        }
    }
    
    func testNotifyingDelegateDidBeginSpeech() {
        textToSpeech.delegate!.speechSynthesizer!(textToSpeech, didStartSpeechUtterance: nil)
        XCTAssertTrue(wasNotifiedBeginItem, "Should notify the delegate whenever AVSpeechSynthesizer starts a new item")
    }
  
    func testNotifyingDelegateDidEndSpeech() {
        textToSpeech.delegate!.speechSynthesizer!(textToSpeech, didFinishSpeechUtterance: nil)
        XCTAssertTrue(wasNotifiedFinishItem, "Should notify the delegate whenever AVSpeechSynthesizer finishes an item")
    }
    
    func testNotifyingDelegateDidSpeakRange() {
        textToSpeech.delegate!.speechSynthesizer!(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 1), utterance: nil)
        XCTAssertTrue(wasNotifiedMovePosition, "Should notify the delegate whenever AVSpeechSynthesizer makes progress")
    }
    
    func testNotifyingDelegateBeginSpeechIndex() {
        playback.next()
        playback.next()
        playback.speechSynthesizer(textToSpeech, didStartSpeechUtterance: nil)
        XCTAssertEqual(delegatedIndex, 1, "Should notify the current index in delegate methods")
    }
    
    func testNotifyingDelegateFinishSpeechIndex() {
        playback.next()
        playback.next()
        playback.next()
        playback.speechSynthesizer(textToSpeech, didFinishSpeechUtterance: nil)
        XCTAssertEqual(delegatedIndex, 2, "Should notify the current index in delegate methods")
    }
    
    func testCountingSpokenWords() {
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 1), utterance: nil)
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 1), utterance: nil)
        XCTAssertEqual(playback.wordIndex, 2, "Should indicate that two words have been spoken")
    }

    func testCountingSpokenWordsInDelegate() {
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 1), utterance: nil)
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 1), utterance: nil)
        XCTAssertEqual(delegatedIndex, 2, "Should notify delegate how many words have been spoken")
    }
    
    func testCountingSpeechTextOffset() {
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 15), utterance: nil)
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(16, 5), utterance: nil)
        XCTAssertEqual(playback.letterIndex, 20, "Should keep track of position within the spoken text")
    }
    
    // skipping forward
    
    func testSkippingForwardWithCorrectLetterIndex() {
        let nextSpeechString = "Next section Next section Next section Next section Next section "
        source.currentText = nextSpeechString
        playback.next()
        playback.skipForward()
        XCTAssertEqual(playback.letterIndex, 30, "Skipping forward should result in moving the letter index 30 characters to the right")
    }
    
    func testSkippingForwardWithCorrectSpeechString() {
        let nextSpeechString = "Next section Next section Next section Next section Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.skipForward()
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(utteranceText == " section Next section Next section", "The next utterance should contain the remainder of the speech (after the 30 letter skip)")
    }
    
    func testSkippingForwardEndingMidWord() {
        let nextSpeechString = "Next section Next section Nextnext section Next section Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.skipForward()
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(utteranceText == " section Next section Next section", "The next utterance should contain the remainder of the speech and skip more than 30 characters to avoid starting the next utterance in the middle of a word")
    }
    
    func testSkippingForwardLessThan30CharactersFromTheEnd() {
        let nextSpeechString = "Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.skipForward()
        XCTAssertTrue(source.currentItemIndex == 1, "If the current position is skipped beyond the bounds of the current section, the next one should be started")
    }
    
    // skipping backwards
    
    func testSkippingBackwardsWithCorrectLetterIndex() {
        let nextSpeechString = "Next section Next section Next section Next section Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 35), utterance: nil)
        playback.skipBackwards()
        XCTAssertEqual(playback.letterIndex, 5, "Skipping backwards should result in moving the letter index 30 characters to the left")
    }
    
    func testSkippingBackwardsWithCorrectSpeechString() {
        let nextSpeechString = "Next section Next section Next section Next section Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 35), utterance: nil)
        playback.skipBackwards()
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(utteranceText == "section Next section Next section Next section Next section", "The next utterance should contain the start of the speech (before the 30 letter skip)")
    }
    
    func testSkippingBackwardsEndingMidWord() {
        let nextSpeechString = "Next section Next section Next section Next section Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 40), utterance: nil)
        playback.skipBackwards()
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(utteranceText == " Next section Next section Next section Next section", "The next utterance should contain the remainder of the speech and skip less than 30 characters to avoid starting the next utterance in the middle of a word")
    }
   
    func testSkippingBackwardsLessThan30CharactersFromTheBegining() {
        let nextSpeechString = "Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.next()
        playback.speechSynthesizer(textToSpeech, willSpeakRangeOfSpeechString: NSMakeRange(0, 5), utterance: nil)
        playback.skipBackwards()
        XCTAssertTrue(source.currentItemIndex == 0, "If the current position is skipped beyond the bounds of the current section, the next one should be started")
    }

    func testSettingProgressPercentage() {
        let nextSpeechString = "Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.setPlaybackProgress(0.5)
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString
        XCTAssertTrue(utteranceText == "ection", "Should be able to specify a percentage of progress to which to skip playback")
    }

    func testInvalidProgressPercentage() {
        let nextSpeechString = "Next section"
        source.currentText = nextSpeechString
        playback.next()
        playback.setPlaybackProgress(1.5)
        let utterance = textToSpeech.suppliedUtterance
        let utteranceText = utterance?.speechString?
        XCTAssertTrue(utteranceText == nextSpeechString, "The uterrance text should remain the same if the progress is not between 0 and 1")
    }
}
