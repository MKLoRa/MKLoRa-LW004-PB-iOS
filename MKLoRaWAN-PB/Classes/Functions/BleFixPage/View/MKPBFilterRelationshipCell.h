//
//  MKPBFilterRelationshipCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterRelationshipCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger dataListIndex;

@property (nonatomic, strong)NSArray *dataList;

@end

@protocol MKPBFilterRelationshipCellDelegate <NSObject>

- (void)pb_filterRelationshipChanged:(NSInteger)index dataListIndex:(NSInteger)dataListIndex;

@end

@interface MKPBFilterRelationshipCell : MKBaseCell

@property (nonatomic, strong)MKPBFilterRelationshipCellModel *dataModel;

@property (nonatomic, weak)id <MKPBFilterRelationshipCellDelegate>delegate;

+ (MKPBFilterRelationshipCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
