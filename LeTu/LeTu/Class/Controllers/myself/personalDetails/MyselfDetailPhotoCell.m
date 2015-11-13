//
//  MyselfDetailPhotoCell.m
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "MyselfDetailPhotoCell.h"

#define PLACEHOLDERTWO [UIImage imageNamed:@"default_pic.png"]

@interface MyselfDetailPhotoCell()
@property(nonatomic,strong)UIImageView *arrowImage;
@property(nonatomic,strong)UIImageView *lineImage;
@property(nonatomic,strong)UIImageView *PhotoImage1;
@property(nonatomic,strong)UIImageView *PhotoImage2;
@property(nonatomic,strong)UIImageView *PhotoImage3;
@property(nonatomic,strong)UIImageView* photoImage4;
@end

@implementation MyselfDetailPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.keyLabel.backgroundColor = [UIColor clearColor];
        self.keyLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
        self.keyLabel.font = [UIFont systemFontOfSize:15.0f];
        self.keyLabel.text = @"最新照片";
        [self addSubview:self.keyLabel];
        
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.lineImage.image = [UIImage imageNamed:@"posting_line"];
        self.lineImage.alpha = 0.8;
        //[self addSubview:self.lineImage];
        
        self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.arrowImage.image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        [self addSubview:self.arrowImage];
        
        self.PhotoImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(75+8.0, 7, 46, 46)];
//        self.PhotoImage1.image = [UIImage imageNamed:@"me_headphoto"];
        self.PhotoImage1.userInteractionEnabled = NO;
        [self addSubview:self.PhotoImage1];
        
        self.PhotoImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.PhotoImage1.frame)+8.0, 7, 46, 46)];
        self.PhotoImage2.userInteractionEnabled = NO;
//        self.PhotoImage2.image = [UIImage imageNamed:@"location_pic"];
        [self addSubview:self.PhotoImage2];
        
        self.PhotoImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.PhotoImage2.frame)+8.0, 7, 46, 46)];
        self.PhotoImage3.userInteractionEnabled = NO;

//        self.PhotoImage3.image = [UIImage imageNamed:@"location_picBubble"];
        [self addSubview:self.PhotoImage3];
        
        self.photoImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.PhotoImage3.frame)+8.0, 7, 46, 46)];
        self.photoImage4.userInteractionEnabled = NO;

        [self addSubview:self.photoImage4];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    if (iOS_7_Above) {
        self.keyLabel.frame = CGRectMake(15, (self.frame.size.height-30)/2, 60, 30);
    }else{
        self.keyLabel.frame = CGRectMake(15, (self.frame.size.height-30)/2, 60, 30);
    }
    self.arrowImage.frame = CGRectMake(300, (self.frame.size.height-13)/2, 9, 13);
    self.lineImage.frame = CGRectMake(10, self.frame.size.height-1, 300, 1);
}
- (void)setPhotosArray:(NSArray *)photosArray
{
     
    
    
    if ([photosArray count]==1) {
//        self.PhotoImage1.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [photosArray objectAtIndex:0]]];
        [self.PhotoImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:0]]] placeholderImage:PLACEHOLDERTWO];
        
        
//        self.PhotoImage1.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    }else if ([photosArray count]==2){
//        self.PhotoImage1.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [photosArray objectAtIndex:0]]];
//        self.PhotoImage1.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
//        self.PhotoImage2.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [photosArray objectAtIndex:1]]];
        [self.PhotoImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:0]]] placeholderImage:PLACEHOLDERTWO];
        [self.PhotoImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:1]]] placeholderImage:PLACEHOLDERTWO];
//        self.PhotoImage2.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    }else if ([photosArray count] ==3){
//        self.PhotoImage1.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [photosArray objectAtIndex:0]]];
//        self.PhotoImage1.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
//        self.PhotoImage2.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [photosArray objectAtIndex:1]]];
//        self.PhotoImage2.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
//        self.PhotoImage3.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [photosArray objectAtIndex:2]]];
//        self.PhotoImage3.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        [self.PhotoImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:0]]] placeholderImage:PLACEHOLDERTWO];
        [self.PhotoImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:1]]] placeholderImage:PLACEHOLDERTWO];
        [self.PhotoImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:2]]] placeholderImage:PLACEHOLDERTWO];
    }else {
    
//        NSString* url = @"http://e.hiphotos.baidu.com/image/w%3D310/sign=dfe60e00ccfc1e17fdbf8a307a90f67c/10dfa9ec8a136327fe9f7b25928fa0ec08fac7b2.jpg";
//        
//        [self.PhotoImage1 setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDERTWO];
//        [self.PhotoImage2 setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDERTWO];
//        [self.PhotoImage3 setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDERTWO];
//        [self.photoImage4 setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDERTWO];
//        
//        
//        
//        
//        return;
        
        [self.PhotoImage1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:0]]] placeholderImage:PLACEHOLDERTWO];
        [self.PhotoImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:1]]] placeholderImage:PLACEHOLDERTWO];
        [self.PhotoImage3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:2]]] placeholderImage:PLACEHOLDERTWO];
          [self.photoImage4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, [photosArray objectAtIndex:3]]] placeholderImage:PLACEHOLDERTWO];
    
    }
    
    
}
@end
