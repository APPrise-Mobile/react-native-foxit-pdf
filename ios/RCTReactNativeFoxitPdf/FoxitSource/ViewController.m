/**
 * Copyright (C) 2003-2017, Foxit Software Inc..
 * All Rights Reserved.
 *
 * http://www.foxitsoftware.com
 *
 * The following code is copyrighted and is the proprietary of Foxit Software Inc.. It is not allowed to
 * distribute any parts of Foxit Mobile PDF SDK to third party or public without permission unless an agreement
 * is signed between Foxit Software Inc. and customers to explicitly grant customers permissions.
 * Review legal.txt for additional license and legal information.
 */

#import "ViewController.h"
#import "RCTReactNativeFoxitPdf.h"
#import "DocumentModule.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navController = [[UINavigationController alloc] init];
    self.navController.navigationBarHidden = YES;
    self.navController.view.frame = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIViewController* fileListViewController = [[UIViewController alloc] init];
    self.docModule = [[DocumentModule alloc] init];
    [fileListViewController.view addSubview:[self.docModule getTopToolbar]];
    [fileListViewController.view addSubview:[self.docModule getContentView]];
    [self.navController pushViewController:fileListViewController animated:NO];
    [self addChildViewController:self.navController];
    [self.view addSubview:self.navController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - rotate event

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ![ReactNativeFoxitPdf isScreenLocked];
}

- (BOOL)shouldAutorotate
{
    return ![ReactNativeFoxitPdf isScreenLocked];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    FSPDFViewCtrl *pdfViewCtrl = [ReactNativeFoxitPdf getPdfViewCtrl];
    ReadFrame *readFrame = [ReactNativeFoxitPdf getReadFrame];
    [pdfViewCtrl willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [readFrame willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    FSPDFViewCtrl *pdfViewCtrl = [ReactNativeFoxitPdf getPdfViewCtrl];
    [pdfViewCtrl willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    FSPDFViewCtrl *pdfViewCtrl = [ReactNativeFoxitPdf getPdfViewCtrl];
    ReadFrame *readFrame = [ReactNativeFoxitPdf getReadFrame];
    [pdfViewCtrl didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [readFrame didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
