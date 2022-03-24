//
//  MKPBBleTxPowerCell.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/10/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBBleTxPowerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"
#import "MKSlider.h"

@implementation MKPBBleTxPowerCellModel
@end

@interface MKPBBleTxPowerCell ()

@property (nonatomic, strong)UILabel *txPowerMsgLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@end

@implementation MKPBBleTxPowerCell

+ (MKPBBleTxPowerCell *)initCellWithTableView:(UITableView *)tableView {
    MKPBBleTxPowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPBBleTxPowerCellIdenty"];
    if (!cell) {
        cell = [[MKPBBleTxPowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKPBBleTxPowerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.txPowerMsgLabel];
        [self.contentView addSubview:self.txPowerSlider];
        [self.contentView addSubview:self.txPowerValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.txPowerMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerMsgLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)txPowerSliderValueChanged {
    self.txPowerValueLabel.text = [self txPowerValueText:self.txPowerSlider.value];
    if ([self.delegate respondsToSelector:@selector(mk_pb_txPowerValueChanged:)]) {
        [self.delegate mk_pb_txPowerValueChanged:(NSInteger)self.txPowerSlider.value];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKPBBleTxPowerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKPBBleTxPowerCellModel.class]) {
        return;
    }
    self.txPowerSlider.value = _dataModel.txPower;
    self.txPowerValueLabel.text = [self txPowerValueText:_dataModel.txPower];
}

#pragma mark - private method
- (NSString *)txPowerValueText:(float)sliderValue{
    if (sliderValue >=0 && sliderValue < 1) {
        return @"-40dBm";
    }
    if (sliderValue >= 1 && sliderValue < 2){
        return @"-20dBm";
    }
    if (sliderValue >= 2 && sliderValue < 3){
        return @"-16dBm";
    }
    if (sliderValue >= 3 && sliderValue < 4){
        return @"-12dBm";
    }
    if (sliderValue >= 4 && sliderValue < 5){
        return @"-8dBm";
    }
    if (sliderValue >= 5 && sliderValue < 6){
        return @"-4dBm";
    }
    if (sliderValue >= 6 && sliderValue < 7){
        return @"0dBm";
    }
    if (sliderValue >= 7 && sliderValue < 8) {
        return @"3dBm";
    }
    return @"4dBm";
}

#pragma mark - getter
- (UILabel *)txPowerMsgLabel {
    if (!_txPowerMsgLabel) {
        _txPowerMsgLabel = [[UILabel alloc] init];
        _txPowerMsgLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerMsgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Tx Power",@"   (-40,-20,-16,-12,-8,-4,0,+3,+4)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _txPowerMsgLabel;
}

- (MKSlider *)txPowerSlider {
    if (!_txPowerSlider) {
        _txPowerSlider = [[MKSlider alloc] init];
        _txPowerSlider.maximumValue = 9.f;
        _txPowerSlider.minimumValue = 0.f;
        _txPowerSlider.value = 0.f;
        [_txPowerSlider addTarget:self
                           action:@selector(txPowerSliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _txPowerSlider;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [[UILabel alloc] init];
        _txPowerValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerValueLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerValueLabel.font = MKFont(11.f);
        _txPowerValueLabel.text = @"-12dBm";
    }
    return _txPowerValueLabel;
}

@end
