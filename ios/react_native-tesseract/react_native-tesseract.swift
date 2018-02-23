import Foundation
@objc(RNTesseract)
class RNTesseract: NSObject, G8TesseractDelegate {
    //Demonstrate a basic promise-based function in swift
    static var cachedImage:UIImage?
    var tesseract:G8Tesseract?
    var language:String = "eng"
    @objc func setLanguage(_ newLanguage: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard language != newLanguage else { resolve(true); return }
        language = newLanguage
        tesseract = nil
        resolve(true)
    }
    var dataPath: String?
    @objc func setDataPath(_ newPath: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard newPath != dataPath else { resolve(true); return }
        dataPath = newPath;
        tesseract = nil
        let fm = FileManager.default
        let tessPath = newPath + "/tessdata"
        
        guard fm.fileExists(atPath: dataPath) else {reject("data path does not exist", nil, nil); return }
        let url = URL.init(fileURLWithPath: tessPath)
        if !fm.fileExists(atPath: tessPath) { fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)}
        resolve(tessPath)
    }
    var engineMode:G8OCREngineMode = .tesseractOnly
    @objc func setFastMode(_ newFast:Bool, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let newmode:G8OCREngineMode = newFast ? .tesseractOnly : .tesseractCubeCombined
        if newmode != engineMode {
            engineMode = newmode
            tesseract = nil
        }
    }
    func getTesseract() -> G8Tesseract? {
        if let t = tesseract {
            return t
        } else {
            var t: G8Tesseract?
            if let _ = dataPath {
                t = G8Tesseract(language: language, configDictionary: [:], configFileNames: [], absoluteDataPath: dataPath, engineMode: engineMode, copyFilesFromResources: false)
            } else {
                t = G8Tesseract(language: language, engineMode: engineMode)
            }
            guard let tt = t else { return nil }
            tt.delegate = self
            tesseract = tt
            return tt
        }
    }
    func confirmDataInDataPath(language: String) -> Bool {
        //check for tessdata under datapath
        guard let dp = dataPath else { return true }
        let ss = language.split(separator: "+")
        var isOK = true
        let fm = FileManager.default
        let tessPath = dataPath + "/tessdata"
        
        ss.forEach() { s in
            guard isOK else { return }
            let thisPath = tessPath + "/" + s + ".traineddata"
            if fm.fileExists(atPath: thisPath) { isOK = false}
        }
        return isOK
    }
    func recognizeImage(_ image:UIImage, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let x = getTesseract() else { reject("No tesseract initialized", nil, nil) ; return }
        x.image = image
        DispatchQueue(label: "tesseract").async() {
            if x.recognize() {
                let text = x.recognizedText
                resolve(text)
            } else {
                reject("Recognize returned false", nil, nil)
            }
        }
    }
    @objc func recognizeCachedImage(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let i = RNTesseract.cachedImage else { reject("No cached image", nil, nil); return }
        recognizeImage(i, resolve: resolve, reject: reject)
    }
    @objc func recognizeFile(_ path:String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let image = UIImage(contentsOfFile: path) else { reject ("Could not open image file: " + path, nil, nil); return }
        recognizeImage(image, resolve: resolve, reject: reject)
    }
    class func requiresMainQueueSetup() -> Bool {
        return false;
    }
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
}
