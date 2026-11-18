#import "MKPBUpdateModel.h"

#import "MKPBCentralManager.h"

@implementation MKPBUpdateModel

- (BOOL)mk_lora_update_useDFUWapper {
    return NO;
}

- (CBPeripheral *)mk_lora_update_peripheral {
    return [MKPBCentralManager shared].peripheral;
}

- (NSString *)mk_lora_update_startDfuNotificationName {
    return @"mk_pb_startDfuProcessNotification";
}

- (void)mk_lora_update_centralManagerDealloc {
    [MKPBCentralManager sharedDealloc];
}

- (void)mk_lora_update_cleanUpAfterUpdate {
    [MKPBCentralManager sharedDealloc];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_pb_centralDeallocNotification" object:nil];
}

@end
