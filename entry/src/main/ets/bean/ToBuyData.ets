export default class ToBuyData{
  thing: string = 'default';
  isDone: boolean = false;
  ddl: Date;

  constructor(name: string, isDone: boolean, date: Date){
    this.thing = name;
    this.isDone = isDone;
    this.ddl = date;
  }
}