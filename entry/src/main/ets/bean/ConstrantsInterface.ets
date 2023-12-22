/*数据库相关*/
export interface AccountTable{
  tableName: string;
  sqlCreate: string; //记录sql语句
  columns: string[]; //查询到的结果
}