# react-native-tesseract

Supports OCR with Tesseract from react native

# Installation

```
yarn add rhdeck/react-native-tesseract
react-native link
```

Note that this package has two peer dependencies that need to be installed. Quick way:

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

## async setLanguage(newLanguage: String | [String])

Sets the language(s) for use. Pass array for multiple languages. Note that the language identifier(s) need(s) to be in the format that the trained tessdata is in, e.g. from the [tessdata repository](https://github.com/tesseract-ocr/tessdata/) "eng" for English, etc.

## async setDataPath(newPath: String)

Sets the path for the trained data. Defaults to null, which expects it to be bundled with the app in a directory called "tessdata". Set it to a user path to allow on-the-fly downloading, which is convenient!

## async setFastMode(isFast: Boolean)

Set whether to use less-accurate tesseract only mode (default) or the slower but more-accurage tesseract+cube method.

## async recognizeFile(path: String)

Scan a saved jpg or png file on disk and return the text.

# Example TODO

(Assuming a little help from react-native-camera and react-native-fs)

```javascript
import RNFS from 'react-native-fs'
import RNTesseract from 'react-native-tesseract'
import {RNCamera} from 'react-native-camera'
export default class App extends Component {
    return (
        <TouchableOpacity onPress={()=>{
            this.camera
        }}>
            <RNCamera    ref={(cam)=> {this.camera = cam}}>
                <Text>{this.state.text}</Text>
            </Camera>
        </TouchableOpacity>
    )
}


(async () => {
    const tempPath = RNFS.TemporaryDirectoryPath + "/eng.trainddata"
    const sourceurl = 'https://github.com/tesseract-ocr/tessdata/blob/master/eng.traineddata?raw=true'
    const {promise, jobid} = RNFS.downloadFile({fromUrl: sourceurl, toFile: tempPath})
    const done = await promise;
    await RNTesseract.setLanguage('eng');
    await RNTesseract.setDataPath(RNFS.TemporaryDirectoryPath)
    await RNTesseract.isFastMode(true)
    //Get an image

})();
```
