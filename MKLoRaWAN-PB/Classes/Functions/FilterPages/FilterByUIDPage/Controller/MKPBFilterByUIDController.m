//
//  MKPBFilterByUIDController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByUIDController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

#import "MKPBFilterNormalTextFieldCell.h"

#import "MKPBFilterByUIDModel.h"

@interface MKPBFilterByUIDController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKPBFilterNormalTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKPBFilterByUIDModel *dataModel;

@end

@implementation MKPBFilterByUIDController

- (void)dealloc {
    NSLog(@"MKPBFilterByUIDController销毁");
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
    return 2;
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
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKPBFilterNormalTextFieldCell *cell = [MKPBFilterNormalTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
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
        //namespace ID
        self.dataModel.namespaceID = text;
        MKPBFilterNormalTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = text;
        return;
    }
    if (index == 1) {
        //instance ID
        self.dataModel.instanceID = text;
        MKPBFilterNormalTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = text;
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
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Eddystone-UID";
    cellModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKPBFilterNormalTextFieldCellModel *cellModel1 = [[MKPBFilterNormalTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Namespace ID";
    cellModel1.textFieldType = mk_hexCharOnly;
    cellModel1.textPlaceholder = @"0~10 Bytes";
    cellModel1.textFieldValue = self.dataModel.namespaceID;
    cellModel1.maxLength = 20;
    [self.section1List addObject:cellModel1];
    
    MKPBFilterNormalTextFieldCellModel *cellModel2 = [[MKPBFilterNormalTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Instance ID";
    cellModel2.textFieldType = mk_hexCharOnly;
    cellModel2.textPlaceholder = @"0~6 Bytes";
    cellModel2.textFieldValue = self.dataModel.instanceID;
    cellModel2.maxLength = 12;
    [self.section1List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Filter by Raw Data";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-PB", @"MKPBFilterByUIDController", @"pb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKPBFilterByUIDModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKPBFilterByUIDModel alloc] init];
    }
    return _dataModel;
}

@end
