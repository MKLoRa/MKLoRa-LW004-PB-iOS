//
//  MKPBDeviceInfoController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBDeviceInfoController.h"

#import "MKPBDeviceInfoModel.h"

#import "MKPBUpdateController.h"
#import "MKPBSelftestController.h"
#import "MKPBDebuggerController.h"

@interface MKPBDeviceInfoController ()<UITableViewDelegate>

@end

@interface MKLoRaDeviceInfoController (MKSuperCall)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MKPBDeviceInfoController

- (instancetype)init {
    if (self = [super init]) {
        self.protocol = [[MKPBDeviceInfoModel alloc] init];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //DFU
        MKPBUpdateController *vc = [[MKPBUpdateController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 6 && indexPath.row == 0) {
        //Debugger Mode
        MKPBDebuggerController *vc = [[MKPBDebuggerController alloc] init];
        vc.macAddress = self.protocol.macAddress;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - event method
- (void)handleTripleTap {
    MKPBSelftestController *vc = [[MKPBSelftestController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
