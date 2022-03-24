//
//  MKPBTimingModeAddCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBTimingModeAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKPBTimingModeAddCellDelegate <NSObject>

- (void)pb_addButtonPressed;

@end

@interface MKPBTimingModeAddCell : MKBaseCell

@property (nonatomic, strong)MKPBTimingModeAddCellModel *dataModel;

@property (nonatomic, weak)id <MKPBTimingModeAddCellDelegate>delegate;

+ (MKPBTimingModeAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
