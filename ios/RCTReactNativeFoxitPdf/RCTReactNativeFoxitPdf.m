#import "RCTReactNativeFoxitPdf.h"
#import <FoxitRDK/FSPDFViewControl.h>

static FSPDFViewCtrl* pdfViewCtrl = nil;
static ReadFrame* readFrame = nil;
static NSString* filePath = nil;
static NSString* password = nil;
static BOOL isScreenLocked = FALSE;
static BOOL isFiledEdited = FALSE;

@implementation ReactNativeFoxitPdf

+ (FSPDFViewCtrl*)getPdfViewCtrl {
    return pdfViewCtrl;
}

+ (void)setPdfViewCtrl:(FSPDFViewCtrl*)newPdfViewCtrl {
    if(pdfViewCtrl != newPdfViewCtrl) {
        pdfViewCtrl = newPdfViewCtrl;
    }
}

+ (ReadFrame*)getReadFrame {
    return readFrame;
}

+ (void)setReadFrame:(ReadFrame*)newReadFrame {
    if(readFrame != newReadFrame) {
        readFrame = newReadFrame;
    }
}

+ (NSString*)getFilePath {
    return filePath;
}
+ (void)setFilePath:(NSString*)newFilePath {
    if(filePath != newFilePath) {
        filePath = newFilePath;
    }
}

+ (NSString*)getPassword {
    return password;
}
+ (void)setPassword:(NSString*)newPassword {
    if(password != newPassword) {
        password = newPassword;
    }
}

+ (BOOL)isScreenLocked {
    return isScreenLocked;
}

+ (void)setIsScreenLocked:(BOOL)newIsScreenLocked {
    if(isScreenLocked != newIsScreenLocked) {
        isScreenLocked = newIsScreenLocked;
    }
}

+ (BOOL)isFileEdited {
    return isFiledEdited;
}

+ (void)setIsFileEdited:(BOOL)newIsFileEdited {
    if(isFiledEdited != newIsFileEdited) {
        isFiledEdited = newIsFileEdited;
    }
}

+ (void)close {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootViewController = keyWindow.rootViewController;
    [rootViewController dismissViewControllerAnimated:TRUE completion:nil];
}

+ (BOOL)openPDFAtPath:(NSString*)path withPassword:(NSString*)password
{
    FSPDFDoc* pdfDoc = [FSPDFDoc createFromFilePath:path];
    if (nil == pdfDoc) {
        return NO;
    }
    [ReactNativeFoxitPdf setFilePath:nil];
    [ReactNativeFoxitPdf setPassword:nil];

    ReadFrame *readFrame = [ReactNativeFoxitPdf getReadFrame];
    [readFrame.passwordModule tryLoadPDFDocument:pdfDoc guessPassword:password success:^(NSString *password) {
        [ReactNativeFoxitPdf setFilePath:path];
        [ReactNativeFoxitPdf setPassword:password];
        FSPDFViewCtrl* pdfViewCtrl = [ReactNativeFoxitPdf getPdfViewCtrl];
        [pdfViewCtrl setDoc:pdfDoc];

        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = keyWindow.rootViewController;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController* pdfViewController = [[UIViewController alloc] init];
            pdfViewController.view = pdfViewCtrl;
            pdfViewController.automaticallyAdjustsScrollViewInsets = NO;
            [rootViewController presentViewController:pdfViewController animated:YES completion: nil];
        });
    } error:^(NSString* description) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"kFailOpenFile", nil), [path lastPathComponent]]
                                                        message:description
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"kOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    } abort:^{
        FSPDFViewCtrl* pdfViewCtrl = [ReactNativeFoxitPdf getPdfViewCtrl];
        [pdfViewCtrl closeDoc:nil];
    }];

    return YES;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(init:(NSString *)serial
                 key:(NSString *)key
                 callback:(RCTResponseSenderBlock)callback)
{
    enum FS_ERRORCODE eRet = [FSLibrary init:serial key:key];
    if (e_errSuccess != eRet) {
      callback(@[[NSNull null], @"FoxitPdf: Invalid license"]);
    } else {
      callback(@[[NSNull null], @"FoxitPdf: init success"]);
    }
}

RCT_EXPORT_METHOD(openPdf:(NSString *)path
                 options:(NSDictionary *)options
                 callback:(RCTResponseSenderBlock)callback)
{
    FSPDFViewCtrl *pdfViewCtrl = [[FSPDFViewCtrl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ReactNativeFoxitPdf setPdfViewCtrl:pdfViewCtrl];

    ReadFrame *readFrame = [[ReadFrame alloc] initWithPdfViewCtrl:pdfViewCtrl options:options];
    [ReactNativeFoxitPdf setReadFrame:readFrame];
    [ReactNativeFoxitPdf openPDFAtPath:path withPassword:nil];
}

-(void)didDismissDocumentController:(NSNotification *)notification {
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 NSDictionary* saveResults = [notification object];
 [self.bridge.eventDispatcher sendAppEventWithName:@"PdfClosed"
                              body:saveResults];
}

@end
