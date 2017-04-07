//
//  SBTableView.m
//  DropDownAnimation
//
//  Created by sycf_ios on 2017/4/7.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "SBTableView.h"

@implementation SBTableView
//解决scroll和手势冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
