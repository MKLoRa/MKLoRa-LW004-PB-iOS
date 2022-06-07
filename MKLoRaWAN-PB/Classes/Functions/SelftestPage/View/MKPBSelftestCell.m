//
//  MKPBSelftestCell.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBSelftestCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"

@implementation MKPBSelftestCellModel
@end

@interface MKPBSelftestCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *valueLabel0;

@property (nonatomic, strong)UILabel *valueLabel1;

@property (nonatomic, strong)UILabel *valueLabel2;

@property (nonatomic, strong)UILabel *valueLabel3;

@property (nonatomic, strong)UILabel *valueLabel4;

@property (nonatomic, strong)UILabel *valueLabel5;

@property (nonatomic, strong)UILabel *valueLabel6;

@property (nonatomic, strong)UILabel *valueLabel7;

@end

@implementation MKPBSelftestCell

+ (MKPBSelftestCell *)initCellWithTableView:(UITableView *)tableView {
    MKPBSelftestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPBSelftestCellIdenty"];
    if (!cell) {
        cell = [[MKPBSelftestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKPBSelftestCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.valueLabel0];
        [self.contentView addSubview:self.valueLabel1];
        [self.contentView addSubview:self.valueLabel2];
        [self.contentView addSubview:self.valueLabel3];
        [self.contentView addSubview:self.valueLabel4];
        [self.contentView addSubview:self.valueLabel5];
        [self.contentView addSubview:self.valueLabel6];
        [self.contentView addSubview:self.valueLabel7];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.valueLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    CGFloat labelWidth = (self.contentView.frame.size.width - 8 * 15.f) / 7;
    [self.valueLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(labelWidth);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel1.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(labelWidth);
        make.centerY.mas_equalTo(self.valueLabel1.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel2.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(labelWidth);
        make.centerY.mas_equalTo(self.valueLabel1.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel3.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(labelWidth);
        make.centerY.mas_equalTo(self.valueLabel1.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel4.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(labelWidth);
        make.centerY.mas_equalTo(self.valueLabel1.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel5.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(labelWidth);
        make.centerY.mas_equalTo(self.valueLabel1.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel6.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(labelWidth);
        make.centerY.mas_equalTo(self.valueLabel1.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKPBSelftestCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKPBSelftestCellModel.class]) {
        return;
    }
    self.valueLabel0.text = SafeStr(_dataModel.value0);
    self.valueLabel1.text = SafeStr(_dataModel.value1);
    self.valueLabel2.text = SafeStr(_dataModel.value2);
    self.valueLabel3.text = SafeStr(_dataModel.value3);
    self.valueLabel4.text = SafeStr(_dataModel.value4);
    self.valueLabel5.text = SafeStr(_dataModel.value5);
    self.valueLabel6.text = SafeStr(_dataModel.value6);
    self.valueLabel7.text = SafeStr(_dataModel.value7);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Selftest Status:";
    }
    return _msgLabel;
}

- (UILabel *)valueLabel0 {
    if (!_valueLabel0) {
        _valueLabel0 = [self fetchValueLabel];
    }
    return _valueLabel0;
}

- (UILabel *)valueLabel1 {
    if (!_valueLabel1) {
        _valueLabel1 = [self fetchValueLabel];
    }
    return _valueLabel1;
}

- (UILabel *)valueLabel2 {
    if (!_valueLabel2) {
        _valueLabel2 = [self fetchValueLabel];
    }
    return _valueLabel2;
}

- (UILabel *)valueLabel3 {
    if (!_valueLabel3) {
        _valueLabel3 = [self fetchValueLabel];
    }
    return _valueLabel3;
}

- (UILabel *)valueLabel4 {
    if (!_valueLabel4) {
        _valueLabel4 = [self fetchValueLabel];
    }
    return _valueLabel4;
}

- (UILabel *)valueLabel5 {
    if (!_valueLabel5) {
        _valueLabel5 = [self fetchValueLabel];
    }
    return _valueLabel5;
}

- (UILabel *)valueLabel6 {
    if (!_valueLabel6) {
        _valueLabel6 = [self fetchValueLabel];
    }
    return _valueLabel6;
}

- (UILabel *)valueLabel7 {
    if (!_valueLabel7) {
        _valueLabel7 = [self fetchValueLabel];
    }
    return _valueLabel7;
}

- (UILabel *)fetchValueLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = MKFont(13.f);
    return label;
}

@end
