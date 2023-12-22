/*记账本中的各个栏目*/
export default interface AccountItem{
  icon: Resource;
  iconSelected: Resource;
  accountType: number; //支出or收入
  typeText: string; //备注
}