//
//  MKPBOnOffSettingsController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBOnOffSettingsController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKAlertController.h"

#import "MKPBInterface+MKPBConfig.h"

#import "MKPBOnOffSettingsModel.h"

@interface MKPBOnOffSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKPBOnOffSettingsModel *dataModel;

@end

@implementation MKPBOnOffSettingsController

- (void)dealloc {
    NSLog(@"MKPBOnOffSettingsController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Shut-Down Payload
        [self shutDownPayload:isOn];
        return;
    }
    if (index == 1) {
        //OFF by Button
        [self turnOffDeviceByButton:isOn];
        return;
    }
    if (index == 2) {
        //Power Off
        [self powerOff];
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 关机
- (void)powerOff {
    NSString *msg = @"Are you sure to turn off the device? Please make sure the device has a button to turn on!";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_pb_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        MKTextSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = NO;
        [self.tableView mk_reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertView addAction:cancelAction];
    
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self sendPowerOffCommandToDevice];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)sendPowerOffCommandToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKPBInterface pb_powerOffWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark -

- (void)shutDownPayload:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKPBInterface pb_configShutDownPayloadStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        MKTextSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
        self.dataModel.payload = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)turnOffDeviceByButton:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKPBInterface pb_configTurnOffDeviceByButtonStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        MKTextSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        self.dataModel.button = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Shut-Down Payload";
    cellModel1.isOn = self.dataModel.payload;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"OFF by Button";
    cellModel2.isOn = self.dataModel.button;
    [self.dataList addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Power Off";
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"ON/OFF Settings";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKPBOnOffSettingsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBOnOffSettingsModel alloc] init];
    }
    return _dataModel;
}

@end
