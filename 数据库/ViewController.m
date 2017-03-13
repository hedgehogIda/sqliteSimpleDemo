//
//  ViewController.m
//  数据库
//
//  Created by 腾实信 on 2017/3/13.
//  Copyright © 2017年 ida. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import <sqlite3_private.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    sqlite3 *database;
    int databaseResult = sqlite3_open([[self path] UTF8String], &database);
    if (databaseResult != SQLITE_OK) {
        NSLog(@"创建／打开数据库失败，%d",databaseResult);
    }
    else{
    //创建数据库成功 创建表
        char *error;
        //   建表格式: create table if not exists 表名 (列名 类型,....)    注: 如需生成默认增加的id: id integer primary key autoincrement
        const char *createSQL = "create table if not exists list(id integer primary key autoincrement,name char,sex char)";
        int tableResult = sqlite3_exec(database, createSQL, NULL, NULL, &error);
        if (tableResult != SQLITE_OK) {
            NSLog(@"创建表失败:%s",error);
        }
        else{
        //创建表成功，则插入数据
            
            /*
             // 对SQL语句执行预编译
             int sqlite3_prapare_v2(sqlite3 *db, const char *sql,int byte,sqlite3_stmt **stmt,const char **tail)
             1.db代表打开的数据库连接
             2.sql代表的sql语句
             3.byte代表SQL语句的最大长度
             4.传出参数,指向预编译SQL语句产生的sqlite3_stmt
             5.指向SQL语句中未使用的部分
             int sqlite3_prapare_v2()版本,代表该函数的最新版本。
            */
            const char *insertSQL = "insert into list (name,sex) values('ida','female')";
            sqlite3_stmt *stmt;
            int insetResult = sqlite3_prepare_v2(database, insertSQL, -1, &stmt, nil);
            if (insetResult != SQLITE_OK) {
                NSLog(@"添加失败，%d",insetResult);
            }else{
                sqlite3_step(stmt);
                
                //查找数据
                //sql语句格式: select 列名 from 表名 where 列名 ＝ 参数
                //注：前面的列名为查询结果里所需要看到的 列名,后面的 列名 ＝ 参数 用于判断删除哪条数据
                const char *searchSQL = "select id,name,sex from list where name = 'ida'";
                int searchResult = sqlite3_prepare_v2(database, searchSQL, -1, &stmt, nil);
                if (searchResult != SQLITE_OK) {
                    NSLog(@"查询失败");
                }else{
//                    sqlite3_stmt *stmtt;
                    while (sqlite3_step(stmt) == SQLITE_ROW) {
                        int idWord = sqlite3_column_int(stmt, 0);
                        char *nameWord = (char *) sqlite3_column_text(stmt, 1);
                        char *sexWord = (char *)sqlite3_column_text(stmt, 2);
                        NSLog(@"idWord:%d,nameWord:%s,sexWord:%s",idWord,nameWord,sexWord);
                    }
                    
                    
                }
                
                //修改数据
                //sql语句格式: update 表名 set  列名 = 新参数 where 列名 ＝ 参数
                //注：前面的 列名 ＝ 新参数 是修改的值, 后面的 列名 ＝ 参数 用于判断删除哪条数据
                const char *changeSQL = "update list set name = 'LiuHuan' where name = 'ida'";
                
                int updateResult = sqlite3_prepare_v2(database, changeSQL, -1, &stmt, nil);
                
                if (updateResult != SQLITE_OK) {
                    
                    NSLog(@"修改失败,%d",updateResult);
                }
                else{
                    
                    sqlite3_step(stmt);
                }
                
                //删除
                //sql语句格式: delete from 表名 where 列名 ＝ 参数     注：后面的 列名 ＝ 参数 用于判断删除哪条数据
                const char *deleteSQL = "delete from list where name = 'iosRunner'";
                
                int deleteResult = sqlite3_prepare_v2(database, deleteSQL, -1, &stmt, nil);
                
                if (deleteResult != SQLITE_OK) {
                    
                    NSLog(@"删除失败,%d",deleteResult);
                    
                }
                else{
                    sqlite3_step(stmt);
                    NSLog(@"删除成功,%d",deleteResult);
                }
                
                //        销毁stmt,回收资源
                sqlite3_finalize(stmt);
                
                //    关闭数据库
                sqlite3_close(database);
            }
        }
    }
}
- (NSString *)path {
    NSArray *domcumentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentPath = domcumentArray.lastObject;
    NSString *path = [NSString stringWithFormat:@"%@/crylown.db",documentPath];
    return path;
}

@end
