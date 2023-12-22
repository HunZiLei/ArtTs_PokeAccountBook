export default class AccountData{
  id:number = -1;
  accountType:number=0; //支出or收入
  typeText: string = ''; //消费类型
  amount: number = 0; //数额
  day: string = '';
  month: string = '';
  year: string = '';
  reminder: string = ''; //备注
}