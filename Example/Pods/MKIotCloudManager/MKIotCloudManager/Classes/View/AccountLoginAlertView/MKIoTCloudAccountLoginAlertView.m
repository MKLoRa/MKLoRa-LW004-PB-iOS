//
//  MKIoTCloudAccountLoginAlertView.m
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/3.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKIoTCloudAccountLoginAlertView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"

@implementation MKIoTCloudAccountLoginAlertViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.accountPlaceholder = @"Account";
        self.psdPlaceholder = @"Password";
        self.isHome = YES;
    }
    return self;
}

@end


static CGFloat const alertViewHeight = 230.f;

@interface MKIoTCloudAccountLoginEnvirBtn : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKIoTCloudAccountLoginEnvirBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-1.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(13.f);
    }
    return _msgLabel;
}

@end

@interface MKIoTCloudAccountLoginAlertView ()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)MKTextField *accountField;

@property (nonatomic, strong)MKTextField *psdField;

@property (nonatomic, strong)MKIoTCloudAccountLoginEnvirBtn *cloudBtn;

@property (nonatomic, strong)MKIoTCloudAccountLoginEnvirBtn *testBtn;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, copy)void (^confirmAction)(NSString *account, NSString *password, BOOL isHome);

@property (nonatomic, assign)NSInteger envType;

@end

@implementation MKIoTCloudAccountLoginAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBACOLOR(0, 0, 0, 0.6)];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.accountField];
        [self.alertView addSubview:self.psdField];
        [self.alertView addSubview:self.cloudBtn];
        [self.alertView addSubview:self.testBtn];
        [self.alertView addSubview:self.horizontalLine];
        [self.alertView addSubview:self.verticalLine];
        [self.alertView addSubview:self.cancelButton];
        [self.alertView addSubview:self.confirmButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).mas_offset(37.f);
        make.width.mas_equalTo(self.frame.size.width - 2 * 37.f);
        make.top.mas_equalTo(250.f);
        make.height.mas_equalTo(alertViewHeight);
    }];
    CGFloat width = self.frame.size.width - 2 * 37.f;
    CGSize titleSize = [NSString sizeWithText:self.titleLabel.text
                                      andFont:self.titleLabel.font
                                   andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(25.f);
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.accountField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.psdField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.accountField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.cloudBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.alertView.mas_centerX).mas_offset(-3.f);
        make.top.mas_equalTo(self.psdField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.testBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.alertView.mas_centerX).mas_offset(3.f);
        make.top.mas_equalTo(self.psdField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45.f);
        make.height.mas_equalTo(0.5f);
    }];
    [self.verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.width.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.verticalLine.mas_left);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.verticalLine.mas_right);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
}

#pragma mark - event method
- (void)cancelButtonPressed {
    [self dismiss];
}

- (void)confirmButtonPressed {
    if (self.confirmAction) {
        self.confirmAction(self.accountField.text,self.psdField.text,(self.envType == 0));
    }
    [self dismiss];
}

- (void)cloudBtnPressed {
    self.envType = 0;
    [self uploadEnvIcon];
}

- (void)testBtnPressed {
    self.envType = 1;
    [self uploadEnvIcon];
}

#pragma mark - public method
- (void)showViewWithModel:(MKIoTCloudAccountLoginAlertViewModel *)model
            completeBlock:(void(^)(NSString *account, NSString *password, BOOL isHome))completeBlock {
    [kAppWindow addSubview:self];
    self.confirmAction = nil;
    self.confirmAction = completeBlock;
    self.accountField.text = model.account;
    self.accountField.placeholder = model.accountPlaceholder;
    self.accountField.maxLength = model.accountMaxLen;
    self.psdField.text = model.password;
    self.psdField.placeholder = model.psdPlaceholder;
    self.psdField.maxLength = model.passwordMaxLen;
    self.envType = (model.isHome ? 0 : 1);
    [self uploadEnvIcon];
    [UIView animateWithDuration:.3f animations:^{
        self.alertView.transform = CGAffineTransformMakeTranslation(-kViewWidth, 0);
    }];
}

#pragma mark - private method
- (void)dismiss{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)uploadEnvIcon {
    self.cloudBtn.icon.image = ((self.envType == 0) ? LOADICON(@"MKIotCloudManager", @"MKIoTCloudAccountLoginAlertView", @"mk_envirnmentnSelectedIcon.png") : LOADICON(@"MKIotCloudManager", @"MKIoTCloudAccountLoginAlertView", @"mk_envirnmentnUnselectedIcon.png"));
    self.testBtn.icon.image = ((self.envType == 1) ? LOADICON(@"MKIotCloudManager", @"MKIoTCloudAccountLoginAlertView", @"mk_envirnmentnSelectedIcon.png") : LOADICON(@"MKIotCloudManager", @"MKIoTCloudAccountLoginAlertView", @"mk_envirnmentnUnselectedIcon.png"));
}

#pragma mark - getter
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        [_alertView setBackgroundColor:COLOR_WHITE_MACROS];
        [_alertView.layer setMasksToBounds:YES];
        [_alertView.layer setBorderColor:CUTTING_LINE_COLOR.CGColor];
        [_alertView.layer setBorderWidth:0.5f];
        [_alertView.layer setCornerRadius:5.f];
    }
    return _alertView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.font = MKFont(18.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"Login";
    }
    return _titleLabel;
}

- (MKTextField *)accountField {
    if (!_accountField) {
        _accountField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _accountField.placeholder = @"Account";
        _accountField.borderStyle = UITextBorderStyleNone;
        _accountField.font = MKFont(13.f);
        _accountField.textColor = DEFAULT_TEXT_COLOR;
        
        _accountField.backgroundColor = COLOR_WHITE_MACROS;
        _accountField.layer.masksToBounds = YES;
        _accountField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _accountField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _accountField.layer.cornerRadius = 6.f;
    }
    return _accountField;
}

- (MKTextField *)psdField {
    if (!_psdField) {
        _psdField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _psdField.placeholder = @"Password";
        _psdField.borderStyle = UITextBorderStyleNone;
        _psdField.font = MKFont(13.f);
        _psdField.textColor = DEFAULT_TEXT_COLOR;
        
        _psdField.backgroundColor = COLOR_WHITE_MACROS;
        _psdField.layer.masksToBounds = YES;
        _psdField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _psdField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _psdField.layer.cornerRadius = 6.f;
    }
    return _psdField;
}

- (MKIoTCloudAccountLoginEnvirBtn *)cloudBtn {
    if (!_cloudBtn) {
        _cloudBtn = [[MKIoTCloudAccountLoginEnvirBtn alloc] init];
        _cloudBtn.msgLabel.text = @"env_cloud";
        [_cloudBtn addTarget:self
                      action:@selector(cloudBtnPressed)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _cloudBtn;
}

- (MKIoTCloudAccountLoginEnvirBtn *)testBtn {
    if (!_testBtn) {
        _testBtn = [[MKIoTCloudAccountLoginEnvirBtn alloc] init];
        _testBtn.msgLabel.text = @"env_test";
        [_testBtn addTarget:self
                     action:@selector(testBtnPressed)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBtn;
}

- (UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
    }
    return _horizontalLine;
}

- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
    }
    return _verticalLine;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton.titleLabel setFont:MKFont(18.f)];
        [_cancelButton setTitleColor:UIColorFromRGB(0x0188cc) forState:UIControlStateNormal];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTapAction:self selector:@selector(cancelButtonPressed)];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton.titleLabel setFont:MKFont(18.f)];
        [_confirmButton setTitleColor:UIColorFromRGB(0x0188cc) forState:UIControlStateNormal];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton addTapAction:self selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

@end
