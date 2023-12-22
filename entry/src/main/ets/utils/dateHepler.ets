class dateHelper{
  public static  getWeek(day: string):Number{
    let y = parseInt(day.substring(0,4));
    let m = parseInt(day.substring(5,7));
    let d = parseInt(day.substring(8,10));
    if(m == 1 || m == 2){
      y--;
      m += 12;
    }
    let c = y / 100;
    y = y - c*100;
    let w = 0;
    w = y + y / 4 + c / 4 - 2 * c + 26 * (m + 1) / 10 + d - 1;
    return w;
  }
}