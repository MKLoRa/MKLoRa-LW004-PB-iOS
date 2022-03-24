//
//  MKPBTimingModeController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBTimingModeController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKPickerView.h"

#import "MKPBTimingModeModel.h"

#import "MKPBReportTimePointCell.h"
#import "MKPBTimingModeAddCell.h"

@interface MKPBTimingModeController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKPBTimingModeAddCellDelegate,
MKPBReportTimePointCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKPBTimingModeModel *dataModel;

@end

@implementation MKPBTimingModeController

- (void)dealloc {
    NSLog(@"MKPBTimingModeController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.f;
    }
    if (indexPath.section == 1) {
        return 30.f;
    }
    return 38.f;
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
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.section == 1) {
        MKPBTimingModeAddCell *cell = [MKPBTimingModeAddCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKPBReportTimePointCell *cell = [MKPBReportTimePointCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    [cell resetFlagForFrame];
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
        //Positioning Strategy
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = dataListIndex;
        self.dataModel.strategy = dataListIndex;
        return;
    }
}

#pragma mark - MKPBTimingModeAddCellDelegate
- (void)pb_addButtonPressed {
    if (self.section2List.count >= 10) {
        //最多10组
        [self.view showCentralToast:@"You can set up to 10 time points!"];
        return;
    }
    MKPBReportTimePointCellModel *cellModel = [[MKPBReportTimePointCellModel alloc] init];
    cellModel.index = self.section2List.count;
    cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(self.section2List.count + 1)];
    cellModel.hourIndex = 0;
    cellModel.timeSpaceIndex = 0;
    [self.section2List addObject:cellModel];
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKPBReportTimePointCellDelegate
/**
 删除
 
 @param index 所在index
 */
- (void)pb_cellDeleteButtonPressed:(NSInteger)index {
    if (index > self.section2List.count - 1) {
        return;
    }
    [self.section2List removeObjectAtIndex:index];
    
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKPBReportTimePointCellModel *cellModel = self.section2List[i];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
    }
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

/// 用户选择了hour事件
- (void)pb_hourButtonPressed:(NSInteger)index {
    if (![self cellCanSelected]) {
        return;
    }
    [self showTimePointHourPickView:index];
}

/// 用户选择了时间间隔事件
- (void)pb_timeSpaceButtonPressed:(NSInteger)index {
    if (![self cellCanSelected]) {
        return;
    }
    [self showTimePointTimeSpacePickView:index];
}

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)pb_cellResetFrame {
    [self cellCanSelected];
}

- (void)pb_cellTapAction {
    [self cellCanSelected];
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

- (void)saveDataToDevice {
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKPBReportTimePointCellModel *cellModel = self.section2List[i];
        MKPBTimingModeTimePointModel *pointModel = [[MKPBTimingModeTimePointModel alloc] init];
        pointModel.hour = cellModel.hourIndex;
        pointModel.minuteGear = cellModel.timeSpaceIndex;
        [tempList addObject:pointModel];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configData:tempList sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
/**
 当有cell右侧的删除按钮出现时，不能触发点击事件
 
 @return YES可点击，NO不可点击
 */
- (BOOL)cellCanSelected{
    BOOL canSelected = YES;
    NSArray *arrCells = [self.tableView visibleCells];
    for (int i = 0; i < [arrCells count]; i++) {
        UITableViewCell *cell = arrCells[i];
        if ([cell isKindOfClass:MKPBReportTimePointCell.class]) {
            MKPBReportTimePointCell *tempCell = (MKPBReportTimePointCell *)cell;
            if ([tempCell canReset]) {
                [tempCell resetCellFrame];
                canSelected = NO;
            }
        }
    }
    return canSelected;
}

- (void)showTimePointHourPickView:(NSInteger)index {
    MKPBReportTimePointCellModel *cellModel = self.section2List[index];
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    NSArray *dataList = @[@"00",@"01",@"02",@"03",
                          @"04",@"05",@"06",@"07",
                          @"08",@"09",@"10",@"11",
                          @"12",@"13",@"14",@"15",
                          @"16",@"17",@"18",@"19",
                          @"20",@"21",@"22",@"23"];
    [pickView showPickViewWithDataList:dataList selectedRow:cellModel.hourIndex block:^(NSInteger currentRow) {
        cellModel.hourIndex = currentRow;
        [self.tableView mk_reloadRow:index inSection:2 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)showTimePointTimeSpacePickView:(NSInteger)index {
    MKPBReportTimePointCellModel *cellModel = self.section2List[index];
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    NSArray *dataList = @[@"00",@"15",@"30",@"45"];
    [pickView showPickViewWithDataList:dataList selectedRow:cellModel.timeSpaceIndex block:^(NSInteger currentRow) {
        cellModel.timeSpaceIndex = currentRow;
        [self.tableView mk_reloadRow:index inSection:2 withRowAnimation:UITableViewRowAnimationNone];
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
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Positioning Strategy";
    cellModel.dataList = @[@"BLE",@"GPS",@"BLE&GPS"];
    cellModel.dataListIndex = self.dataModel.strategy;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKPBReportTimePointCellModel * cellModel = [[MKPBReportTimePointCellModel alloc] init];
    cellModel.msg = @"Reporting Time Point";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    for (NSInteger i = 0; i < self.dataModel.pointList.count; i ++) {
        MKPBTimingModeTimePointModel *tempModel = self.dataModel.pointList[i];
        MKPBReportTimePointCellModel *cellModel = [[MKPBReportTimePointCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        cellModel.hourIndex = tempModel.hour;
        cellModel.timeSpaceIndex = tempModel.minuteGear;
        [self.section2List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Timing Mode";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-PB", @"MKPBTimingModeController", @"pb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKPBTimingModeModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBTimingModeModel alloc] init];
    }
    return _dataModel;
}

@end
