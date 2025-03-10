//
//  MKPBDevEUICell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2025/3/5.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDevEUICellModel : NSObject

@property (nonatomic, copy)NSString *devEUI;

@end

@interface MKPBDevEUICell : MKBaseCell

@property (nonatomic, strong)MKPBDevEUICellModel *dataModel;

+ (MKPBDevEUICell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
