//
//  MKIoTCloudExitAccountAlert.m
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKIoTCloudExitAccountAlert.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"


static CGFloat const alertViewHeight = 150.f;

@interface MKIoTCloudExitAccountAlert ()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *accountLabel;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *exitButton;

@property (nonatomic, copy)void (^exitAction)(void);

@end

@implementation MKIoTCloudExitAccountAlert

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBACOLOR(0, 0, 0, 0.6)];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.accountLabel];
        [self.alertView addSubview:self.horizontalLine];
        [self.alertView addSubview:self.verticalLine];
        [self.alertView addSubview:self.cancelButton];
        [self.alertView addSubview:self.exitButton];
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
    [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
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
    [self.exitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
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

- (void)exitButtonPressed {
    if (self.exitAction) {
        self.exitAction();
    }
    [self dismiss];
}

#pragma mark - public method
- (void)showWithAccount:(NSString *)account completeBlock:(void(^)(void))completeBlock {
    [kAppWindow addSubview:self];
    self.exitAction = nil;
    self.exitAction = completeBlock;
    self.accountLabel.text = account;
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

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = DEFAULT_TEXT_COLOR;
        _accountLabel.font = MKFont(15.f);
        _accountLabel.textAlignment = NSTextAlignmentLeft;
        _accountLabel.numberOfLines = 0;
    }
    return _accountLabel;
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

- (UIButton *)exitButton{
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitButton.titleLabel setFont:MKFont(18.f)];
        [_exitButton setTitleColor:UIColorFromRGB(0x0188cc) forState:UIControlStateNormal];
        [_exitButton setTitle:@"Exit" forState:UIControlStateNormal];
        [_exitButton addTapAction:self selector:@selector(exitButtonPressed)];
    }
    return _exitButton;
}

@end
