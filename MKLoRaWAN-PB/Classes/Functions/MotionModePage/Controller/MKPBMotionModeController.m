//
//  MKPBMotionModeController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBMotionModeController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"
#import "MKTextButtonCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKPBMotionModeModel.h"

@interface MKPBMotionModeController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *section7List;

@property (nonatomic, strong)NSMutableArray *section8List;

@property (nonatomic, strong)NSMutableArray *section9List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKPBMotionModeModel *dataModel;

@end

@implementation MKPBMotionModeController

- (void)dealloc {
    NSLog(@"MKPBMotionModeController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 3 || section == 6 || section == 9) {
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
    if (section == 7) {
        return self.section7List.count;
    }
    if (section == 8) {
        return self.section8List.count;
    }
    if (section == 9) {
        return self.section9List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section8List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.section9List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Number Of Fix On Start
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        self.dataModel.numberOfFixOnStart = value;
        return;
    }
    if (index == 1) {
        //Report Interval In Trip
        MKTextFieldCellModel *cellModel = self.section4List[0];
        cellModel.textFieldValue = value;
        self.dataModel.reportIntervalInTrip = value;
        return;
    }
    if (index == 2) {
        //Trip End Timeout
        MKTextFieldCellModel *cellModel = self.section7List[0];
        cellModel.textFieldValue = value;
        self.dataModel.tripEndTimeout = value;
        return;
    }
    if (index == 3) {
        //Number Of Fix On End
        MKTextFieldCellModel *cellModel = self.section7List[1];
        cellModel.textFieldValue = value;
        self.dataModel.numberOfFixOnEnd = value;
        return;
    }
    if (index == 4) {
        //Report Interval On End
        MKTextFieldCellModel *cellModel = self.section7List[2];
        cellModel.textFieldValue = value;
        self.dataModel.reportIntervalOnEnd = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    [self configMotionModeEvents:isOn index:index];
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
        //Pos-Strategy On Start
        MKTextButtonCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = dataListIndex;
        self.dataModel.posStrategyOnStart = dataListIndex;
        return;
    }
    if (index == 1) {
        //Pos-Strategy In Trip
        MKTextButtonCellModel *cellModel = self.section5List[0];
        cellModel.dataListIndex = dataListIndex;
        self.dataModel.posStrategyInTrip = dataListIndex;
        return;
    }
    if (index == 2) {
        //Pos-Strategy On End
        MKTextButtonCellModel *cellModel = self.section8List[0];
        cellModel.dataListIndex = dataListIndex;
        self.dataModel.posStrategyOnEnd = dataListIndex;
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

- (void)configMotionModeEvents:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Fix On Start
        self.dataModel.fixOnStart = isOn;
    }else if (index == 1) {
        //Fix In Trip
        self.dataModel.fixInTrip = isOn;
    }else if (index == 2) {
        //Fix On End
        self.dataModel.fixOnEnd = isOn;
    }else if (index == 3) {
        //Notify Event On Start
        self.dataModel.notifyEventOnStart = isOn;
    }else if (index == 4) {
        //Notify Event In Trip
        self.dataModel.notifyEventInTrip = isOn;
    }else if (index == 5) {
        //Notify Event On End
        self.dataModel.notifyEventOnEnd = isOn;
    }
    MKTextSwitchCellModel *cellModel = [self fetchEventModel:index];
    cellModel.isOn = isOn;
}

#pragma mark - Private method
- (MKTextSwitchCellModel *)fetchEventModel:(NSInteger)index {
    if (index == 0) {
        //Fix On Start
        return self.section0List[0];
    }
    if (index == 1) {
        //Fix In Trip
        return self.section3List[0];
    }
    if (index == 2) {
        //Fix On End
        return self.section6List[0];
    }
    if (index == 3) {
        //Notify Event On Start
        return self.section9List[0];
    }
    if (index == 4) {
        //Notify Event In Trip
        return self.section9List[1];
    }
    return self.section9List[2];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
    [self loadSection8Datas];
    [self loadSection9Datas];
    
    for (NSInteger i = 0; i < 10; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Fix On Start";
    cellModel.isOn = self.dataModel.fixOnStart;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Number Of Fix On Start";
    cellModel.textPlaceholder = @"1~255";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 3;
    cellModel.textFieldValue = self.dataModel.numberOfFixOnStart;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Pos-Strategy On Start";
    cellModel.dataList = @[@"BLE",@"GPS",@"BLE+GPS"];
    cellModel.dataListIndex = self.dataModel.posStrategyOnStart;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Fix In Trip";
    cellModel.isOn = self.dataModel.fixInTrip;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Report Interval In Trip";
    cellModel.textPlaceholder = @"10~86400";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 5;
    cellModel.textFieldValue = self.dataModel.reportIntervalInTrip;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Pos-Strategy In Trip";
    cellModel.dataList = @[@"BLE",@"GPS",@"BLE+GPS"];
    cellModel.dataListIndex = self.dataModel.posStrategyInTrip;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Fix On End";
    cellModel.isOn = self.dataModel.fixOnEnd;
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Trip End Timeout";
    cellModel1.textPlaceholder = @"3~180";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 3;
    cellModel1.unit = @"x10s";
    cellModel1.textFieldValue = self.dataModel.tripEndTimeout;
    [self.section7List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 3;
    cellModel2.msg = @"Number Of Fix On End";
    cellModel2.textPlaceholder = @"1~255";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 3;
    cellModel2.unit = @"";
    cellModel2.textFieldValue = self.dataModel.numberOfFixOnEnd;
    [self.section7List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 4;
    cellModel3.msg = @"Report Interval On End";
    cellModel3.textPlaceholder = @"10~300";
    cellModel3.textFieldType = mk_realNumberOnly;
    cellModel3.maxLength = 3;
    cellModel3.unit = @"s";
    cellModel3.textFieldValue = self.dataModel.reportIntervalOnEnd;
    [self.section7List addObject:cellModel3];
}

- (void)loadSection8Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Pos-Strategy On End";
    cellModel.dataList = @[@"BLE",@"GPS",@"BLE+GPS"];
    cellModel.dataListIndex = self.dataModel.posStrategyOnEnd;
    [self.section8List addObject:cellModel];
}

- (void)loadSection9Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 3;
    cellModel1.msg = @"Notify Event On Start";
    cellModel1.isOn = self.dataModel.notifyEventOnStart;
    [self.section9List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 4;
    cellModel2.msg = @"Notify Event In Trip";
    cellModel2.isOn = self.dataModel.notifyEventInTrip;
    [self.section9List addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 5;
    cellModel3.msg = @"Notify Event On End";
    cellModel3.isOn = self.dataModel.notifyEventOnEnd;
    [self.section9List addObject:cellModel3];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Motion Mode";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-PB", @"MKPBMotionModeController", @"pb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)section8List {
    if (!_section8List) {
        _section8List = [NSMutableArray array];
    }
    return _section8List;
}

- (NSMutableArray *)section9List {
    if (!_section9List) {
        _section9List = [NSMutableArray array];
    }
    return _section9List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKPBMotionModeModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBMotionModeModel alloc] init];
    }
    return _dataModel;
}

@end
