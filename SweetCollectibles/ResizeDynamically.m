//
//  ResizeDynamically.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-22.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import "ResizeDynamically.h"

@implementation ResizeDynamically

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGSize)sizeThatFits:(CGSize)size {
    if (size.width < self.bounds.size.width) {
        size.width = self.bounds.size.width;
    }
    if (size.height < self.bounds.size.height) {
        size.height = self.bounds.size.height;
    }
    return size;
}

@end
