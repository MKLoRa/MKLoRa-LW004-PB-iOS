//
//  MKPBScanPageCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKPBScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)pb_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKPBScanPageModel;
@interface MKPBScanPageCell : MKBaseCell

@property (nonatomic, strong)MKPBScanPageModel *dataModel;

@property (nonatomic, weak)id <MKPBScanPageCellDelegate>delegate;

+ (MKPBScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
