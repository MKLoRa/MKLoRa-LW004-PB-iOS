//
//  MKPBAlertSettingsController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBAlertSettingsController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKPBInterface+MKPBConfig.h"

#import "MKPBAlertSettingsModel.h"

@interface MKPBAlertSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKPBAlertSettingsModel *dataModel;

@end

@implementation MKPBAlertSettingsController

- (void)dealloc {
    NSLog(@"MKPBAlertSettingsController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Trigger Mode
        [self configTriggerMode:dataListIndex];
        return;
    }
    if (index == 1) {
        //Positioning Strategy
        [self configPositioningStrategy:dataListIndex];
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Notify Event On Alert Start
        [self configAlertStart:isOn];
        return;
    }
    if (index == 1) {
        //Notify Event On Alert End
        [self configAlertEnd:isOn];
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
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

- (void)configTriggerMode:(NSInteger)triggerMode {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKPBInterface pb_configAlertTriggerMode:triggerMode sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        self.dataModel.triggerMode = triggerMode;
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = triggerMode;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configPositioningStrategy:(NSInteger)strategy {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKPBInterface pb_configAlertPositioningStrategy:strategy sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        self.dataModel.strategy = strategy;
        MKTextButtonCellModel *cellModel = self.section0List[1];
        cellModel.dataListIndex = strategy;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configAlertStart:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKPBInterface pb_configNotifyEventOnAlertStart:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        self.dataModel.start = isOn;
        MKTextSwitchCellModel *cellModel = self.section1List[0];
        cellModel.isOn = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configAlertEnd:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKPBInterface pb_configNotifyEventOnAlertEnd:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        self.dataModel.end = isOn;
        MKTextSwitchCellModel *cellModel = self.section1List[1];
        cellModel.isOn = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *cellModel1 = [[MKTextButtonCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Trigger Mode";
    cellModel1.dataList = @[@"Single Click",@"Double Click",@"Long Press 1s",@"Long Press 2s",@"Long Press 3s",@"Long Press 4s",@"Long Press 5s"];
    cellModel1.dataListIndex = self.dataModel.triggerMode;
    [self.section0List addObject:cellModel1];
    
    MKTextButtonCellModel *cellModel2 = [[MKTextButtonCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Positioning Strategy";
    cellModel2.dataList = @[@"BLE",@"GPS",@"BLE+GPS"];
    cellModel2.dataListIndex = self.dataModel.strategy;
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Notify Event On Alert Start";
    cellModel1.msgFont = MKFont(13.f);
    cellModel1.isOn = self.dataModel.start;
    [self.section1List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Notify Event On Alert End";
    cellModel2.msgFont = MKFont(13.f);
    cellModel2.isOn = self.dataModel.end;
    [self.section1List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Alert Settings";
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
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKPBAlertSettingsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBAlertSettingsModel alloc] init];
    }
    return _dataModel;
}

@end
