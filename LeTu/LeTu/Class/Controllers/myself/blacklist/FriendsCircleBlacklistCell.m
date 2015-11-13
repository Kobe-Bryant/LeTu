//
//  FriendsCircleBlacklistCell.m
//  LeTu
//
//  Created by DT on 14-6-16.
//
//

#import "FriendsCircleBlacklistCell.h"

@implementation FriendsCircleBlacklistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 40, 40)];
        self.faceImageView.image = PLACEHOLDER;
        [self addSubview:self.faceImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 200, 30)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
        self.nameLabel.text = @"陈冠希";
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
