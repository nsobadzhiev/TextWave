# TextWave

![TextWave logo](TextWave/Resouces/Images/AppIcon.png)

TextWave is an iOS application that reads for you. It will extract the text out of webpages and use the built-in text-to-speech capabilites of your iPhone to play it back.

## Supported formats

### HTML

Currently, TextWave has full support for web pages. It can download, extract text and playback.

### ePub

The ePub support is highly experimental and disabled from the app. But most code is there and working. However, it is still pending bugfixes and improvements

### PDF

Unavailable

### Plain text

Technically not implemented but easy to achieve

## Text-to-speech

TextWave uses the built-in `AVSpeechSynthesizer` class to synthesize speech. However, the dependency on `AVFoundation` is encapsulated in entirely in `TWPlaybackManager` so it's easy to replace that with any other text-to-speech provider

## Current progress

Unfortunately, TextWave is not yet complete and unavailable in the AppStore. It's still pending lots of improvements and fixes. Ideally ePub support and playlists.

## Swift?

TextWave is largely written in Swift and migrated to Swift 3. However, it still contains a lot of Objective-C code, particularly in the underlying business logic

## Technologies

### Text-to-speech

TextWave uses the built-in `AVSpeechSynthesizer` class to synthesize speech. However, the dependency on `AVFoundation` is encapsulated in entirely in `TWPlaybackManager` so it's easy to replace that with any other text-to-speech provider

### HTML readable text extraction

For stripping only the useful, human readable text out of a web page, TextWave experiments with two algorithms. They are both implemented in the binary, but only one is toggled on and used by the application.

#### JusText

JusText is a boilerplate removal algorithm that I ported over to iOS. The project for that is [available here](https://github.com/nsobadzhiev/JusText_iOS). Otherwise, TextWave uses a precompiler universal library containing all JusText code. In testing, JusText has proven to be a more effective tool for extraction than TTR

#### Text-to-Tag Ratio (TTR)

Text-to-Tag Ratio is another algorithm for extraction, [described here](https://www3.nd.edu/~tweninge/pubs/WH_TIR08.pdf). I implemented a native Objective-C version of it [here](https://github.com/nsobadzhiev/TTR). The TextWave project uses that repository as a git submodule. Even though testing has show that JusText is overall better at extracting the useful text from webpages nowadays, TTR shows decent results.

## Third party libraries
