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

RCT_EXPORT_METHOD(openPdf:(NSString *)path
                 documentTitle:(NSString *)documentTitle
                 options:(NSDictionary *)options
                 callback:(RCTResponseSenderBlock)callback)
{
	// Initialize a PDFDoc object with the path to the PDF file
//	FSPDFDoc* pdfDoc = [FSPDFDoc createFromFilePath:path];
//	if (nil == pdfDoc) {
//		callback(@[[NSNull null], @"invalid_path"]);
//		return;
//	}
//
//    if(e_errSuccess != [pdfDoc load:nil]) {
//        return;
//    }

	// Initialize a FSPDFViewCtrl object with the size of the entire screen
//	FSPDFViewCtrl* pdfViewCtrl;
//	pdfViewCtrl = [[FSPDFViewCtrl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

	// Set the document to display
//	[pdfViewCtrl setDoc:pdfDoc];
//    UINavigationController* navigationController = [[UINavigationController alloc] init];
//    navigationController.navigationBarHidden = YES;
//    navigationController.view.frame = [[UIScreen mainScreen] bounds];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                        selector:@selector(didDismissDocumentController:)
//                                        name:@"DocumentControllerDismissed"
//                                        object:nil];

//  dispatch_async(dispatch_get_main_queue(), ^{
//    [navigationController pushViewController:pdfViewController animated:YES];
//    @try {
//      UIViewController* pdfViewController = [[UIViewController alloc] init];
//      pdfViewController.view = pdfViewCtrl;
//      pdfViewController.automaticallyAdjustsScrollViewInsets = NO;
//      UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//      UIViewController *rootViewController = keyWindow.rootViewController;
//      [rootViewController presentViewController:pdfViewController animated:YES completion: nil];
//    } @catch (NSException *exception) {
//        NSLog(@"%@", exception.reason);
//    }
//  });
    FSPDFViewCtrl *pdfViewCtrl = [[FSPDFViewCtrl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ReactNativeFoxitPdf setPdfViewCtrl:pdfViewCtrl];

    ReadFrame *readFrame = [[ReadFrame alloc] initWithPdfViewCtrl:pdfViewCtrl];
    [ReactNativeFoxitPdf setReadFrame:readFrame];
    [ReactNativeFoxitPdf openPDFAtPath:path withPassword:nil];
}

//-(void)didDismissDocumentController:(NSNotification *)notification {
//  [[NSNotificationCenter defaultCenter] removeObserver:self];
//  NSDictionary* saveResults = [notification object];
//  [self.bridge.eventDispatcher sendAppEventWithName:@"PdfSaved"
//                               body:saveResults];
//}

@end
