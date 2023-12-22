
import router from '@ohos.router';
import AccountData from '../bean/AccountData';
import { ImageList } from '../bean/AccountList';
import AccountTable from '../database/AccountTable';
import CommonConstants from '../database/CommonConstants';
import Logger from '../utils/Logger';
import { DialogComponent } from './DialogComponent';
import systemDateTime from '@ohos.systemDateTime';
import dateHelper from '../utils/Logger';

//声明侧滑栏目类
class showingColumn{
  data: AccountData
  h_scroller: Scroller

  constructor(data:AccountData,h_scroller:Scroller) {
    this.data = data;
    this.h_scroller = h_scroller;
  }
}

@Entry
@Component
struct Index {
  /*声明页面的变量*/
  //绘制曲线相关变量
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(600, 600, this.settings)
  @State xPos: Array<number> = new Array<number>(30,80,130,180,230,280,330);
  @State yPos: Array<number> = new Array<number>(1,1,1,1,1,1,1);
  @State daySum: number = 0;
  @State monSum: number = 0;
  @LocalStorageProp('title') title: string = "口袋记账本";
  @State refresh: number = 1;

  @State scale2: number = 1
  @State opacity2: number = 1
  @State switchLeft: boolean = false

  @State accounts: Array<AccountData> = [];
  @State message: string = 'hello';
  @State isEditing: boolean = false;
  @State isInsert: boolean = false;
  @State index: number = -1;
  @State isDragging: boolean = false; //判断悬浮按钮是否正在被拖动，从而判断原按钮显隐
  @State today_income: number = -1;
  @State today_outcome: number = -1;
  @State searchText: string = '';
  @State newAccount: AccountData = {
    id:0,
    accountType:0,
    typeText:'',
    amount:0,
    day: '',
    year: '',
    month: '',
    reminder: '',
  };

  private AccountTable = new AccountTable(()=>{});
  private deleteList: Array<AccountData> = [];
  searchController: SearchController = new SearchController();
  scroller: Scroller = new Scroller();
  /*侧滑删除栏相关*/
  //已经打开的删除栏
  private openedDeleteData: showingColumn = null;
  private horizontal_scroller: Scroller = new Scroller();
  //按下的x轴坐标
  private downX = 0;
  //删除按钮的宽度
  private deleteWidth = 100;
  @Builder CustomItem(item:showingColumn) {
    Scroll(item.h_scroller) {
      Row(){
        Row() {
          //图标
          Image(ImageList[item.data.typeText])
            .width('40vp')
            .aspectRatio(CommonConstants.FULL_SIZE)
            .margin({ right: '16vp' })

          //类别
          Text(item.data.typeText)
            .height('22vp')
            .fontSize('18vp')

          //空白
          Blank()
            .layoutWeight(2)

          //备注
          Text(item.data.reminder.length > 4 ? item.data.reminder.substring(0, 4) + '...' : item.data.reminder)
            .height('22vp')
            .fontSize('16vp')
            .fontColor('#767778')

          //空白
          Blank()
            .layoutWeight(1)

          //根据是否在编辑，展示删除按钮 or 总额
          if (!this.isEditing) { //总额
            Text((item.data.accountType === 0 ? '-' : '+') + item.data.amount.toString())
              .fontSize('16vp')
              .fontColor(item.data.accountType === 0 ? $r('app.color.spend_color') : $r('app.color.income_color'))
              .align(Alignment.End)
              .flexGrow(CommonConstants.FULL_SIZE)
          } else {
            Row() {
              Toggle({ type: ToggleType.Checkbox })
                .onChange((isOn) => {
                  //即将删除的栏目放在deleteList中
                  if (isOn) {
                    this.deleteList.push(item.data);
                  } else {
                    let index = this.deleteList.indexOf(item.data);
                    this.deleteList.splice(index, 1);
                  }
                })
            }
            .align(Alignment.End)
            .flexGrow(CommonConstants.FULL_SIZE)
            .justifyContent(FlexAlign.End)
          }
        }
        .width('100%')
        .height('56vp')
        .onClick(() => {
          this.selectListItem(item.data);
          this.dialogController.open();
        })
        //侧滑删除栏
        Button() {
          Text('删除')
            .fontSize(15)
            .fontColor(Color.White)
        }
        .type(ButtonType.Normal)
        .width(this.deleteWidth)
        .height(65)
        .backgroundColor(Color.Red)
        .onClick(() => {
        })
      }//scroll下的row
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)//取消滚动条
    .onTouch((event: TouchEvent) => { // 触摸事件
      console.info("###Touch me!!");
      // 判断是否有打开删除组件，有则关闭
      if (this.openedDeleteData != null && this.openedDeleteData != item) {
        console.info("###Try to slide back");
        this.openedDeleteData.h_scroller.scrollTo({ xOffset: 0, yOffset: 0,
          animation: { duration: 100, curve: Curve.Linear } })
      }

      // 根据触摸类型判断
      switch (event.type) {
        case TouchType.Down: // 触摸按下
        // 记录按下的x轴坐标
          console.info("###@@ Touch Down")
          this.downX = event.touches[0].x
          break
        case TouchType.Up: // 触摸抬起
          console.info("###@@ Touch Up")
        // 触摸抬起，根据x轴总偏移量，判断是否打开删除
          let xOffset = event.touches[0].x - this.downX
        // 防止消费点击事件
          if (xOffset == 0) {
            return
          }
        // 滑到x轴的位置
          var toxOffset = 0
        // 开启删除的对象置为null
          this.openedDeleteData = null;
        // 偏移量超过删除按钮一半且左滑，设置打开
          console.info("###Offset: " + xOffset);
          if (Math.abs(xOffset) > vp2px(this.deleteWidth) / 2 && xOffset < 0) {
            // 删除布局宽度
            console.info("###Try to slide");
            toxOffset = vp2px(this.deleteWidth);
            console.info("###toxOffset = " + toxOffset);
            this.openedDeleteData = item;
            if(this.openedDeleteData.data != null)
              console.info("###Check item: "+this.openedDeleteData.data.amount.toString());
            else console.info("###Check item: NULL");
          }
        // 滑动指定位置，设置动画
          item.h_scroller.scrollTo({ xOffset: toxOffset, yOffset: 0,
            animation: { duration: 300, curve: Curve.Linear } })
        // 重置按下的x轴坐标
          this.downX = 0
          break
      }
    })
    }


  /*页面跳转-controller*/
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogComponent({
      isInsert: $isInsert,
      newAccount: $newAccount,
      confirm: (isInsert: boolean, newAccount: AccountData) => this.accept(isInsert, newAccount)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  });

  /*页面跳转函数*/
  jumpSumPage(): void{
    router.pushUrl({
      url: 'pages/sumPage', // 目标url
      params:{
        yPos: this.yPos
      }
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }

  jumpToBuyPage(): void{
    router.pushUrl({
      url: 'pages/toBuyPage', // 目标url
      params:{
        yPos: this.yPos
      }
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }

  jumpMePage(): void{
    router.pushUrl({
      url: 'pages/mePage', // 目标url
      params:{
        yPos: this.yPos
      }
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }
  /*跳转函数*/

  /*声明页面所需的函数*/
  aboutToAppear() {
    this.AccountTable.getRdbStore(() => {
      this.AccountTable.query(0, (result: AccountData[]) => {
        this.accounts = result;
      }, true);
    });
  }

  selectListItem(item: AccountData) {
    this.isInsert = false;
    this.index = this.accounts.indexOf(item);
    this.newAccount = {
      id: item.id,
      accountType: item.accountType,
      typeText: item.typeText,
      amount: item.amount,
      day: item.day,
      month: item.month,
      year: item.year,
      reminder: item.reminder
    };
  }

  deleteListItem() {
    for (let i = 0; i < this.deleteList.length; i++) {
      let index = this.accounts.indexOf(this.deleteList[i]);
      this.yPos[dateHelper.getWeek(this.accounts[index].day)] -= this.accounts[index].amount;
      this.accounts.splice(index, 1);
      this.AccountTable.deleteData(this.deleteList[i], () => {
      });
    }
    this.deleteList = [];
    this.isEditing = false;
    this.refresh++;
  }


  //isInsert->插入数据; !isInsert->修改数据
  accept(isInsert: boolean, newAccount: AccountData): void {
    //计算目标日期到今天日期的时间
    let week = dateHelper.getWeek(newAccount.day);
    console.info('###星期是：'+week);
    //新项目
    if (isInsert) {
      Logger.info(`${CommonConstants.INDEX_TAG}`, `The account inserted is:  ${JSON.stringify(newAccount)}`);
      this.AccountTable.insertData(newAccount, (id: number) => {
        newAccount.id = id;
        this.accounts.push(newAccount);
      });
      this.yPos[week] += newAccount.amount;

      //更新总额
      if(week==0) this.daySum+=newAccount.amount;
      this.monSum += newAccount.amount;

      console.info("###更新yPos");
      console.info("###yPos: "+this.yPos[0] +" || " + this.yPos[1]);
    } else {//修改旧项目
      this.yPos[week] -= this.newAccount.amount;
      this.yPos[week] += newAccount.amount;
      this.AccountTable.updateData(newAccount, () => {
      });
      let list = this.accounts;
      this.accounts = [];
      list[this.index] = newAccount;
      this.accounts = list;
      this.index = -1;
    }
    //刷新曲线
    this.refresh++;
    //调起FormEntryAbility
    postCardAction(this, {
      'action': 'message',
      'params': {
        'info': this.yPos
      }
    });
  }

  @Builder
  common_records(){//用于删除栏目
    Row(){
      Row()
        .width('100%')
        .padding({left:'12vp',right:'12vp'})
      Button(){
        Text('删除')
          .fontSize(15)
          .fontColor(Color.White)
      }
      .type((ButtonType.Normal))
      .height(65)
      .backgroundColor(Color.Red)
    }
  }

  build() {
    Stack() {
      Column() {
        List() {
          ListItem() {
            //标题 & 编辑按钮
            Row() {
              Text(this.title)
                .fontColor(Color.White)
                .height(30)
                .fontSize(30)
                .margin({ left: 24,bottom:'50vp' })
              Image($rawfile('mainPage_editAll.svg'))
                .autoResize(true)
                .size({ width: 30, height: 30 })
                .fillColor(Color.White)
                .margin({ right: 24,bottom:'50vp' })
                .onClick(() => {
                  this.isEditing = !this.isEditing;
                })
                .sharedTransition('editIcon', { duration: 500, curve: Curve.Linear,type:SharedTransitionEffectType.Static})
            }
            .sharedTransition('title', { duration: 500, curve: Curve.Linear})
            .backgroundColor($r('app.color.default_green'))
            .width('100%')
            .height('20%')
            .justifyContent(FlexAlign.SpaceBetween)
            }


          /*图标部分
          ListItem(){
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
              Canvas(this.refresh!=0?this.context:null)
                .width('100%')
                .height('100%')
                .backgroundColor('')
                .onReady(() =>{
                  this.offContext.lineWidth = 3;
                  this.offContext.beginPath();
                  this.offContext.lineCap = 'round';
                  this.offContext.lineJoin = 'round';
                  this.offContext.strokeStyle = '#ECFFE9';

                  this.offContext.moveTo(this.xPos[0], this.yPos[0]);
                  let tot = 0;
                  for(let i = 0; i<7; i++){
                    tot += this.yPos[i];
                  }

                  //画首个点
                  let path: Path2D = new Path2D();
                  path.arc(this.xPos[0],60-this.yPos[0]/tot*60,5,0,360);
                  this.offContext.fillStyle = '#ECFFE9'
                  this.offContext.fill(path);
                  //画其余点
                  this.offContext.moveTo(this.xPos[0], 60-this.yPos[0]/tot*60);
                  for(let i = 1; i<7; i++){
                    let path: Path2D = new Path2D();
                    path.arc(this.xPos[i],60-this.yPos[i]/tot*60,5,0,360);
                    this.offContext.fill(path);
                    this.offContext.lineTo(this.xPos[i], 60-this.yPos[i]/tot*60);
                  }

                  this.offContext.stroke();
                  var image = this.offContext.transferToImageBitmap();
                  this.context.transferFromImageBitmap(image);
                })
            }
            .sharedTransition('curve', { duration: 500, curve: Curve.Linear,type:SharedTransitionEffectType.Static})
          }
          .width('100%')
          .height('8%')
          .position({x:this.refresh-this.refresh,y:'10%'})
          图表部分*/
          /*总消费*/
          ListItem(){
            Column(){
              Text('今天消费: '+ this.daySum + '元')
                .fontColor(Color.White)
                .fontSize('24vp')
              Text('本月消费: '+ this.monSum + '元')
                .fontColor(Color.White)
                .fontSize('24vp')
            }
          }
          .width('100%')
          .height('8%')
          .position({x:this.refresh-this.refresh,y:'10%'})

          //搜索栏
          ListItem(){
            Row(){
              Search({
                value: this.searchText,
                placeholder: CommonConstants.SEARCH_TEXT,
                controller: this.searchController
              })
                .width(CommonConstants.FULL_WIDTH)
                .borderRadius('20vp')
                .borderWidth('1.5vp')
                .borderColor('#33182431')
                .placeholderFont({size:'16vp'})
                .textFont({size:'16vp'})
                .backgroundColor(Color.White)
                .onChange((inputText: string) =>{
                  this.searchText = inputText;
                })
                .onSubmit((inputText: string) => {
                  if (inputText === ''){
                    this.AccountTable.query(0,(result: AccountData[]) => {
                      this.accounts = result;
                    }, true);
                  } else {
                    this.AccountTable.query(Number(inputText), (result: AccountData[]) => {
                      this.accounts = result;
                    }, false);
                  }
                })
            }
            .width('100%')
            .padding({left: '12vp', right: '12vp'})
            .margin({bottom:'8vp'})
          }
          .position({x:0,y:'20%'})
          .sharedTransition('searchCol', { duration: 500, curve: Curve.Linear,type:SharedTransitionEffectType.Static})

          //展示栏
          ListItem(){
              Column(){
                ForEach(this.accounts, (item: AccountData) => {
                  //每一栏记录：
                  this.CustomItem(new showingColumn(item,new Scroller()))

                })
              }
              //Column的属性
              .width('100%')
              .borderRadius('24vp')
              .backgroundColor(Color.White)
          }
          .position({x:0,y:'28%'})
        }

        //在这里补充界面下方的UI
        Row() {
          //“添加”按钮：增加记账记录
          if (!this.isEditing) {
            Button({ type: ButtonType.Capsule, stateEffect: true }) {
              Image($rawfile('mainPage_addIcon.svg'))
                .width('65vp')
                .height('65vp')
                .fillColor($r('app.color.default_green'))
            }
            .width('70vp')
            .height('70vp')
            .markAnchor({ x: '35vp', y: 0 })
            .position({ x: '50%', y: '89%' })
            .backgroundColor(Color.White)
            .onClick(() => {
              this.isInsert = true;
              this.newAccount = {
                id: 0,
                accountType: 0,
                typeText: '',
                amount: 0,
                day: '',
                month: '',
                year: '',
                reminder: ''
              };
              /*获取当前时间*/
              systemDateTime.getDate().then((date)=>{
                console.info('###' + JSON.stringify(date.getDate().toString()));
                this.newAccount.month = date.getMonth().toString();
                this.newAccount.year = date.getFullYear().toString();
                this.newAccount.day = date.getFullYear().toString() + '年'
                                      +date.getMonth().toString() + '月'
                                      +date.getDate().toString() + '日';
              })

              this.dialogController.open();
            })
          }

          //批量删除按钮
          if (this.isEditing) {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($rawfile('mainPage_deleteIcon.svg'))
                .fillColor('#F1F3F5')
                .width('55vp')
                .width('55vp')
            }
            .width('65vp')
            .height('65vp')
            .markAnchor({ x: '34vp', y: 0 })
            .backgroundColor('#C3C3C3')
            .position({ x: '50%', y: '89%' })
            .onClick(() => {
              this.deleteListItem();
            })
          }

          //左1：明细
          Column() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($rawfile('page_detail.svg'))
                .fillColor($r('app.color.default_green'))
                .width('35vp')
                .height('35vp')
            }
            .width('40vp')
            .height('40vp')
            .backgroundColor('#F1F3F5')

            Text('明细')
              .fontColor(Color.Black)
              .fontSize('15vp')
          }
          .position({ x: '4%', y: '92%' })

          //左2：统计
          Column() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($rawfile('page_sum.svg'))
                .fillColor(Color.Gray)
                .width('35vp')
                .height('35vp')
            }
            .width('40vp')
            .height('40vp')
            .backgroundColor('#F1F3F5')
            .onClick(()=>{
              console.info('###Jump to EntryAbility sumPage');
              this.jumpSumPage();
            })

            Text('统计')
              .fontColor(Color.Black)
              .fontSize('15vp')
          }
          .position({ x: '25%', y: '92%' })

          //右1：ToDo List
          Column(){
            Button({ type: ButtonType.Circle, stateEffect: true }){
              Image($rawfile('page_tobuy.svg'))
                .fillColor(Color.Gray)
                .width('40vp')
                .height('40vp')
            }
            .width('40vp')
            .height('40vp')
            .backgroundColor('#F1F3F5')
            .onClick(()=>{
              this.jumpToBuyPage();
            })

            Text('清单')
              .fontColor(Color.Black)
              .fontSize('15vp')
          }
          .position({x:'65%',y:'91.5%'})

          //左2：我的
          Column() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($rawfile('page_me.svg'))
                .fillColor(Color.Gray)
                .width('35vp')
                .height('35vp')
            }
            .width('40vp')
            .height('40vp')
            .backgroundColor('#F1F3F5')
            .onClick(()=>{
              console.info('###Jump to EntryAbility sumPage');
              this.jumpMePage();
            })

            Text('我的')
              .fontColor(Color.Black)
              .fontSize('15vp')
          }
          .position({ x: '85%', y: '91.5%' })


        }//UI-Row
        .sharedTransition('sharedImage1', { duration: 500, curve: Curve.Linear })
        .position({x:'50%',y:'100%'})
      }
      .width('100%')
      .height('100%')
    }

  }
}