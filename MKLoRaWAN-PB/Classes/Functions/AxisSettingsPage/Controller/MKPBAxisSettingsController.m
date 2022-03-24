//
//  MKPBAxisSettingsController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBAxisSettingsController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"

#import "MKPBAxisSettingsModel.h"

@interface MKPBAxisSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKPBAxisSettingsModel *dataModel;

@end

@implementation MKPBAxisSettingsController

- (void)dealloc {
    NSLog(@"MKPBAxisSettingsController销毁");
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
    [self saveParamsToDevice];
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
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    MKTextFieldCellModel *cellModel = self.dataList[index];
    cellModel.textFieldValue = value;
    if (index == 0) {
        //Wakeup Threshold
        self.dataModel.wakeupThreshold = value;
        return;
    }
    if (index == 1) {
        //Wakeup Duration
        self.dataModel.wakeupDuration = value;
        return;
    }
    if (index == 2) {
        //Motion  Threshold
        self.dataModel.motionThreshold = value;
        return;
    }
    if (index == 3) {
        //Motion Duration
        self.dataModel.motionDuration = value;
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

- (void)saveParamsToDevice {
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

#pragma mark - loadSections
- (void)loadSectionDatas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Wakeup Threshold";
    cellModel1.textFieldValue = self.dataModel.wakeupThreshold;
    cellModel1.textPlaceholder = @"1 ~ 20";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 2;
    cellModel1.unit = @"×16mg";
    [self.dataList addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Wakeup Duration";
    cellModel2.textFieldValue = self.dataModel.wakeupDuration;
    cellModel2.textPlaceholder = @"1 ~ 10";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 2;
    cellModel2.unit = @"×10ms";
    [self.dataList addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Motion Threshold";
    cellModel3.textFieldValue = self.dataModel.motionThreshold;
    cellModel3.textPlaceholder = @"10 ~ 250";
    cellModel3.textFieldType = mk_realNumberOnly;
    cellModel3.maxLength = 3;
    cellModel3.unit = @"×2mg";
    [self.dataList addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Motion Duration";
    cellModel4.textFieldValue = self.dataModel.motionDuration;
    cellModel4.textPlaceholder = @"1 ~ 50";
    cellModel4.textFieldType = mk_realNumberOnly;
    cellModel4.maxLength = 2;
    cellModel4.unit = @"×5ms";
    [self.dataList addObject:cellModel4];
        
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-Axis Settings";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-PB", @"MKPBAxisSettingsController", @"pb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKPBAxisSettingsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBAxisSettingsModel alloc] init];
    }
    return _dataModel;
}

@end
