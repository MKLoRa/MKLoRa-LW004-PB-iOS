//
//  MKPBPCBAStatusCell.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBPCBAStatusCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKPBPCBAStatusCellModel
@end

@interface MKPBPCBAStatusCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *valueLabel0;

@property (nonatomic, strong)UILabel *valueLabel1;

@property (nonatomic, strong)UILabel *valueLabel2;

@end

@implementation MKPBPCBAStatusCell

+ (MKPBPCBAStatusCell *)initCellWithTableView:(UITableView *)tableView {
    MKPBPCBAStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPBPCBAStatusCellIdenty"];
    if (!cell) {
        cell = [[MKPBPCBAStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKPBPCBAStatusCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.valueLabel0];
        [self.contentView addSubview:self.valueLabel1];
        [self.contentView addSubview:self.valueLabel2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.valueLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel0.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel1.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKPBPCBAStatusCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKPBPCBAStatusCellModel.class]) {
        return;
    }
    self.valueLabel0.text = SafeStr(_dataModel.value0);
    self.valueLabel1.text = SafeStr(_dataModel.value1);
    self.valueLabel2.text = SafeStr(_dataModel.value2);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"PCBA Status:";
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

- (UILabel *)fetchValueLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = MKFont(13.f);
    return label;
}

@end
