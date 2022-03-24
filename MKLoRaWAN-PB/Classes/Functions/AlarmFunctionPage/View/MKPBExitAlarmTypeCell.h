//
//  MKPBExitAlarmTypeCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBExitAlarmTypeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *pressTime;

@end

@protocol MKPBExitAlarmTypeCellDelegate <NSObject>

- (void)pb_exitAlarmTypeTimeValueChanged:(NSInteger)index value:(NSString *)value;

@end

@interface MKPBExitAlarmTypeCell : MKBaseCell

@property (nonatomic, strong)MKPBExitAlarmTypeCellModel *dataModel;

@property (nonatomic, weak)id <MKPBExitAlarmTypeCellDelegate>delegate;

+ (MKPBExitAlarmTypeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
