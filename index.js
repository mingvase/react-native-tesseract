import { NativeModules } from "react-native";
const RNTesseract = NativeModules.RNTesseract;
async function setLanguage(language) {
  if (typeof language == "array") {
    language = language.join("+");
  }
  return await RNTesseract.setLanguage(language);
}
async function setBaseDataPath(dataPath) {
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
async function recognizeURL(URL) {
  return await RNTesseract.recognizeURL(URL);
}
async function getTessDataPath() {
  return await RNTesseract.getTessDataPath();
}
function getFileNameForLanguage(language) {
  return language + ".traineddata";
}
function getURLForLanguage(language) {
  return (
    "https://github.com/tesseract-ocr/tessdata/blob/3.04.00/" +
    getFileNameForLanguage(language) +
    "?raw=true"
  );
}
function getLanguages(language) {
  return language.split("+");
}
function getURLsForLanguage(language) {
  return getURLsForLanguages(getLanguages(language));
}
function getURLsForLanguages(languages) {
  return languages.map(l => {
    return getURLForLanguage(l);
  });
}

export default {
  setLanguage,
  setBaseDataPath,
  setFastMode,
  recognizeCachedImage,
  recognizeFile,
  getTessDataPath,
  getFileNameForLanguage,
  getURLForLanguage,
  getURLsForLanguage,
  getURLsForLanguages,
  getLanguages,
  recognizeURL
};
