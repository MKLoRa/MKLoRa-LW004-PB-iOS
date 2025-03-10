//
//  MKPBLoRaSettingAccountCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2025/3/3.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBLoRaSettingAccountCellModel : NSObject

@property (nonatomic, copy)NSString *account;

@end

@protocol MKPBLoRaSettingAccountCellDelegate <NSObject>

- (void)pb_loRaSettingAccountCell_logoutBtnPressed;

@end

@interface MKPBLoRaSettingAccountCell : MKBaseCell

@property (nonatomic, strong)MKPBLoRaSettingAccountCellModel *dataModel;

@property (nonatomic, weak)id <MKPBLoRaSettingAccountCellDelegate>delegate;

+ (MKPBLoRaSettingAccountCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
