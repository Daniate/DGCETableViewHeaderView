//
//  ViewController.m
//  DGCETableViewHeaderView
//
//  Created by Daniate on 2018/5/13.
//  Copyright © 2018年 Daniate. All rights reserved.
//

#import "ViewController.h"
#import "DGCETableViewHeaderView.h"

static NSString *const CellReuseIdentifier = @"UITableViewCell";
static NSString *const HeaderViewReuseIdentifier = @"DGCETableViewHeaderView";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, DGCETableViewHeaderViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray<NSMutableArray<NSString *> *> *itemsList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray<NSMutableArray<NSString *> *> *itemsList = @[].mutableCopy;
    for (int i = 0; i < 50; i++) {
        [itemsList addObject:@[].mutableCopy];
    }
    self.itemsList = itemsList;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    [self.tableView registerClass:[DGCETableViewHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderViewReuseIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.itemsList[indexPath.section][indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DGCETableViewHeaderView *view = (DGCETableViewHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewReuseIdentifier];
    
    NSMutableArray<NSString *> *items = self.itemsList[section];
    DGCETableViewHeaderViewState state;
    if (items.count) {
        state = DGCETableViewHeaderViewStateExpanded;
    } else {
        state = DGCETableViewHeaderViewStateCollapsed;
    }
    [view setSection:section state:state];
    view.delegate = self;
    
    view.textLabel.text = [NSString stringWithFormat:@"section: %ld", (long)section];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

#pragma mark - DGCETableViewHeaderViewDelegate
- (void)willCollapseSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView {
    [self.tableView performBatchUpdates:^{
        NSMutableArray<NSString *> *items = self.itemsList[sectionHeaderView.section];
        
        NSMutableArray<NSIndexPath *> *rows = @[].mutableCopy;
        for (NSUInteger i = 0; i < items.count; i++) {
            [rows addObject:[NSIndexPath indexPathForRow:i inSection:sectionHeaderView.section]];
        }
        
        [items removeAllObjects];
        
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didCollapseSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView {
    
}

- (void)willExpandSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView {
    [self.tableView performBatchUpdates:^{
        NSMutableArray<NSString *> *items = self.itemsList[sectionHeaderView.section];
        
        uint32_t m = 1 + arc4random_uniform(25);
        NSMutableArray<NSIndexPath *> *rows = @[].mutableCopy;
        for (uint32_t i = 0; i < m; i++) {
            [items addObject:[NSString stringWithFormat:@"row %u", i]];
            [rows addObject:[NSIndexPath indexPathForRow:i inSection:sectionHeaderView.section]];
        }
        
        [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didExpandSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView {
    
}

@end
