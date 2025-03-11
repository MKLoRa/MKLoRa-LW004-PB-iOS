//
//  MKPBLoRaSettingController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBLoRaSettingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKLoRaAdvancedSettingCell.h"
#import "MKLoRaSettingCHCell.h"
#import "MKNormalTextCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKNormalService.h"
#import "MKIoTCloudExitAccountAlert.h"
#import "MKIoTCloudAccountLoginAlertView.h"

#import "MKPBConnectModel.h"
#import "MKPBUserLoginManager.h"

#import "MKPBLoRaSettingModel.h"

#import "MKPBLoRaSettingAccountCell.h"
#import "MKPBDevEUICell.h"


@interface MKPBLoRaSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKLoRaAdvancedSettingCellDelegate,
MKLoRaSettingCHCellDelegate,
MKPBLoRaSettingAccountCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

/// LoRaWAN Mode
@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *otaaDataList;

@property (nonatomic, strong)NSMutableArray *abpDataList;

/// mokoDevEUI
@property (nonatomic, strong)NSMutableArray *section1List;

/// Region
@property (nonatomic, strong)NSMutableArray *section2List;

/// Device Type
@property (nonatomic, strong)NSMutableArray *section3List;

/// Message Type
@property (nonatomic, strong)NSMutableArray *section4List;

/// LoRaWAN Server Platform
@property (nonatomic, strong)NSMutableArray *section5List;

/// Account
@property (nonatomic, strong)NSMutableArray *section6List;

/// Gateway EUI(Gateway ID)
@property (nonatomic, strong)NSMutableArray *section7List;

/// Advanced Setting(Optional)
@property (nonatomic, strong)NSMutableArray *optionsList0;

/// CH
@property (nonatomic, strong)NSMutableArray *optionsList1;

/// Duty-cycle
@property (nonatomic, strong)NSMutableArray *optionsList2;

/// DR For Join
@property (nonatomic, strong)NSMutableArray *optionsList3;

/// Uplink Strategy
@property (nonatomic, strong)NSMutableArray *optionsList4;

/// ADR
@property (nonatomic, strong)NSMutableArray *optionsList5;

/// Transmissions
@property (nonatomic, strong)NSMutableArray *optionsList6;

/// DR For Payload
@property (nonatomic, strong)NSMutableArray *optionsList7;

/// Max retransmission times
@property (nonatomic, strong)NSMutableArray *optionsList8;

/// ADR_ACK_LIMIT/ADR_ACK_DELAY
@property (nonatomic, strong)NSMutableArray *optionsList9;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKPBLoRaSettingModel *dataModel;

@end

@implementation MKPBLoRaSettingController

- (void)dealloc {
    NSLog(@"MKPBLoRaSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    if (self.dataModel.platform == 0) {
        //不需要跟服务器交互
        [self saveDataToDevice];
        return;
    }
    if (!ValidStr([MKPBUserLoginManager shared].password)) {
        //当前未登录
        @weakify(self);
        MKIoTCloudAccountLoginAlertViewModel *viewModel = [[MKIoTCloudAccountLoginAlertViewModel alloc] init];
        viewModel.account = [MKPBUserLoginManager shared].username;
        viewModel.isHome = [MKPBUserLoginManager shared].isHome;
        viewModel.password = [MKPBUserLoginManager shared].password;
        MKIoTCloudAccountLoginAlertView *alertView = [[MKIoTCloudAccountLoginAlertView alloc] init];
        [alertView showViewWithModel:viewModel completeBlock:^(NSString * _Nonnull account, NSString * _Nonnull password, BOOL isHome) {
            @strongify(self);
            [self login:isHome username:account password:password];
        }];
        return;
    }
    //登录过
    [self login:[MKPBUserLoginManager shared].isHome username:[MKPBUserLoginManager shared].username password:[MKPBUserLoginManager shared].password];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 8) {
        //LoRaWAN Server Platform
        MKTextFieldCellModel *cellModel = self.section7List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    //底部需要高级设置
    if (indexPath.section == 9) {
        //Advanced Setting
        return 80.f;
    }
    if (indexPath.section == 10) {
        //CH
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 11) {
        //Duty-cycle
        MKTextSwitchCellModel *cellModel = self.optionsList2[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 12) {
        //DR For Join
        MKTextButtonCellModel *cellModel = self.optionsList3[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && (self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 0)) {
        //LoRaWAN Mode
        return 10.f;
    }
    if (section == 2 && (self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1)) {
        //mokoDevEUI
        return 10.f;
    }
    if (section == 3) {
        //Region
        return 10.f;
    }
    if (section == 4 && self.dataModel.configModel.supportClassType) {
        //Device Type
        return 10.f;
    }
    if (section == 5 && self.dataModel.configModel.supportMessageType) {
        //Message Type
        return 10.f;
    }
    if (section == 6 && self.dataModel.configModel.supportServerPlatform) {
        //LoRaWAN Server Platform
        return 10.f;
    }
    if (section == 7 && (self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1)) {
        //Account
        return 10.f;
    }
    if (section == 8 && (self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1)) {
        //Gateway EUI(Gateway ID)
        return 10.f;
    }
    if (section == 13 || section == 18) {
        return 10.f;
    }
    
    return 0.f;
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
        return (self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 0) ? self.section0List.count : 0;
    }
    if (section == 1) {
        if (self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1) {
            return 0;
        }
        if (self.dataModel.modem == 1) {
            //ABP
            return self.abpDataList.count;
        }
        if (self.dataModel.modem == 2) {
            //OTAA
            return self.otaaDataList.count;
        }
    }
    if (section == 2) {
        //mokoDevEUI，只有当platform=MOKO IoT DM的时候才有
        return ((self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1) ? self.section2List.count : 0);
    }
    if (section == 3) {
        //Region
        return self.section2List.count;
    }
    if (section == 4) {
        //Device Type
        return (self.dataModel.configModel.supportClassType ? self.section3List.count : 0);
    }
    if (section == 5) {
        //Message Type
        return (self.dataModel.configModel.supportMessageType ? self.section4List.count : 0);
    }
    if (section == 6) {
        //LoRaWAN Server Platform
        return (self.dataModel.configModel.supportServerPlatform ? self.section5List.count : 0);
    }
    if (section == 7) {
        //Account
        return ((self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1 && ValidStr([MKPBUserLoginManager shared].password)) ? self.section6List.count : 0);
    }
    if (section == 8) {
        //Gateway EUI(Gateway ID)
        return ((self.dataModel.configModel.supportServerPlatform && self.dataModel.platform == 1) ? self.section7List.count : 0);
    }
    //存在高级设置选项
    if (section == 9) {
        return self.optionsList0.count;
    }
    if (!self.dataModel.advancedStatus) {
        //高级选项开关关闭状态
        return 0;
    }
    if (section == 10) {
        //CH
        if (self.dataModel.currentRegion == 1 || self.dataModel.currentRegion == 2 || self.dataModel.currentRegion == 8) {
            //US915、AU915、CN470
            return self.optionsList1.count;
        }
        return 0;
    }
    if (section == 11) {
        //Duty-cycle
        if (self.dataModel.currentRegion == 3 || self.dataModel.currentRegion == 4 || self.dataModel.currentRegion == 5 || self.dataModel.currentRegion == 9) {
            //EU868,CN779, EU433,RU864
            return self.optionsList2.count;
        }
        return 0;
    }
    if (section == 12) {
        //DR For Join
        if (self.dataModel.currentRegion == 2 || self.dataModel.currentRegion == 3 || self.dataModel.currentRegion == 4
            || self.dataModel.currentRegion == 5 || self.dataModel.currentRegion == 6 || self.dataModel.currentRegion == 7
            || self.dataModel.currentRegion == 9) {
            //CN470, CN779, EU433, EU868,KR920, IN865, RU864
            return self.optionsList3.count;
        }
        return 0;
    }
    if (section == 13) {
        //Uplink  Strategy
        return self.optionsList4.count;
    }
    if (section == 14) {
        //ADR
        return self.optionsList5.count;
    }
    if (section == 15) {
        //Transmissions
        return (self.dataModel.adrIsOn ? 0 : self.optionsList6.count);
    }
    if (section == 16) {
        //DR For Payload
        return (self.dataModel.adrIsOn ? 0 : self.optionsList7.count);
    }
    if (section == 17) {
        //Max retransmission times
        return ((self.dataModel.configModel.supportMessageType && self.dataModel.messageType == 1) ? self.optionsList8.count : 0);
    }
    if (section == 18) {
        //ADR_ACK_LIMIT、ADR_ACK_DELAY
        return self.optionsList9.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //LoRaWAN Mode
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        //Dev
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        MKTextFieldCellModel *model = (self.dataModel.modem == 1) ? self.abpDataList[indexPath.row] : self.otaaDataList[indexPath.row];
        cell.dataModel = model;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        //mokoDevEUI
        MKPBDevEUICell *cell = [MKPBDevEUICell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        //Region/Subnet
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //Device Type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //Message Type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //LoRaWAN Server Platform
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Account
        MKPBLoRaSettingAccountCell *cell = [MKPBLoRaSettingAccountCell initCellWithTableView:tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //Gateway EUI(Gateway ID)
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //Advanced Setting(Optional)
        MKLoRaAdvancedSettingCell *cell = [MKLoRaAdvancedSettingCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList0[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 10) {
        //CH
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList1[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 11) {
        //Duty-cycle
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList2[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 12) {
        //DR For Join
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList3[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 13) {
        //Uplink  Strategy
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList4[indexPath.row];
        return cell;
    }
    if (indexPath.section == 14) {
        //ADR
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList5[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 15) {
        //Transmissions
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList6[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 16) {
        //DR For Payload
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList7[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 17) {
        //Max retransmission times
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList8[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.optionsList9[indexPath.row];
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
        //modem
        self.dataModel.modem = (dataListIndex + 1);
        MKTextButtonCellModel *modeModel = self.section0List[0];
        modeModel.dataListIndex = dataListIndex;
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        //region
        self.dataModel.region = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section2List[0];
        regionModel.dataListIndex = dataListIndex;
        //刷新了region，如果当前是存在高级设置的，需要同步更新所有的高级设置
        if (self.dataModel.needAdvanceSetting) {
            [self regionValueChanged];
        }
        return;
    }
    if (index == 2) {
        //Device type
        self.dataModel.classType = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section3List[0];
        regionModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 3) {
        //Message type
        self.dataModel.messageType = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section4List[0];
        regionModel.dataListIndex = dataListIndex;
        [self.tableView mk_reloadSection:17 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 4) {
        //LoRaWAN Server Platform
        self.dataModel.platform = dataListIndex;
        MKTextButtonCellModel *platModel = self.section5List[0];
        platModel.dataListIndex = dataListIndex;
        
        MKTextButtonCellModel *regionModel = self.section2List[0];
        regionModel.dataList = [self.dataModel RegionList];
        regionModel.dataListIndex = 1;
        self.dataModel.region = 1;
        
        [self.tableView reloadData];
        return;
    }
    if (index == 5) {
        //DR For Join
        self.dataModel.join = dataListIndex;
        MKTextButtonCellModel *classModel = self.optionsList3[0];
        classModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 6) {
        //Transmissions
        self.dataModel.transmissions = dataListIndex;
        MKTextButtonCellModel *drModel = self.optionsList6[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 7) {
        //Max retransmission times
        self.dataModel.retransmission = dataListIndex;
        MKTextButtonCellModel *drModel = self.optionsList8[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 5) {
        //AppKey
        self.dataModel.appKey = value;
        MKTextFieldCellModel *appKeyModel = self.otaaDataList[2];
        appKeyModel.textFieldValue = value;
        return;
    }
    if (index == 6) {
        //Gateway EUI(Gateway ID)
        self.dataModel.gatewayEUI = value;
        MKTextFieldCellModel *cellModel = self.section7List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 7) {
        //ADR_ACK_LIMIT
        self.dataModel.ackLimit = value;
        MKTextFieldCellModel *cellModel = self.optionsList9[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 8) {
        //ADR_ACK_DELAY
        self.dataModel.ackDelay = value;
        MKTextFieldCellModel *cellModel = self.optionsList9[1];
        cellModel.textFieldValue = value;
        return;
    }
    MKTextFieldCellModel *abpDataModel = self.abpDataList[index];
    abpDataModel.textFieldValue = value;
    if (index == 0) {
        //DevEUI
        self.dataModel.devEUI = value;
        MKTextFieldCellModel *devEUIModel2 = self.otaaDataList[0];
        devEUIModel2.textFieldValue = self.dataModel.devEUI;
        return;
    }
    if (index == 1) {
        //AppEUI
        self.dataModel.appEUI = value;
        MKTextFieldCellModel *appEUIModel2 = self.otaaDataList[1];
        appEUIModel2.textFieldValue = self.dataModel.appEUI;
        return;
    }
    if (index == 2) {
        //DevAddr
        self.dataModel.devAddr = value;
        return;
    }
    if (index == 3) {
        //AppSkey
        self.dataModel.appSKey = value;
        return;
    }
    if (index == 4) {
        //NwkSkey
        self.dataModel.nwkSKey = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Duty-cycle
        self.dataModel.dutyIsOn = isOn;
        MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
        dutyModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        //ADR
        self.dataModel.adrIsOn = isOn;
        MKTextSwitchCellModel *adrModel = self.optionsList5[0];
        adrModel.isOn = isOn;
        //ADR关闭状态才能显示DR For Payload
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKLoRaSettingCHCellDelegate

/// 选择了右侧高位的列表
/// @param value 当前选中的值
/// @param chHighIndex 当前值在高位列表里面的index
/// @param index 当前cell所在的index
- (void)mk_loraSetting_chHighValueChanged:(NSString *)value
                              chHighIndex:(NSInteger)chHighIndex
                                cellIndex:(NSInteger)index {
    if (index == 0) {
        //CH
        self.dataModel.CHH = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
        cellModel.chHighIndex = chHighIndex;
        cellModel.chLowValueList = [self.dataModel CHLValueList];
        return;
    }
    if (index == 1) {
        //DR For Payload
        self.dataModel.DRH = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList7[0];
        cellModel.chHighIndex = chHighIndex;
        cellModel.chLowValueList = [self.dataModel DRLValueList];
        
        if (self.dataModel.DRH < self.dataModel.DRL) {
            cellModel.chLowIndex = cellModel.chLowValueList.count - 1;
            self.dataModel.DRL = self.dataModel.DRH;
        }
        cellModel.chLowIndex = [self getCurrentDRLIndex];
        
        [self.tableView mk_reloadSection:16 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

/// 选择了左侧高\低位的列表
/// @param value 当前选中的值
/// @param chLowIndex 当前值在低位列表里面的index
/// @param index 当前cell所在的index
- (void)mk_loraSetting_chLowValueChanged:(NSString *)value
                              chLowIndex:(NSInteger)chLowIndex
                               cellIndex:(NSInteger)index {
    if (index == 0) {
        //CH
        self.dataModel.CHL = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
        cellModel.chLowIndex = chLowIndex;
        cellModel.chHighValueList = [self.dataModel CHHValueList];
        return;
    }
    if (index == 1) {
        //DR For Payload
        self.dataModel.DRL = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList7[0];
        cellModel.chLowIndex = chLowIndex;
        cellModel.chHighValueList = [self.dataModel DRHValueList];
        
        if (self.dataModel.DRH < self.dataModel.DRL) {
            cellModel.chHighIndex = 0;
            self.dataModel.DRH = self.dataModel.DRL;
        }
        cellModel.chHighIndex = [self getCurrentDRHIndex];
        
        [self.tableView mk_reloadSection:16 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKLoRaAdvancedSettingCellDelegate
- (void)mk_loraSetting_advanceCell_switchStatusChanged:(BOOL)isOn {
    self.dataModel.advancedStatus = isOn;
    MKLoRaAdvancedSettingCellModel *cellModel = self.optionsList0[0];
    cellModel.isOn = isOn;
    
    [self.headerList removeAllObjects];
    
    NSInteger sections = (self.dataModel.advancedStatus ? 19 : 10);
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

#pragma mark - MKPBLoRaSettingAccountCellDelegate
- (void)pb_loRaSettingAccountCell_logoutBtnPressed {
    MKIoTCloudExitAccountAlert *alert = [[MKIoTCloudExitAccountAlert alloc] init];
    BOOL isHome = [MKPBUserLoginManager shared].isHome;
    NSString *username = [MKPBUserLoginManager shared].username;
    [alert showWithAccount:username completeBlock:^{
        [[MKPBUserLoginManager shared] syncLoginDataWithHome:isHome username:username password:@""];
        [self.tableView mk_reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - interface
- (void)login:(BOOL)isHome username:(NSString *)username password:(NSString *)password {
    [[MKHudManager share] showHUDWithTitle:@"Login..." inView:self.view isPenetration:NO];
    [[MKNormalService share] loginWithUsername:username password:password isHome:isHome sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [[MKPBUserLoginManager shared] syncLoginDataWithHome:isHome username:username password:password];
        [self addDeviceToCloud:SafeStr(returnData[@"data"][@"access_token"])];
    } failBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)addDeviceToCloud:(NSString *)token {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    MKUserCreateLoRaDeviceModel *createModel = [[MKUserCreateLoRaDeviceModel alloc] init];
    createModel.macAddress = [MKPBConnectModel shared].macAddress;
    createModel.isHome = [MKPBUserLoginManager shared].isHome;
    createModel.deviceType = 1;
    createModel.gwId = self.dataModel.gatewayEUI;
    createModel.region = self.dataModel.region;
    createModel.username = [MKPBUserLoginManager shared].username;
    [[MKNormalService share] addLoRaDeviceToCloud:createModel token:token sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [self saveDataToDevice];
    } failBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

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

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)regionValueChanged {
    [self.dataModel configAdvanceSettingDefaultParams];
    //CH
    MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
    cellModel.chLowValueList = [self.dataModel CHLValueList];
    cellModel.chLowIndex = [self getCurrentCHLIndex];
    cellModel.chHighValueList = [self.dataModel CHHValueList];
    cellModel.chHighIndex = [self getCurrentCHHIndex];
    //Duty-cycle
    MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
    dutyModel.isOn = self.dataModel.dutyIsOn;
    //DR For Join
    MKTextButtonCellModel *joinModel = self.optionsList3[0];
    joinModel.dataListIndex = self.dataModel.join;
    joinModel.dataList = [self.dataModel DRValueList];
    //ADR
    MKTextSwitchCellModel *adrModel = self.optionsList5[0];
    adrModel.isOn = self.dataModel.adrIsOn;
    //DR For Payload
    MKLoRaSettingCHCellModel *drModel = self.optionsList7[0];
    drModel.chLowValueList = [self.dataModel DRLValueList];
    drModel.chLowIndex = [self getCurrentDRLIndex];
    drModel.chHighValueList = [self.dataModel DRHValueList];
    drModel.chHighIndex = [self getCurrentDRHIndex];
    //Max retransmission times
    MKTextButtonCellModel *trModel = self.optionsList8[0];
    trModel.dataListIndex = self.dataModel.retransmission;
        
    [self.tableView reloadData];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadLoRaDataList];
    [self loadOptionsDataList];
    //底部需要高级设置
    NSInteger sections = (self.dataModel.advancedStatus ? 19 : 10);
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 加载上面那个列表
- (void)loadLoRaDataList {
    [self loadSection0Datas];
    [self loadABPDatas];
    [self loadOTAADatas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *modeModel = [[MKTextButtonCellModel alloc] init];
    modeModel.index = 0;
    modeModel.msg = @"LoRaWAN Mode";
    modeModel.dataList = @[@"ABP",@"OTAA"];
    modeModel.dataListIndex = (self.dataModel.modem - 1);
    modeModel.buttonLabelFont = MKFont(13.f);
    [self.section0List addObject:modeModel];
}

- (void)loadABPDatas {
    MKTextFieldCellModel *devEUIModel = [[MKTextFieldCellModel alloc] init];
    devEUIModel.index = 0;
    devEUIModel.msg = @"DevEUI";
    devEUIModel.textFieldTextFont = MKFont(13.f);
    devEUIModel.textFieldType = mk_hexCharOnly;
    devEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    devEUIModel.maxLength = 16;
    devEUIModel.textFieldValue = self.dataModel.devEUI;
    [self.abpDataList addObject:devEUIModel];
    
    MKTextFieldCellModel *appEUIModel = [[MKTextFieldCellModel alloc] init];
    appEUIModel.index = 1;
    appEUIModel.msg = @"AppEUI";
    appEUIModel.textFieldTextFont = MKFont(13.f);
    appEUIModel.textFieldType = mk_hexCharOnly;
    appEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    appEUIModel.maxLength = 16;
    appEUIModel.textFieldValue = self.dataModel.appEUI;
    [self.abpDataList addObject:appEUIModel];
    
    MKTextFieldCellModel *devAddrModel = [[MKTextFieldCellModel alloc] init];
    devAddrModel.index = 2;
    devAddrModel.msg = @"DevAddr";
    devAddrModel.textFieldTextFont = MKFont(13.f);
    devAddrModel.textFieldType = mk_hexCharOnly;
    devAddrModel.clearButtonMode = UITextFieldViewModeAlways;
    devAddrModel.maxLength = 8;
    devAddrModel.textFieldValue = self.dataModel.devAddr;
    [self.abpDataList addObject:devAddrModel];
    
    MKTextFieldCellModel *appSkeyModel = [[MKTextFieldCellModel alloc] init];
    appSkeyModel.index = 3;
    appSkeyModel.msg = @"AppSkey";
    appSkeyModel.textFieldTextFont = MKFont(13.f);
    appSkeyModel.textFieldType = mk_hexCharOnly;
    appSkeyModel.clearButtonMode = UITextFieldViewModeAlways;
    appSkeyModel.maxLength = 32;
    appSkeyModel.textFieldValue = self.dataModel.appSKey;
    [self.abpDataList addObject:appSkeyModel];
    
    MKTextFieldCellModel *nwkSkeyModel = [[MKTextFieldCellModel alloc] init];
    nwkSkeyModel.index = 4;
    nwkSkeyModel.msg = @"NwkSkey";
    nwkSkeyModel.textFieldTextFont = MKFont(13.f);
    nwkSkeyModel.textFieldType = mk_hexCharOnly;
    nwkSkeyModel.clearButtonMode = UITextFieldViewModeAlways;
    nwkSkeyModel.maxLength = 32;
    nwkSkeyModel.textFieldValue = self.dataModel.nwkSKey;
    [self.abpDataList addObject:nwkSkeyModel];
}

- (void)loadOTAADatas {
    MKTextFieldCellModel *devEUIModel = [[MKTextFieldCellModel alloc] init];
    devEUIModel.index = 0;
    devEUIModel.msg = @"DevEUI";
    devEUIModel.textFieldTextFont = MKFont(13.f);
    devEUIModel.textFieldType = mk_hexCharOnly;
    devEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    devEUIModel.maxLength = 16;
    devEUIModel.textFieldValue = self.dataModel.devEUI;
    [self.otaaDataList addObject:devEUIModel];
    
    MKTextFieldCellModel *appEUIModel = [[MKTextFieldCellModel alloc] init];
    appEUIModel.index = 1;
    appEUIModel.msg = @"AppEUI";
    appEUIModel.textFieldTextFont = MKFont(13.f);
    appEUIModel.textFieldType = mk_hexCharOnly;
    appEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    appEUIModel.maxLength = 16;
    appEUIModel.textFieldValue = self.dataModel.appEUI;
    [self.otaaDataList addObject:appEUIModel];
    
    MKTextFieldCellModel *appKeyModel = [[MKTextFieldCellModel alloc] init];
    appKeyModel.index = 5;
    appKeyModel.msg = @"AppKey";
    appKeyModel.textFieldTextFont = MKFont(13.f);
    appKeyModel.textFieldType = mk_hexCharOnly;
    appKeyModel.clearButtonMode = UITextFieldViewModeAlways;
    appKeyModel.maxLength = 32;
    appKeyModel.textFieldValue = self.dataModel.appKey;
    [self.otaaDataList addObject:appKeyModel];
}

- (void)loadSection1Datas {
    MKPBDevEUICellModel *cellModel = [[MKPBDevEUICellModel alloc] init];
    NSString *macAddress = [[MKPBConnectModel shared].macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *eui = [NSString stringWithFormat:@"%@%@%@",[macAddress substringToIndex:6],@"FFFF",[macAddress substringFromIndex:6]];
    cellModel.devEUI = [eui uppercaseString];
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Region/Subnet";
    cellModel.dataList = [self.dataModel RegionList];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = self.dataModel.currentRegion;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Device Type";
    cellModel.dataList = @[@"Class A",@"Class C"];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = self.dataModel.classType;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 3;
    cellModel.msg = @"Message Type";
    cellModel.dataList = @[@"Unconfirmed",@"Confirmed"];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = self.dataModel.messageType;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 4;
    cellModel.msg = @"LoRaWAN Server Platform";
    cellModel.msgFont = MKFont(12.f);
    cellModel.dataList = @[@"Third Party NS",@"MOKO IoT DM"];
    cellModel.buttonLabelFont = MKFont(12.f);
    cellModel.dataListIndex = self.dataModel.platform;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKPBLoRaSettingAccountCellModel *cellModel = [[MKPBLoRaSettingAccountCellModel alloc] init];
    cellModel.account = [MKPBUserLoginManager shared].username;
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 6;
    cellModel1.msg = @"Gateway EUI(Gateway ID)";
    cellModel1.textFieldType = mk_hexCharOnly;
    cellModel1.textPlaceholder = @"8 Bytes";
    cellModel1.maxLength = 16;
    cellModel1.textFieldValue = self.dataModel.gatewayEUI;
    cellModel1.noteMsg = @"*The server address, up port and down port vaule can be found in \"MOKO IoT DM Guide\" document    \n\n*Only UDP Packet forwarder protocol is available for gateway quick registration.";
    [self.section7List addObject:cellModel1];
}

#pragma mark - 加载底部列表
- (void)loadOptionsDataList {
    [self loadOptionsList0];
    [self loadOptionsList1];
    [self loadOptionsList2];
    [self loadOptionsList3];
    [self loadOptionsList4];
    [self loadOptionsList5];
    [self loadOptionsList6];
    [self loadOptionsList7];
    [self loadOptionsList8];
    [self loadOptionsList9];
}

- (void)loadOptionsList0 {
    MKLoRaAdvancedSettingCellModel *cellModel = [[MKLoRaAdvancedSettingCellModel alloc] init];
    cellModel.isOn = self.dataModel.advancedStatus;
    [self.optionsList0 addObject:cellModel];
}

- (void)loadOptionsList1 {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"CH";
    cellModel.noteMsg = @"*It is only used for US915,AU915,CN470";
    cellModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    cellModel.chLowValueList = [self.dataModel CHLValueList];
    cellModel.chLowIndex = [self getCurrentCHLIndex];
    cellModel.chHighValueList = [self.dataModel CHHValueList];
    cellModel.chHighIndex = [self getCurrentCHHIndex];
    [self.optionsList1 addObject:cellModel];
}

- (void)loadOptionsList2 {
    MKTextSwitchCellModel *dutyModel = [[MKTextSwitchCellModel alloc] init];
    dutyModel.index = 0;
    dutyModel.msg = @"Duty-cycle";
    dutyModel.noteMsg = @"*It is only used for EU868,CN779, EU433,and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.";
    dutyModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    dutyModel.isOn = self.dataModel.dutyIsOn;
    [self.optionsList2 addObject:dutyModel];
}

- (void)loadOptionsList3 {
    MKTextButtonCellModel *joinModel = [[MKTextButtonCellModel alloc] init];
    joinModel.index = 5;
    joinModel.msg = @"DR For Join";
    joinModel.dataList = [self.dataModel DRValueList];
    joinModel.buttonLabelFont = MKFont(13.f);
    joinModel.dataListIndex = self.dataModel.join;
    joinModel.noteMsg = @"*It is only used for CN470, CN779, EU433, EU868,KR920, IN865, RU864.";
    joinModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.optionsList3 addObject:joinModel];
}

- (void)loadOptionsList4 {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Uplink Strategy";
    [self.optionsList4 addObject:cellModel];
}

- (void)loadOptionsList5 {
    MKTextSwitchCellModel *adrModel = [[MKTextSwitchCellModel alloc] init];
    adrModel.index = 1;
    adrModel.msg = @"ADR";
    adrModel.isOn = self.dataModel.adrIsOn;
    [self.optionsList5 addObject:adrModel];
}

- (void)loadOptionsList6 {
    MKTextButtonCellModel *transmissionModel = [[MKTextButtonCellModel alloc] init];
    transmissionModel.index = 6;
    transmissionModel.msg = @"Transmissions";
    transmissionModel.dataList = @[@"1",@"2"];
    transmissionModel.buttonLabelFont = MKFont(13.f);
    transmissionModel.dataListIndex = self.dataModel.transmissions;
    [self.optionsList6 addObject:transmissionModel];
}

- (void)loadOptionsList7 {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"DR For Payload";
    cellModel.chLowValueList = [self.dataModel DRLValueList];
    cellModel.chLowIndex = [self getCurrentDRLIndex];
    cellModel.chHighValueList = [self.dataModel DRHValueList];
    cellModel.chHighIndex = [self getCurrentDRHIndex];
    [self.optionsList7 addObject:cellModel];
}

- (void)loadOptionsList8 {
    MKTextButtonCellModel *retransmissionModel = [[MKTextButtonCellModel alloc] init];
    retransmissionModel.index = 7;
    retransmissionModel.msg = @"Max retransmission times";
    retransmissionModel.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    retransmissionModel.buttonLabelFont = MKFont(13.f);
    retransmissionModel.dataListIndex = self.dataModel.retransmission;
    [self.optionsList8 addObject:retransmissionModel];
}

- (void)loadOptionsList9 {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 7;
    cellModel1.msg = @"ADR_ACK_LIMIT";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textPlaceholder = @"1-255";
    cellModel1.maxLength = 3;
    cellModel1.textFieldValue = self.dataModel.ackLimit;
    [self.optionsList9 addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 8;
    cellModel2.msg = @"ADR_ACK_DELAY";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textPlaceholder = @"1-255";
    cellModel2.maxLength = 3;
    cellModel2.textFieldValue = self.dataModel.ackDelay;
    [self.optionsList9 addObject:cellModel2];
}

- (NSInteger)getCurrentCHLIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.CHLValueList.count; i ++) {
        if (self.dataModel.CHL == [self.dataModel.CHLValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentCHHIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.CHHValueList.count; i ++) {
        if (self.dataModel.CHH == [self.dataModel.CHHValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentDRLIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.DRLValueList.count; i ++) {
        if (self.dataModel.DRL == [self.dataModel.DRLValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentDRHIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.DRHValueList.count; i ++) {
        if (self.dataModel.DRH == [self.dataModel.DRHValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Connection Settings";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-PB", @"MKPBLoRaSettingController", @"pb_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
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

- (NSMutableArray *)otaaDataList {
    if (!_otaaDataList) {
        _otaaDataList = [NSMutableArray array];
    }
    return _otaaDataList;
}

- (NSMutableArray *)abpDataList {
    if (!_abpDataList) {
        _abpDataList = [NSMutableArray array];
    }
    return _abpDataList;
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

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
}

- (MKPBLoRaSettingModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBLoRaSettingModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)optionsList0 {
    if (!_optionsList0) {
        _optionsList0 = [NSMutableArray array];
    }
    return _optionsList0;
}

- (NSMutableArray *)optionsList1 {
    if (!_optionsList1) {
        _optionsList1 = [NSMutableArray array];
    }
    return _optionsList1;
}

- (NSMutableArray *)optionsList2 {
    if (!_optionsList2) {
        _optionsList2 = [NSMutableArray array];
    }
    return _optionsList2;
}

- (NSMutableArray *)optionsList3 {
    if (!_optionsList3) {
        _optionsList3 = [NSMutableArray array];
    }
    return _optionsList3;
}

- (NSMutableArray *)optionsList4 {
    if (!_optionsList4) {
        _optionsList4 = [NSMutableArray array];
    }
    return _optionsList4;
}

- (NSMutableArray *)optionsList5 {
    if (!_optionsList5) {
        _optionsList5 = [NSMutableArray array];
    }
    return _optionsList5;
}

- (NSMutableArray *)optionsList6 {
    if (!_optionsList6) {
        _optionsList6 = [NSMutableArray array];
    }
    return _optionsList6;
}

- (NSMutableArray *)optionsList7 {
    if (!_optionsList7) {
        _optionsList7 = [NSMutableArray array];
    }
    return _optionsList7;
}

- (NSMutableArray *)optionsList8 {
    if (!_optionsList8) {
        _optionsList8 = [NSMutableArray array];
    }
    return _optionsList8;
}

- (NSMutableArray *)optionsList9 {
    if (!_optionsList9) {
        _optionsList9 = [NSMutableArray array];
    }
    return _optionsList9;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
