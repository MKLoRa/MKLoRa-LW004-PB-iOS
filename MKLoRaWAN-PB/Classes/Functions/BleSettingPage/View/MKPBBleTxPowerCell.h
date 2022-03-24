//
//  MKPBBleTxPowerCell.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/10/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_pb_deviceTxPower) {
    mk_pb_deviceTxPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_pb_deviceTxPowerNeg20dBm,   //-20dBm
    mk_pb_deviceTxPowerNeg16dBm,   //-16dBm
    mk_pb_deviceTxPowerNeg12dBm,   //-12dBm
    mk_pb_deviceTxPowerNeg8dBm,    //-8dBm
    mk_pb_deviceTxPowerNeg4dBm,    //-4dBm
    mk_pb_deviceTxPower0dBm,       //0dBm
    mk_pb_deviceTxPower3dBm,       //3dBm
    mk_pb_deviceTxPower4dBm,       //4dBm
};

@interface MKPBBleTxPowerCellModel : NSObject

@property (nonatomic, assign)mk_pb_deviceTxPower txPower;

@end

@protocol MKPBBleTxPowerCellDelegate <NSObject>

- (void)mk_pb_txPowerValueChanged:(mk_pb_deviceTxPower)txPower;

@end

@interface MKPBBleTxPowerCell : MKBaseCell

@property (nonatomic, strong)MKPBBleTxPowerCellModel *dataModel;

@property (nonatomic, weak)id <MKPBBleTxPowerCellDelegate>delegate;

+ (MKPBBleTxPowerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
