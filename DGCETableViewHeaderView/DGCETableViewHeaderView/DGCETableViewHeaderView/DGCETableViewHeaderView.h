//
//  DGCETableViewHeaderView.h
//  DGCETableViewHeaderView
//
//  Created by Daniate on 2018/5/13.
//  Copyright © 2017年 Daniate. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DGCETableViewHeaderViewState) {
    DGCETableViewHeaderViewStateCollapsed,
    DGCETableViewHeaderViewStateExpanded,
};

@class DGCETableViewHeaderView;

@protocol DGCETableViewHeaderViewDelegate <NSObject>
@optional
- (void)willCollapseSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView;
- (void)didCollapseSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView;

- (void)willExpandSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView;
- (void)didExpandSectionHeaderView:(__kindof DGCETableViewHeaderView *)sectionHeaderView;
@end

/**
 A collapsible/expandable UITableViewHeaderFooterView
 */
@interface DGCETableViewHeaderView : UITableViewHeaderFooterView
@property (nonatomic, assign, readonly) NSInteger section;
@property (nonatomic, assign, readonly) DGCETableViewHeaderViewState state;
@property (nonatomic, weak, nullable) IBOutlet id<DGCETableViewHeaderViewDelegate> delegate;

- (void)setSection:(NSInteger)section
             state:(DGCETableViewHeaderViewState)state;

- (IBAction)toggleCollapsedExpanded:(id)sender;
@end

NS_ASSUME_NONNULL_END
