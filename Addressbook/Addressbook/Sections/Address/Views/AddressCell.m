//
//  AddressCell.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "AddressCell.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@implementation AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.phoneL];
    }
    return self;
}

- (UILabel *)nameL {
    if (!_nameL) {
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 40)];
        _nameL.textAlignment = 1;
        _nameL.textColor = [UIColor lightGrayColor];
    }
    return _nameL;
}

- (UILabel *)phoneL {
    if (!_phoneL) {
        self.phoneL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameL.frame), CGRectGetMinY(self.nameL.frame), kWidth - CGRectGetMaxX(self.nameL.frame) - 30, 40)];
        _phoneL.textAlignment = 1;
        _phoneL.textColor = [UIColor lightGrayColor];
    }
    return _phoneL;
}


@end
