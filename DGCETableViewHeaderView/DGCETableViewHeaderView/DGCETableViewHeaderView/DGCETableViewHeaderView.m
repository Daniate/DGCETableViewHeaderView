//
//  DGCETableViewHeaderView.m
//  DGCETableViewHeaderView
//
//  Created by Daniate on 2018/5/13.
//  Copyright © 2017年 Daniate. All rights reserved.
//

#import "DGCETableViewHeaderView.h"
#import <pthread/pthread.h>

static pthread_mutex_t DGCE_MUTEX = PTHREAD_MUTEX_INITIALIZER;

@interface DGCETableViewHeaderView ()
@property (nonatomic, strong) UITapGestureRecognizer *ceTap;
@end

@implementation DGCETableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self _init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _init];
}

- (void)setSection:(NSInteger)section state:(DGCETableViewHeaderViewState)state {
    _state = state;
    _section = section;
}

#pragma mark - Public
- (IBAction)toggleCollapsedExpanded:(id)sender {
    if (!self.delegate) {
        return;
    }
    pthread_mutex_lock(&DGCE_MUTEX);
    switch (self.state) {
        case DGCETableViewHeaderViewStateCollapsed:
        {
            if ([self.delegate respondsToSelector:@selector(willExpandSectionHeaderView:)]) {
                [self.delegate willExpandSectionHeaderView:self];
            }
            if ([self.delegate respondsToSelector:@selector(didExpandSectionHeaderView:)]) {
                _state = DGCETableViewHeaderViewStateExpanded;
                [self.delegate didExpandSectionHeaderView:self];
            }
            break;
        }
        case DGCETableViewHeaderViewStateExpanded:
        {
            if ([self.delegate respondsToSelector:@selector(willCollapseSectionHeaderView:)]) {
                [self.delegate willCollapseSectionHeaderView:self];
            }
            if ([self.delegate respondsToSelector:@selector(didCollapseSectionHeaderView:)]) {
                _state = DGCETableViewHeaderViewStateCollapsed;
                [self.delegate didCollapseSectionHeaderView:self];
            }
            break;
        }
        default:
            break;
    }
    pthread_mutex_unlock(&DGCE_MUTEX);
}

#pragma mark - Private
- (void)_init {
    _ceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCollapsedExpanded:)];
    [self.contentView addGestureRecognizer:_ceTap];
}

@end
