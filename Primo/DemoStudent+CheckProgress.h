//
//  DemoStudent+CheckProgress.h
//  Primo
//
//  Created by Jarrett Chen on 9/4/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStudent.h"

@interface DemoStudent (CheckProgress) <UITableViewDataSource,UITableViewDelegate>

+(DemoStudent*)findStudentProgress:(NSManagedObjectContext*)context;
-(CGFloat)getTotalProgress;
-(UIImageView*)demoProgressTotalFrame:(CGRect)frame;


@end
