# react-native-tesseract

Supports OCR with Tesseract from react native

# Installation

```
yarn add rhdeck/react-native-tesseract
react-native link
```

Note that this package has two peer dependencies that need to be installed: [react-native-swift](https://npmjs.org.package.react-native-swift) and [react-native-pod](https://npmjs.org/package/react-native-pod). Quick way to install them dynamicallyis to use [promote-peer-dependencies](https://npmjs.com/promote-peer-dependencies):

```
yarn global add promote-peer-dependencies
promote-peer-dependencies
react-native link
```

**OR** add them yourself

```
yarn add react-native-swift react-native-pod
react-native link
```

# Usage

(Currently just key functionality)

## async setLanguage(newLanguage: String | [String])

Sets the language(s) for use. Pass array for multiple languages. Note that the language identifier(s) need(s) to be in the format that the trained tessdata is in, e.g. from the [tessdata repository](https://github.com/tesseract-ocr/tessdata/) "eng" for English, etc.

## async setDataPath(newPath: String)

Sets the path for the trained data. Set it to a user path to allow on-the-fly downloading, which is convenient!

## async setFastMode(isFast: Boolean)

Set whether to use less-accurate tesseract only mode (default) or the slower but more-accurage tesseract+cube method.

## async recognizeFile(path: String)

Scan a saved jpg or png file on disk and return the text. This can take several seconds!

# Example Template

See [react-native-template-tesseractocr](https://npmjs.com/package/react-native-template-tesseractocr) or just implement as follows:

```
react-native init mytesstest --template tesseractocr
cd mytesstest
react-native setdevteam
react-native link
react-native run-ios --device
```

## Note 1

[react-native-setdevteam](https://npmjs.com/package/react-native-setdevteam) will set your development team to let you sign and deploy your app to device)

## Note 2

Experienced RN templaters will notice the call to `react-native link` up there. It's necessary, and feel free to hit me up with an issue or DM if you want to go into the bowels of why. (It has to do with `react-native-camera-clean`)
