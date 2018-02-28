import Foundation
@objc(RNTesseract)
class RNTesseract: NSObject, G8TesseractDelegate {
    //Demonstrate a basic promise-based function in swift
    static var cachedImage:UIImage?
    var tesseract:G8Tesseract?
    var language:String = "eng"
    var recognizing:Bool = false
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
        let tessPath = newPath
        let url = URL(fileURLWithPath: tessPath)
        if !fm.fileExists(atPath: tessPath) {
            guard let _ = try? fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil) else {
                print("Failed to create subdirectory")
                reject("no_path", "Could not create subdirectory", nil)
                return
            }
        }
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
            guard confirmDataInDataPath(language: language) else { return nil }
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
        guard let dp = tessDataPath() else { return true }
        let ss = language.split(separator: "+")
        var isOK = true
        let fm = FileManager.default
        ss.forEach() { s in
            guard isOK else { return }
            let thisPath = dp + "/" + s + ".traineddata"
            if !fm.fileExists(atPath: thisPath) { isOK = false }
        }
        return isOK
    }
    func tessDataPath() -> String? {
        guard let dp = dataPath else { return nil }
        return dp //+ "/tessdata"
    }
    var isGrayscale:Bool = false
    @objc func setGrayscale(_ toValue:Bool, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        isGrayscale = toValue
    }
    var charWhitelist:String?
    @objc func setCharWhitelist(_ toValue:String, resolve: RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if toValue.count > 0 {
            charWhitelist = toValue
        } else {
            charWhitelist = nil
        }
    }
    var charBlacklist:String?
    @objc func setCharBlacklist(_ toValue:String, resolve: RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if toValue.count > 0 {
            charBlacklist = toValue
        } else {
            charBlacklist = nil
        }
    }
    var waitSeconds:Int = 10
    @objc func setWaitSeconds(_ toValue:Int, resolve: RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if toValue > 0 {
            waitSeconds = toValue
        } else {
            waitSeconds = 10
        }
    }
    @objc func getTessDataPath(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let tdp = tessDataPath() else { reject("no_path", "No writeable path", nil); return}
        resolve(tdp)
    }
    func recognizeImage(_ image:UIImage, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard !recognizing else { reject("isrunning", "Already running recognizer", nil); return}
        DispatchQueue(label: "tesseract").async() {
            guard let x = self.getTesseract() else { reject("no_tesseract", "No tesseract initialized", nil) ; return }
            if let y = self.charBlacklist { x.charBlacklist = y }
            if let y = self.charWhitelist { x.charWhitelist = y }
            if let y = self.waitSeconds { x.maximumRecognitionTime = y }
           
            if self.isGrayscale {
                x.image = image .g8_grayScale()
            }
            self.recognizing = true
            if x.recognize() {
                let text = x.recognizedText
                resolve(text)
            } else {
                reject("tesseract_failed", "Recognize returned false", nil)
            }
            self.recognizing = false;
        }
    }
    @objc func recognizeCachedImage(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let i = RNTesseract.cachedImage else { reject("no_image", "No cached image", nil); return }
        recognizeImage(i, resolve: resolve, reject: reject)
    }
    @objc func recognizeFile(_ path:String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let image = UIImage(contentsOfFile: path) else { reject ("no_image", "Could not open image file: " + path, nil); return }
        recognizeImage(image, resolve: resolve, reject: reject)
    }
    @objc func recognizeURL(_ urlString: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let url = URL(string: urlString) else { reject("no_image", "Invalid URL",nil); return}
        let path = url.path
        recognizeFile(path, resolve: resolve, reject: reject)
    }
    @objc class func requiresMainQueueSetup() -> Bool {
        return false;
    }
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    @objc func clearCachedImage(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        RNTesseract.cachedImage = nil
    }
}
