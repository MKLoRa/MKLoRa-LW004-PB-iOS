//
//  MKPBDeviceSettingController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBDeviceSettingController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKAlertController.h"

#import "MKPBInterface+MKPBConfig.h"

#import "MKPBDeviceSettingModel.h"

#import "MKPBOnOffSettingsController.h"
#import "MKPBDeviceInfoController.h"

@interface MKPBDeviceSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKPBDeviceSettingModel *dataModel;

@property (nonatomic, strong)NSArray *timeZoneList;

@property (nonatomic, strong)NSArray *lowPowerPromptList;

@property (nonatomic, strong)NSArray *vibrationIntensityList;

@end

@implementation MKPBDeviceSettingController

- (void)dealloc {
    NSLog(@"MKPBDeviceSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_pb_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKTextButtonCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 0.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4 && indexPath.row == 0) {
        //ON/OFF Settings
        MKPBOnOffSettingsController *vc = [[MKPBOnOffSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 0) {
        //恢复出厂设置
        [self factoryReset];
        return;
    }
    if (indexPath.section == 6 && indexPath.row == 0) {
        //Device Infomation
        MKPBDeviceInfoController *vc = [[MKPBDeviceInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
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
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    if (section == 6) {
        return self.section6List.count;
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
    if (indexPath.section == 1) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 5) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section6List[indexPath.row];
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
        //Current Time Zone
        [self configTimeZone:dataListIndex];
        return;
    }
    if (index == 1) {
        //Low Power Prompt
        [self configLowPowerPrompt:dataListIndex];
        return;
    }
    if (index == 2) {
        //Vibration Intensity
        [self configVibrationIntensity:dataListIndex];
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Low Power Payload
        [self configLowPowerPayload:isOn];
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
        [self updateCellDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configTimeZone:(NSInteger)timeZone {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [MKPBInterface pb_configTimeZone:(timeZone - 24) sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = timeZone;
        self.dataModel.timeZone = timeZone;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configLowPowerPrompt:(NSInteger)prompt {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    //固件协议里面对应的是10~60的连续值，所以需要做转换
    NSInteger resultPro = (prompt + 1) * 10;
    [MKPBInterface pb_configLowPowerPrompt:resultPro sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        MKTextButtonCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = prompt;
        self.dataModel.lowPowerPrompt = prompt;
        cellModel.noteMsg = [NSString stringWithFormat:@"*When the battery is less than or equal to %@, the green LED will flash once every 10 seconds.",self.lowPowerPromptList[prompt]];
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configLowPowerPayload:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [MKPBInterface pb_configLowPowerPayload:isOn sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        MKTextSwitchCellModel *cellModel = self.section2List[0];
        cellModel.isOn = isOn;
        self.dataModel.payload = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configVibrationIntensity:(NSInteger)intensity {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    //固件协议里面对应的是0~100的连续值，所以需要做转换
    NSInteger resultIntensity = 0;
    if (intensity == 0) {
        //No--->0%
        resultIntensity = 0;
    }else if (intensity == 1) {
        //Low--->10%
        resultIntensity = 10;
    }else if (intensity == 2) {
        //Medium--->50%
        resultIntensity = 50;
    }else if (intensity == 3) {
        //High--->80%
        resultIntensity = 80;
    }
    [MKPBInterface pb_configMotorVibrationIntensity:resultIntensity sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        MKTextButtonCellModel *cellModel = self.section3List[0];
        cellModel.dataListIndex = intensity;
        self.dataModel.vibrationIntensity = intensity;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset {
    NSString *msg = @"After factory reset,all the data will be reseted to the factory values.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Factory Reset"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_pb_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self sendResetCommandToDevice];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKPBInterface pb_factoryResetWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)updateCellDatas {
    MKTextButtonCellModel *cellModel1 = self.section0List[0];
    cellModel1.dataListIndex = self.dataModel.timeZone;
    
    MKTextButtonCellModel *cellModel2 = self.section1List[0];
    cellModel2.dataListIndex = self.dataModel.lowPowerPrompt;
    cellModel2.noteMsg = [NSString stringWithFormat:@"*When the battery is less than or equal to %@, the green LED will flash once every 10 seconds.",self.lowPowerPromptList[self.dataModel.lowPowerPrompt]];
    
    MKTextSwitchCellModel *cellModel3 = self.section2List[0];
    cellModel3.isOn = self.dataModel.payload;
    
    MKTextButtonCellModel *cellModel4 = self.section3List[0];
    cellModel4.dataListIndex = self.dataModel.vibrationIntensity;
    
    [self.tableView reloadData];
}

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    
    for (NSInteger i = 0; i < 7; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *cellModel1 = [[MKTextButtonCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Current Time Zone";
    cellModel1.dataList = [NSArray arrayWithArray:self.timeZoneList];
    [self.section0List addObject:cellModel1];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel1 = [[MKTextButtonCellModel alloc] init];
    cellModel1.index = 1;
    cellModel1.msg = @"Low Power Prompt";
    cellModel1.dataList = [NSArray arrayWithArray:self.lowPowerPromptList];
    cellModel1.noteMsg = @"*When the battery is less than or equal to 10%, the green LED will flash once every 10 seconds.";
    [self.section1List addObject:cellModel1];
}

- (void)loadSection2Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Low Power Payload";
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Vibration Intensity";
    cellModel.dataList = [NSArray arrayWithArray:self.vibrationIntensityList];
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"ON/OFF Settings";
    cellModel.showRightIcon = YES;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Factory Reset";
    cellModel.showRightIcon = YES;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Device Information";
    cellModel.showRightIcon = YES;
    [self.section6List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Device Settings";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKPBDeviceSettingModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBDeviceSettingModel alloc] init];
    }
    return _dataModel;
}

- (NSArray *)timeZoneList {
    if (!_timeZoneList) {
        _timeZoneList = @[@"UTC-12:00",@"UTC-11:30",@"UTC-11:00",@"UTC-10:30",@"UTC-10:00",@"UTC-09:30",
                          @"UTC-09:00",@"UTC-08:30",@"UTC-08:00",@"UTC-07:30",@"UTC-07:00",@"UTC-06:30",
                          @"UTC-06:00",@"UTC-05:30",@"UTC-05:00",@"UTC-04:30",@"UTC-04:00",@"UTC-03:30",
                          @"UTC-03:00",@"UTC-02:30",@"UTC-02:00",@"UTC-01:30",@"UTC-01:00",@"UTC-00:30",
                          @"UTC+00:00",@"UTC+00:30",@"UTC+01:00",@"UTC+01:30",@"UTC+02:00",@"UTC+02:30",
                          @"UTC+03:00",@"UTC+03:30",@"UTC+04:00",@"UTC+04:30",@"UTC+05:00",@"UTC+05:30",
                          @"UTC+06:00",@"UTC+06:30",@"UTC+07:00",@"UTC+07:30",@"UTC+08:00",@"UTC+08:30",
                          @"UTC+09:00",@"UTC+09:30",@"UTC+10:00",@"UTC+10:30",@"UTC+11:00",@"UTC+11:30",
                          @"UTC+12:00",@"UTC+12:30",@"UTC+13:00",@"UTC+13:30",@"UTC+14:00"];
    }
    return _timeZoneList;
}

- (NSArray *)lowPowerPromptList {
    if (!_lowPowerPromptList) {
        _lowPowerPromptList = @[@"10%",@"20%",@"30%",@"40%",@"50%",@"60%"];
    }
    return _lowPowerPromptList;
}

- (NSArray *)vibrationIntensityList {
    if (!_vibrationIntensityList) {
        _vibrationIntensityList = @[@"No",@"Low",@"Medium",@"High"];
    }
    return _vibrationIntensityList;
}

@end
