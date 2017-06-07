#import "RCTReactNativeFoxitPdf.h"
#import "FoxitRDK/FSPDFViewControl.h"

@implementation ReactNativeFoxitPdf

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(openPdf:(NSString *)path
                 documentTitle:(NSString *)documentTitle
                 options:(NSDictionary *)options
                 callback:(RCTResponseSenderBlock)callback)
{
	// Initialize a PDFDoc object with the path to the PDF file
	FSPDFDoc* pdfDoc = [FSPDFDoc createFromFilePath:path];
	if (nil == pdfDoc) {
		callback(@[[NSNull null], @"invalid_path"]);
		return;
	}

    if(e_errSuccess != [pdfDoc load:nil]) {
        return;
    }

	// Initialize a FSPDFViewCtrl object with the size of the entire screen
	FSPDFViewCtrl* pdfViewCtrl;
	pdfViewCtrl = [[FSPDFViewCtrl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

	// Set the document to display
	[pdfViewCtrl setDoc:pdfDoc];
//    UINavigationController* navigationController = [[UINavigationController alloc] init];
//    navigationController.navigationBarHidden = YES;
//    navigationController.view.frame = [[UIScreen mainScreen] bounds];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                        selector:@selector(didDismissDocumentController:)
//                                        name:@"DocumentControllerDismissed"
//                                        object:nil];

//  dispatch_async(dispatch_get_main_queue(), ^{
//    [navigationController pushViewController:pdfViewController animated:YES];
    @try {
      UIViewController* pdfViewController = [[UIViewController alloc] init];
      pdfViewController.view = pdfViewCtrl;
      pdfViewController.automaticallyAdjustsScrollViewInsets = NO;
      UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
      UIViewController *rootViewController = keyWindow.rootViewController;
      [rootViewController presentViewController:pdfViewController animated:YES completion: nil];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
//  });
}

//-(void)didDismissDocumentController:(NSNotification *)notification {
//  [[NSNotificationCenter defaultCenter] removeObserver:self];
//  NSDictionary* saveResults = [notification object];
//  [self.bridge.eventDispatcher sendAppEventWithName:@"PdfSaved"
//                               body:saveResults];
//}

@end
