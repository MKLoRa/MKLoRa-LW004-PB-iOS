//
//  MKPBFilterEditSectionHeaderView.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterEditSectionHeaderViewModel : NSObject

/// sectionHeader所在index
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)UIColor *contentColor;

@end

@protocol MKPBFilterEditSectionHeaderViewDelegate <NSObject>

/// 加号点击事件
/// @param index 所在index
- (void)mk_pb_filterEditSectionHeaderView_addButtonPressed:(NSInteger)index;

/// 减号点击事件
/// @param index 所在index
- (void)mk_pb_filterEditSectionHeaderView_subButtonPressed:(NSInteger)index;

@end

@interface MKPBFilterEditSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)MKPBFilterEditSectionHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKPBFilterEditSectionHeaderViewDelegate>delegate;

+ (MKPBFilterEditSectionHeaderView *)initHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
