//
//  MKPBDebuggerCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/12/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDebuggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *timeMsg;

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *logInfo;

@end

@protocol MKPBDebuggerCellDelegate <NSObject>

- (void)pb_debuggerCellSelectedChanged:(NSInteger)index selected:(BOOL)selected;

@end

@interface MKPBDebuggerCell : MKBaseCell

@property (nonatomic, strong)MKPBDebuggerCellModel *dataModel;

@property (nonatomic, weak)id <MKPBDebuggerCellDelegate>delegate;

+ (MKPBDebuggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
