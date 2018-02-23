import { NativeModules } from "react-native";
const RNTesseract = NativeModules.RNTesseract;
async function setLanguage(language) {
  if (typeof language == "array") {
    language = language.join("+");
  }
  return await RNTesseract.setLanguage(language);
}
async function setDataPath(dataPath) {
  return await RNTesseract.setDataPath(dataPath);
}
async function setFastMode(isFast) {
  return await RNTesseract.setFastMode(isFast);
}
async function recognizeCachedImage() {
  return await RNTesseract.recognizeCachedImage();
}
async function recognizeFile(filePath) {
  return await RNTesseract.recognizeFile(file);
}

export default {
  setLanguage,
  setDataPath,
  setFastMode,
  recognizeCachedImage,
  recognizeFile
};
