import { NativeModules } from "react-native";
const RNTesseract = NativeModules.RNTesseract;
async function setLanguage(language) {
  if (typeof language == "array") {
    language = language.join("+");
  }
  return await RNTesseract.setLanguage(language);
}
async function setDataPath(dataPath) {
  var temp = dataPath;
  if (temp.endsWith("/")) temp = temp.subString(0, temp.length - 1);
  if (!temp.endsWith("/tessdata")) {
    throw new Error("data Path must end with tessdata");
  }
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
var thisWhitelist = null;
async function setCharWhitelist(whitelist) {
  if (typeof whitelist === "undefined" || whitelist === null) whitelist = "";
  if (typeof whitelist === "array") {
    whitelist = whitelist.join();
    thisWhitelist = whitelist;
    await RNTesseract.setCharWhitelist(whitelist);
    return true;
  }
}
function getCharWhitelist() {
  return thisWhitelist;
}
var thisBlacklist = null;
async function setCharBlacklist(blacklist) {
  if (typeof blacklist === "undefined" || blacklist === null) blacklist = "";
  if (typeof blacklist === "array") {
    blacklist = blacklist.join();
    thisBlacklist = blacklist;
    await RNTesseract.setCharBlacklist(blacklist);
    return true;
  }
}
function getCharBlacklist() {
  return thisBlacklist;
}
var isGrayscale = false;
async function setGrayscale(useGrayscale) {
  isGrayscale = useGrayscale;
  return await RNTesseract.setGrayscale(useGrayscale);
}
function getGrayscale() {
  return isGrayscale;
}
var secondsToWait = 10;
async function setWaitSeconds(newSecondsToWait) {
  if (newSecondsToWait < 0 || newSecondsToWait > 99) {
    throw new Error("wait seconds must be between 0 and 99");
  }
  secondsToWait = newSecondsToWait;
  return await RNTesseract.setWaitSeconds(newSecondsToWait);
}
function getWaitSeconds() {
  return secondsToWait;
}
export default {
  setLanguage,
  setDataPath,
  setFastMode,
  recognizeCachedImage,
  recognizeFile,
  getTessDataPath,
  getFileNameForLanguage,
  getURLForLanguage,
  getURLsForLanguage,
  getURLsForLanguages,
  getLanguages,
  recognizeURL,
  setCharBlacklist,
  setCharWhitelist,
  getCharBlacklist,
  getCharWhitelist,
  setGrayscale,
  getGrayscale,
  setWaitSeconds,
  getWaitSeconds,
  availableOrientations: RNTesseract.orientations
};
