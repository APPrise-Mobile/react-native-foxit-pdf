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

#import "MoreModule.h"
#import "FileInformationViewController.h"
#import "MenuGroup.h"
#import "MenuView.h"


@interface MoreModule ()

@property (nonatomic, strong) FSPDFDoc *document;

@property (nonatomic, weak) TbBaseItem *moreItem;
@property (nonatomic, assign) CGRect moreRect;
@property (nonatomic, strong) MenuView *moreMenu;


@property (nonatomic, strong) MenuGroup *othersGroup;
@property (nonatomic, strong) MvMenuItem *saveItem;
@property (nonatomic, strong) MvMenuItem *fileInfoItem;

@property (nonatomic, strong) NSObject *currentVC;
@property (nonatomic, strong) UIPopoverController *sharePopoverController;
@property (nonatomic, assign) BOOL haddismiss;


@property (nonatomic, strong) FSPDFViewCtrl *pdfViewCtrl;
@property (nonatomic, strong) ReadFrame *readFrame;
@end

@implementation MoreModule


-(instancetype)initWithViewCtrl:(FSPDFViewCtrl*)pdfViewCtrl readFrame:(ReadFrame*)readFrame
{
    self = [super init];
    if(self)
    {
        _pdfViewCtrl = pdfViewCtrl;
        _readFrame = (ReadFrame*)readFrame;
        [self loadModule];
    }
    return self;
}



-(void)loadModule
{
    [_readFrame registerRotateChangedListener:self];
    self.moreMenu = _readFrame.more;
    
    UIImage *itemImg = [UIImage imageNamed:@"common_read_more"];
   TbBaseItem *moreItem = [TbBaseItem createItemWithImage:itemImg imageSelected:itemImg imageDisable:itemImg];
    moreItem.tag = 1;
    [_readFrame.topToolbar addItem:moreItem displayPosition:Position_RB];
    moreItem.onTapClick = ^(TbBaseItem* item)
    {
        _readFrame.hiddenMoreMenu = NO;
    };
    self.moreItem = moreItem;
    self.moreRect = self.moreItem.contentView.frame;
    
    self.othersGroup = [self.moreMenu getGroup:TAG_GROUP_FILE];
    if (!self.othersGroup) {
        self.othersGroup = [[MenuGroup alloc] init];
        self.othersGroup.title = NSLocalizedString(@"kOtherDocumentsFile", nil);
        self.othersGroup.tag = TAG_GROUP_FILE;
        [self.moreMenu addGroup:self.othersGroup];
    }
    
    self.fileInfoItem = [[MvMenuItem alloc] init];
    self.fileInfoItem.tag = TAG_ITEM_FILEINFO;
    self.fileInfoItem.callBack = self;
    self.fileInfoItem.text = NSLocalizedString(@"kFileInformation", nil);
    [self.moreMenu addMenuItem:self.othersGroup.tag withItem:self.fileInfoItem];
    
}

-(void)onClick:(MvMenuItem *)item
{
    _readFrame.hiddenMoreMenu = YES;
    

    if (item.tag == TAG_ITEM_FILEINFO)
    {
        [self fileInfo];
    }
}

- (void)onDocWillOpen
{
    
}

- (void)onDocOpened:(FSPDFDoc*)document error:(int)error
{
    self.moreRect = self.moreItem.contentView.frame;
    self.haddismiss = NO;
}

- (void)onDocWillClose:(FSPDFDoc*)document
{
    if (self.currentVC) {
        if ([self.currentVC isKindOfClass:[UIViewController class]]) {
            [(UIViewController*)self.currentVC dismissViewControllerAnimated:NO completion:nil];
        }
        else if ([self.currentVC isKindOfClass:[UIDocumentInteractionController class]])
        {
            [(UIDocumentInteractionController *)self.currentVC dismissMenuAnimated:NO];
            [(UIDocumentInteractionController *)self.currentVC dismissPreviewAnimated:NO];
        }
        else if ([self.currentVC isKindOfClass:[UIPrintInteractionController class]])
        {
            [(UIPrintInteractionController *)self.currentVC dismissAnimated:NO];
        }
        else if([self.currentVC isKindOfClass:[AlertView class]])
        {
            [(AlertView *)self.currentVC dismissWithClickedButtonIndex:0 animated:NO];
        }
        self.currentVC = nil;
    }
}

- (void)onDocClosed:(FSPDFDoc*)document error:(int)error
{
    self.haddismiss = NO;
}

-(void)onDocWillSave:(FSPDFDoc *)document
{
    
}

- (void)fileInfo
{
    FileInformationViewController *fileInfoCtr = [[FileInformationViewController alloc] initWithNibName:nil bundle:nil];
    [fileInfoCtr setPdfViewCtrl:_pdfViewCtrl];
    self.currentVC = fileInfoCtr;
    UINavigationController *fileInfoNavCtr = [[UINavigationController alloc] initWithRootViewController:fileInfoCtr];
    fileInfoNavCtr.delegate = fileInfoCtr;
    fileInfoNavCtr.modalPresentationStyle = UIModalPresentationFormSheet;
    fileInfoNavCtr.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [_readFrame.pdfViewCtrl.window.rootViewController presentModalViewController:fileInfoNavCtr animated:YES];
}

#pragma mark rotation 

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.currentVC) {
        if ([self.currentVC isKindOfClass:[UIDocumentInteractionController class]])
        {
            [(UIDocumentInteractionController *)self.currentVC dismissMenuAnimated:NO];
            [(UIDocumentInteractionController *)self.currentVC dismissPreviewAnimated:NO];
        }
        else if ([self.currentVC isKindOfClass:[UIPrintInteractionController class]])
        {
            ((UIPrintInteractionController *)self.currentVC).printPageRenderer = nil;
            [(UIPrintInteractionController *)self.currentVC dismissAnimated:NO];
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.moreRect = self.moreItem.contentView.frame;
    if (self.currentVC && !self.haddismiss) {
        if ([self.currentVC isKindOfClass:[UIDocumentInteractionController class]])
        {

        }
    }
}

#pragma mark UIDocumentInteractionController delegate

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    self.haddismiss = YES;
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView * _Nonnull *)view
{
    *rect = self.moreRect;
}

@end
