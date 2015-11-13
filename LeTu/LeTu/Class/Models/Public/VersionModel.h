//
//  VersionModel.h
//  PGCBD
//
//  Created by cyberwayios on 13-6-27.
//
//

#import "BaseModel.h"

@interface VersionModel : BaseModel
{
    
}
@property(nonatomic,retain) NSString *ID;
@property(nonatomic,retain) NSString *Versions;
@property(nonatomic,retain) NSString *IsYes;
@property(nonatomic,retain) NSString *CreatedOn;
@property(nonatomic,retain) NSString *PlistUrl;


@end
