//
//  MKPBExitAlarmTypeCell.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBExitAlarmTypeCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@implementation MKPBExitAlarmTypeCellModel
@end

@interface MKPBExitAlarmTypeCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *pressLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@end

@implementation MKPBExitAlarmTypeCell

+ (MKPBExitAlarmTypeCell *)initCellWithTableView:(UITableView *)tableView {
    MKPBExitAlarmTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPBExitAlarmTypeCellIdenty"];
    if (!cell) {
        cell = [[MKPBExitAlarmTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKPBExitAlarmTypeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.pressLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.unitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.pressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.textField.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.pressLabel.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKPBExitAlarmTypeCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKPBExitAlarmTypeCellModel.class]) {
        return;
    }
    self.textField.text = SafeStr(_dataModel.pressTime);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Exit Alarm Type";
    }
    return _msgLabel;
}

- (UILabel *)pressLabel {
    if (!_pressLabel) {
        _pressLabel = [[UILabel alloc] init];
        _pressLabel.textColor = DEFAULT_TEXT_COLOR;
        _pressLabel.textAlignment = NSTextAlignmentRight;
        _pressLabel.font = MKFont(13.f);
        _pressLabel.text = @"Long press";
    }
    return _pressLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@"5~15"
                                                             textType:mk_realNumberOnly];
        _textField.maxLength = 2;
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(pb_exitAlarmTypeTimeValueChanged:value:)]) {
                [self.delegate pb_exitAlarmTypeTimeValueChanged:self.dataModel.index value:text];
            }
        };
    }
    return _textField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.font = MKFont(12.f);
        _unitLabel.text = @"s";
    }
    return _unitLabel;
}

@end
