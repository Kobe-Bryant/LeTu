//
//  FriendsCircleBlacklistView.m
//  LeTu
//
//  Created by DT on 14-6-16.
//
//

#import "FriendsCircleBlacklistView.h"

@interface FriendsCircleBlacklistView()

@end

@implementation FriendsCircleBlacklistView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//        self.imageView.image = [UIImage imageNamed:@"me_headphoto"];
        [self addSubview:self.imageView];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(45, -10, 25, 25)];
        [self.deleteButton setImage:[UIImage imageNamed:@"blacklist_btn_delete_normal"]
                           forState:UIControlStateNormal];
        [self.deleteButton setImage:[UIImage imageNamed:@"blacklist_btn_delete_press"]
                           forState:UIControlStateHighlighted];
        self.deleteButton.hidden = YES;
        [self.deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 20)];
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = UITextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
//        self.nameLabel.text = @"但丁";
        [self addSubview:self.nameLabel];
    }
    return self;
}
-(void)clickButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(blacklistViewClickDelete:)]) {
        [self.delegate blacklistViewClickDelete:self];
    }
}
@end
