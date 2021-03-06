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

#import "SignatureModule.h"
#import "UIExtensionsSharedHeader.h"
#import "Utility+Demo.h"

@interface SignatureModule ()
@property (nonatomic, strong) TbBaseItem *signItem;

@property (nonatomic, strong) SignToolHandler *toolHandler;
@property (nonatomic, strong) UIView *topToolBar;
@property (nonatomic, strong) UIView *bottomToolBar;
@property (nonatomic, assign) int oldState;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) TbBaseItem* listItem;
@end

@implementation SignatureModule{
    FSPDFViewCtrl* __weak _pdfViewCtrl;
    UIExtensionsManager* __weak _extensionsManager;
    ReadFrame* __weak _readFrame;
}

- (instancetype)initWithUIExtensionsManager:(UIExtensionsManager*)extensionsManager readFrame:(ReadFrame*)readFrame
{
    self = [super init];
    if (self) {
        _extensionsManager = extensionsManager;
        _pdfViewCtrl = extensionsManager.pdfViewCtrl;
        _readFrame = readFrame;
        [self loadModule];
    }
    return self;
}

-(void)loadModule
{
    [self initToolBar];
    self.toolHandler = (SignToolHandler *)[_extensionsManager getToolHandlerByName:Tool_Signature];
    [_extensionsManager registerToolEventListener:self];
    [_readFrame registerStateChangeListener:self];
    _readFrame.signatureItem.onTapClick = ^(TbBaseItem *item) {
        if (_extensionsManager.currentAnnot) {
            [_extensionsManager setCurrentAnnot:nil];
        }
        [_extensionsManager setCurrentToolHandler:self.toolHandler];
        [self.toolHandler openCreateSign];
    };
}

- (void)initToolBar
{
    UIView *superView = _pdfViewCtrl;
    _topToolBar = [[UIView alloc] init];
    _topToolBar.backgroundColor = [UIColor colorWithRGBHex:0xF2FAFAFA];

    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setImage:[UIImage imageNamed:@"common_back_black"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelSignature) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBar addSubview:_cancelBtn];

    TbBaseItem *titleItem = [TbBaseItem createItemWithTitle:NSLocalizedString(@"kSignatureTitle", nil)];
    titleItem.textColor = [UIColor colorWithRGBHex:0x3F3F3F];
    [_topToolBar addSubview:titleItem.contentView];
    CGSize size = titleItem.contentView.frame.size;
    [titleItem.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_topToolBar.mas_centerX);
        make.centerY.mas_equalTo(_topToolBar.mas_centerY).offset(10);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];

    UIView *divideView = [[UIView alloc] init];
    divideView.backgroundColor = [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1];
    [_topToolBar addSubview:divideView];
    [divideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(divideView.superview.mas_left);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(divideView.superview.mas_bottom);
        make.right.mas_equalTo(divideView.superview.mas_right);
    }];

    _bottomToolBar = [[UIView alloc] init];
    _bottomToolBar.backgroundColor = [UIColor colorWithRGBHex:0xF2FAFAFA];
    _listItem = [TbBaseItem createItemWithImageAndTitle:NSLocalizedString(@"ksignListIconTitle", nil) imageNormal:[UIImage imageNamed:@"sign_list"] imageSelected:[UIImage imageNamed:@"sign_list"] imageDisable:[UIImage imageNamed:@"sign_list"] background:nil imageTextRelation:RELATION_BOTTOM];
    _listItem.textColor = [UIColor blackColor];
    _listItem.textFont = [UIFont systemFontOfSize:12.f];

    __weak SignatureModule* weakSelf = self;
    _listItem.onTapClick =  ^(TbBaseItem* item)
    {
        [weakSelf.toolHandler delete];
        [weakSelf.toolHandler signList];
    };

    [_bottomToolBar addSubview:_listItem.contentView];

    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(26);
        make.left.mas_equalTo(_cancelBtn.superview.mas_left).offset(10);
        make.centerY.mas_equalTo(_cancelBtn.superview.mas_centerY).offset(10);
    }];

    float width = _listItem.contentView.frame.size.width;
    float height = _listItem.contentView.frame.size.height;
    [_listItem.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.mas_equalTo(_listItem.contentView.superview.mas_centerY);
        make.centerX.mas_equalTo(_listItem.contentView.superview.mas_centerX).offset(0);
    }];

    UIView *divideView1 = [[UIView alloc] init];
    divideView1.backgroundColor = [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1];
    [_bottomToolBar addSubview:divideView1];
    [divideView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(divideView1.superview.mas_left);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(divideView1.superview.mas_top);
        make.right.mas_equalTo(divideView1.superview.mas_right);
    }];

    _topToolBar.hidden = YES;
    _bottomToolBar.hidden = YES;
    [superView addSubview:_topToolBar];
    [superView addSubview:_bottomToolBar];

    [_topToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topToolBar.superview.mas_top).offset(-64);
        make.left.mas_equalTo(_topToolBar.superview.mas_left);
        make.right.mas_equalTo(_topToolBar.superview.mas_right);
        make.height.mas_equalTo(64);
    }];

    [_bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bottomToolBar.superview.mas_bottom).offset(49);
        make.left.mas_equalTo(_bottomToolBar.superview.mas_left);
        make.right.mas_equalTo(_bottomToolBar.superview.mas_right);
        make.height.mas_equalTo(49);
    }];
}

- (void)cancelSignature
{
    [self.toolHandler delete];
    [_extensionsManager setCurrentToolHandler:nil];
    [_readFrame changeState:STATE_NORMAL];
}

- (void)setToolBarHiden:(BOOL)toolBarHiden
{

    if (toolBarHiden)
    {
        CGRect topToolbarFrame = _topToolBar.frame;
        topToolbarFrame.origin.y -= 64;
        CGRect bottomToolBarFrame = _bottomToolBar.frame;
        bottomToolBarFrame.origin.y += 49;
        [UIView animateWithDuration:0.3 animations:^{
            _topToolBar.frame = topToolbarFrame;
            _bottomToolBar.frame = bottomToolBarFrame;
            [_topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_topToolBar.superview.mas_top).offset(-64);
                make.left.mas_equalTo(_topToolBar.superview.mas_left);
                make.right.mas_equalTo(_topToolBar.superview.mas_right);
                make.height.mas_equalTo(64);
            }];

            [_bottomToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_bottomToolBar.superview.mas_bottom).offset(49);
                make.left.mas_equalTo(_bottomToolBar.superview.mas_left);
                make.right.mas_equalTo(_bottomToolBar.superview.mas_right);
                make.height.mas_equalTo(49);
            }];
        }];
        _topToolBar.hidden = YES;
        _bottomToolBar.hidden = YES;
    }
    else
    {
        _topToolBar.hidden = NO;
        _bottomToolBar.hidden = NO;
        CGRect topToolbarFrame = _topToolBar.frame;
        topToolbarFrame.origin.y += 64;
        CGRect bottomToolBarFrame = _bottomToolBar.frame;
        bottomToolBarFrame.origin.y -= 49;
        [UIView animateWithDuration:0.3 animations:^{
            _topToolBar.frame = topToolbarFrame;
            _bottomToolBar.frame = bottomToolBarFrame;
            [_topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_topToolBar.superview.mas_top);
                make.left.mas_equalTo(_topToolBar.superview.mas_left);
                make.right.mas_equalTo(_topToolBar.superview.mas_right);
                make.height.mas_equalTo(64);
            }];

            [_bottomToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_bottomToolBar.superview.mas_bottom);
                make.left.mas_equalTo(_bottomToolBar.superview.mas_left);
                make.right.mas_equalTo(_bottomToolBar.superview.mas_right);
                make.height.mas_equalTo(49);
            }];
        }];
    }
}

#pragma mark IHandlerEventListener

- (void)onToolChanged:(NSString*)lastToolName CurrentToolName:(NSString*)toolName
{
    if ([toolName isEqualToString:Tool_Signature]) {
        [self annotItemClicked];
    } else if ([lastToolName isEqualToString:Tool_Signature]) {
        [self setToolBarHiden:YES];
        if(toolName == nil)
        {
            [_readFrame changeState:STATE_NORMAL];
        }
    }
}

-(void)annotItemClicked
{
    [_readFrame.toolSetBar removeAllItems];
    [_readFrame changeState:STATE_SIGNATURE];
}

- (void)setToolBarItemHidden:(BOOL)toolBarItemHidden
{
    if (toolBarItemHidden && self.signItem) {
        [_readFrame.toolSetBar removeItem:self.signItem];
    } else {
        if (!self.signItem) {
            self.signItem = [TbBaseItem createItemWithImage:[UIImage imageNamed:@"sign_list"] imageSelected:[UIImage imageNamed:@"sign_list"] imageDisable:[UIImage imageNamed:@"sign_list"]background:[UIImage imageNamed:@"annotation_toolitembg"]];
            self.signItem.tag = 3;
            UIExtensionsManager* extensionsManager = _extensionsManager; // avoid strong-reference to self
            self.signItem.onTapClick = ^(TbBaseItem* item)
            {
                SignToolHandler* signToolHandler = (SignToolHandler*)[extensionsManager getToolHandlerByName:Tool_Signature];
                [signToolHandler signList];
            };
        }
        [_readFrame.toolSetBar addItem:self.signItem displayPosition:Position_CENTER];
    }
}

#pragma mark - IStateChangeListener

- (void)onStateChanged:(int)state
{
    if (state == STATE_SIGNATURE) {
        [self setToolBarHiden:NO];
    }else{
        [self setToolBarHiden:YES];
    }
}

@end
