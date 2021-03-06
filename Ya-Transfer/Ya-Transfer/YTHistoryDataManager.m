//
//  YTHistoryDataManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTHistoryDataManager.h"
#import "YTOperation.h"
#import "FMDB.h"

@interface YTHistoryDataManager ()

@property (nonatomic) FMDatabase *database;

@end

@implementation YTHistoryDataManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
        
        self.database = [FMDatabase databaseWithPath:path];
        [self.database open];
        
        [self.database executeUpdate: @"create table if not exists Operation("
                                       "id integer primary key autoincrement,"
                                       "recipientId text,"
                                       "amount real,"
                                       "comment text);"];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static YTHistoryDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)updateHistory:(NSArray *)operations
{
    for (YTOperation *operation in operations) {
        [self.database executeUpdate:@"insert into Operation (recipientId, amount, comment) values (?, ?, ?)",
         operation.recipientId, [NSNumber numberWithDouble:operation.amount], operation.comment];
    }
}

- (NSArray *)getHistory
{
    FMResultSet *results = [self.database executeQuery:@"select * from Operation"];
    NSMutableArray *history = [NSMutableArray arrayWithCapacity:0];
    
    while (results.next) {
        YTOperation *newOperation = [[YTOperation alloc] init];
        
        newOperation.recipientId = [results stringForColumn:@"recipientId"];
        newOperation.amount      = [results intForColumn:@"amount"];
        newOperation.comment     = [results stringForColumn:@"comment"];
        
        [history addObject:newOperation];
    }
    
    return history;
}

- (void)dealloc
{
    [self.database close];
}

@end