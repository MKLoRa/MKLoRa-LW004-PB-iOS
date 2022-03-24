//
//  MKPBFilterBeaconCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKPBFilterBeaconCellDelegate <NSObject>

- (void)mk_pb_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_pb_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKPBFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKPBFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKPBFilterBeaconCellDelegate>delegate;

+ (MKPBFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
