//
//  MKPBDeviceInfoController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKTableSectionLineHeader.h"

#import "MKPBTextButtonCell.h"

#import "MKPBDeviceInfoModel.h"

#import "MKPBUpdateController.h"
#import "MKPBDebuggerController.h"

@interface MKPBDeviceInfoController ()<UITableViewDelegate,
UITableViewDataSource,
MKPBTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKPBDeviceInfoModel *dataModel;

@property (nonatomic, assign)BOOL onlyBattery;

/// 用户进入dfu页面开启升级模式，返回该页面，不需要读取任何的数据
@property (nonatomic, assign)BOOL isDfuModel;

@end

@implementation MKPBDeviceInfoController

- (void)dealloc {
    NSLog(@"MKPBDeviceInfoController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isDfuModel) {
        //用户进入dfu页面开启升级模式，返回该页面，不需要读取任何的数据
        [self readDataFromDevice];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceStartDFUProcess)
                                                 name:@"mk_pb_startDfuProcessNotification"
                                               object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
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
    if (indexPath.section == 5 && indexPath.row == 0) {
        MKPBDebuggerController *vc = [[MKPBDebuggerController alloc] init];
        vc.macAddress = self.dataModel.macAddress;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKPBTextButtonCell *cell = [MKPBTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section2List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section3List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 4) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section4List[indexPath.row];
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel =  self.section5List[indexPath.row];
    return cell;
}

#pragma mark - MKPBTextButtonCellDelegate
/// 用户点击了右侧按钮
/// @param index cell所在序列号
- (void)pb_textButtonCell_buttonAction:(NSInteger)index {
    if (index == 0) {
        //DFU
        MKPBUpdateController *vc = [[MKPBUpdateController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - note
- (void)deviceStartDFUProcess {
    self.isDfuModel = YES;
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        if (!self.onlyBattery) {
            self.onlyBattery = YES;
        }
        [self updateCellDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellDatas {
    if (ValidStr(self.dataModel.software)) {
        MKNormalTextCellModel *softwareModel = self.section0List[0];
        softwareModel.rightMsg = self.dataModel.software;
    }
    if (ValidStr(self.dataModel.firmware)) {
        MKPBTextButtonCellModel *firmwareModel = self.section1List[0];
        firmwareModel.rightMsg = self.dataModel.firmware;
    }
    if (ValidStr(self.dataModel.hardware)) {
        MKNormalTextCellModel *hardware = self.section2List[0];
        hardware.rightMsg = self.dataModel.hardware;
    }
    if (ValidStr(self.dataModel.voltage)) {
        MKNormalTextCellModel *hardware = self.section3List[0];
        hardware.rightMsg = [self.dataModel.voltage stringByAppendingString:@"V"];
    }
    
    if (ValidStr(self.dataModel.macAddress)) {
        MKNormalTextCellModel *mac = self.section4List[0];
        mac.rightMsg = self.dataModel.macAddress;
    }
    if (ValidStr(self.dataModel.productMode)) {
        MKNormalTextCellModel *produceModel = self.section4List[1];
        produceModel.rightMsg = self.dataModel.productMode;
    }
    
    if (ValidStr(self.dataModel.manu)) {
        MKNormalTextCellModel *manuModel = self.section4List[2];
        manuModel.rightMsg = self.dataModel.manu;
    }
    [self.tableView reloadData];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    for (NSInteger i = 0; i < 6; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Software Version";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKPBTextButtonCellModel *cellModel = [[MKPBTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.leftMsg = @"Firmware Version";
    cellModel.rightButtonTitle = @"DFU";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Hardware Version";
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Battery Voltage";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"MAC Address";
    [self.section4List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Product Model";
    [self.section4List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Manufacturer";
    [self.section4List addObject:cellModel3];
}

- (void)loadSection5Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Debugger Mode";
    cellModel.showRightIcon = YES;
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Device Information";
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKPBDeviceInfoModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBDeviceInfoModel alloc] init];
    }
    return _dataModel;
}

@end
