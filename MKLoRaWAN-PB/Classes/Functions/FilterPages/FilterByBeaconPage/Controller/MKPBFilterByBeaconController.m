//
//  MKPBFilterByBeaconController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByBeaconController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

#import "MKPBFilterBeaconCell.h"

#import "MKPBFilterNormalTextFieldCell.h"

#import "MKPBFilterByBeaconModel.h"

@interface MKPBFilterByBeaconController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKPBFilterNormalTextFieldCellDelegate,
MKPBFilterBeaconCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKPBFilterByBeaconModel *dataModel;

@end

@implementation MKPBFilterByBeaconController

- (void)dealloc {
    NSLog(@"MKPBFilterByBeaconController销毁");
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
    [self configDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.f;
    }
    return 70.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        MKPBFilterNormalTextFieldCell *cell = [MKPBFilterNormalTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKPBFilterBeaconCell *cell = [MKPBFilterBeaconCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //
        self.dataModel.isOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKPBFilterNormalTextFieldCellDelegate
- (void)mk_pb_filterNormalTextFieldValueChanged:(NSString *)text index:(NSInteger)index {
    if (index == 0) {
        //iBeacon UUID
        self.dataModel.uuid = text;
        MKPBFilterNormalTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = text;
        return;
    }
}

#pragma mark - MKPBFilterBeaconCellDelegate
- (void)mk_pb_beaconMinValueChanged:(NSString *)value index:(NSInteger)index {
    MKPBFilterBeaconCellModel *cellModel = self.section2List[index];
    cellModel.minValue = value;
    if (index == 0) {
        //Major
        self.dataModel.minMajor = value;
        return;
    }
    if (index == 1) {
        //Minor
        self.dataModel.minMinor = value;
        return;
    }
}

- (void)mk_pb_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index {
    MKPBFilterBeaconCellModel *cellModel = self.section2List[index];
    cellModel.maxValue = value;
    if (index == 0) {
        //Major
        self.dataModel.maxMajor = value;
        return;
    }
    if (index == 1) {
        //Minor
        self.dataModel.maxMinor = value;
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

- (void)configDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    if (self.pageType == mk_pb_filterByBeaconPageType_beacon) {
        cellModel.msg = @"iBeacon";
    }else if (self.pageType == mk_pb_filterByBeaconPageType_MKBeacon) {
        cellModel.msg = @"MKiBeacon";
    }else if (self.pageType == mk_pb_filterByBeaconPageType_MKBeaconAcc) {
        cellModel.msg = @"MKiBeacon&ACC";
    }
    cellModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKPBFilterNormalTextFieldCellModel *cellModel = [[MKPBFilterNormalTextFieldCellModel alloc] init];
    cellModel.index = 0;
    if (self.pageType == mk_pb_filterByBeaconPageType_beacon) {
        cellModel.msg = @"iBeacon UUID";
    }else if (self.pageType == mk_pb_filterByBeaconPageType_MKBeacon) {
        cellModel.msg = @"MKiBeacon UUID";
    }else if (self.pageType == mk_pb_filterByBeaconPageType_MKBeaconAcc) {
        cellModel.msg = @"MKiBeacon&ACC UUID";
    }
    cellModel.textFieldType = mk_hexCharOnly;
    cellModel.textPlaceholder = @"0~16 Bytes";
    cellModel.textFieldValue = self.dataModel.uuid;
    cellModel.maxLength = 32;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKPBFilterBeaconCellModel *cellModel1 = [[MKPBFilterBeaconCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.minValue = self.dataModel.minMajor;
    cellModel1.maxValue = self.dataModel.maxMajor;
    [self.section2List addObject:cellModel1];
    
    MKPBFilterBeaconCellModel *cellModel2 = [[MKPBFilterBeaconCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.minValue = self.dataModel.minMinor;
    cellModel2.maxValue = self.dataModel.maxMinor;
    [self.section2List addObject:cellModel2];
    
    if (self.pageType == mk_pb_filterByBeaconPageType_beacon) {
        cellModel1.msg = @"iBeacon Major";
        cellModel2.msg = @"iBeacon Minor";
    }else if (self.pageType == mk_pb_filterByBeaconPageType_MKBeacon) {
        cellModel1.msg = @"MKiBeacon Major";
        cellModel2.msg = @"MKiBeacon Minor";
    }else if (self.pageType == mk_pb_filterByBeaconPageType_MKBeaconAcc) {
        cellModel1.msg = @"MKiBeacon&ACC Major";
        cellModel2.msg = @"MKiBeacon&ACC Minor";
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Filter by Raw Data";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-PB", @"MKPBFilterByBeaconController", @"pb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKPBFilterByBeaconModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBFilterByBeaconModel alloc] init];
        _dataModel.pageType = self.pageType;
    }
    return _dataModel;
}

@end
