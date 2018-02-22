#import <React/RCTBridgeModule.h>
@interface RCT_EXTERN_MODULE(RNTesseract, NSObject)
RCT_EXTERN_METHOD(recognizeFile:(NSString *)path resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject);
@end