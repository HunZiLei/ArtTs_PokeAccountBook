import router from '@ohos.router';
import AccountData from '../bean/AccountData';
import { ImageList } from '../bean/AccountList';
import ToBuyData from '../bean/ToBuyData';
import AccountTable from '../database/AccountTable';
import CommonConstants from '../database/CommonConstants';
import Logger from '../utils/Logger';
import { DialogComponent } from './DialogComponent';
import http from '@ohos.net.http'
import Check_Access from '../service/Dectector';
import Request_Permission_From_Users from '../service/Applicant';
import common from '@ohos.app.ability.common';
import { toBuyDialog } from './toBuyDialog';

@Entry
@Component
struct ToBuyPage {
  /*声明页面的变量*/
  //绘画曲线
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(600, 600, this.settings)

  @State xPos: Array<number> = new Array<number>(30,80,130,180,230,280,330);
  @State params: Object = router.getParams();
  @State yPos: Array<number> = this.params?.['yPos']?this.params?.['yPos']:new Array<number>(1,1,1,1,1,1,1);

  @State toBuyList: Array<ToBuyData> = [new ToBuyData('书包',false,null), new ToBuyData('蜡笔',false,new Date('2023-11-26'))
                                ,new ToBuyData('羽毛球拍',false,new Date('2023-11-25')),new ToBuyData('华为手机',true,new Date('2023-11-30'))];
  @State hasChanged: boolean = false;
  @State index: number = -1;//第几个栏目被选中
  @State inserting: boolean = true; //是插入新数据？false则为修改
  @State newToBuy: ToBuyData = {
    thing: '',
    isDone: false,
    ddl: null
  };
  private netContext = getContext(this) as common.UIAbilityContext

  /*页面跳转相关变量*/
  controller?: CustomDialogController;

  /*页面跳转-controller*/
  dialogController: CustomDialogController = new CustomDialogController({
    builder: toBuyDialog({
      isInsert: $inserting,
      newToBuy: $newToBuy,
      confirm: (isInsert: boolean, newToBuy: ToBuyData) => this.accept(isInsert, newToBuy)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  });

  /*数据库相关函数*/
  getRealDate(date: Date): string{
    return date.getFullYear().toString() + '-' + (date.getMonth()+1).toString() +'-' + date.getDate().toString();
  }

  accept(isInsert: boolean, newToBuy: ToBuyData): void {
    if (isInsert) {//插入数据项
      this.toBuyList.push(newToBuy);
    } else {
      let list = this.toBuyList;
      this.toBuyList = [];
      list[this.index] = newToBuy;
      this.toBuyList = list;
      this.index = -1;
    }
  }

  selectListItem(item: ToBuyData) {
    this.inserting = false;
    //记录坐标
    this.index = this.toBuyList.indexOf(item);
    //刷新newToBuy
    this.newToBuy = this.toBuyList[this.index];
  }

  /*网络请求相关*/
  detect(): boolean{
    let res = Check_Access();
    if(res){
      return true;
    }else{
      return false;
    }
  }
  //申请获取网络权限
  async apply(){
    let res = await Request_Permission_From_Users(this.netContext)
  }

  /*页面跳转的函数*/
  jumpDetailPage(): void{
    console.info("###ToBuyPage-yPos: "+ this.yPos[0] + "-" + this.yPos[1]);
    router.pushUrl({
      url: 'pages/Index', // 目标url
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

  jumpSumPage(): void{
    console.info("###ToBuyPage-yPos: "+ this.yPos[0] + "-" + this.yPos[1]);
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
    console.info("###ToBuyPage-yPos: "+ this.yPos[0] + "-" + this.yPos[1]);
    router.pushUrl({
      url: 'pages/tuBuyPage', // 目标url
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
    console.info("###ToBuyPage-yPos: "+ this.yPos[0] + "-" + this.yPos[1]);
    router.pushUrl({
      url: 'pages/mePage' // 目标url
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }

  jumpWebPage(thing: string): void{
    router.pushUrl({
      url: 'pages/webPage', // 目标url
      params:{
        name: thing
      }
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }

  jumpWebPage_jing(thing: string): void{
    router.pushUrl({
      url: 'pages/webPage_jing', // 目标url
      params:{
        name: thing
      }
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }


  build() {
    Stack() {
      Column() {
        //标题 & 编辑按钮
        Row() {
          Text($r('app.string.mainPage_title'))
            .fontColor(Color.White)
            .height(30)
            .fontSize(30)
            .margin({ left: 24,bottom:'50vp' })
        }
        .sharedTransition('title', { duration: 500, curve: Curve.Linear})
        .backgroundColor($r('app.color.default_green'))
        .position({x:0,y:0})
        .width('100%')
        .height('20%')
        .justifyContent(FlexAlign.SpaceBetween)

        /*图表部分
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Canvas(this.context)
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
                //this.offContext.quadraticCurveTo(this.xPos[i+1],this.yPos[i+1],this.xPos[i+1],this.yPos[i+1])
              }

              this.offContext.stroke();
              var image = this.offContext.transferToImageBitmap();
              this.context.transferFromImageBitmap(image);
            })
        }
        .width('100%')
        .height('8%')
        .position({x:0,y:'10%'})
        图表部分*/

        //待办事项的展示
        List(){
          ForEach(this.toBuyList, (item:ToBuyData)=> {
            ListItem() {
              Row() {
                //勾选框
                Toggle({ type: ToggleType.Checkbox, isOn: item.isDone ? true : false })
                  .width('25vp')
                  .selectedColor('#6E948A')
                  .onChange((isOn:boolean) => {
                    if(isOn){
                      item.isDone = true;
                    }
                  })

                //空白符
                Blank()
                  .layoutWeight(1)

                //待购商品
                Text(item.thing.length>20? item.thing.substring(0,20)+'...':item.thing)
                  .fontColor(item.isDone && this.hasChanged? Color.Gray : Color.Black)
                  .fontSize('20vp')

                //空白符
                Blank()
                  .layoutWeight(18)

                //截止时间
                if(item.ddl != null){
                  //Text(item.ddl.toDateString())
                  Text(((item.ddl.getTime()-new Date().getTime())/ (1000 * 60 * 60 * 24))>6? this.getRealDate(item.ddl):((item.ddl.getTime()-new Date().getTime())/ (1000 * 60 * 60 * 24)).toFixed(1).toString() + '天')
                    .fontSize('20vp')
                    .fontColor(((item.ddl.getTime()-new Date().getTime())/ (1000 * 60 * 60 * 24)) > 5? $r('app.color.default_green'):Color.Red)
                    .markAnchor({x:'20vp'})
                }

                Blank()
                  .layoutWeight(1)

                //淘宝按钮
                Button({type: ButtonType.Capsule, stateEffect:true}){
                  Image($rawfile('toBuyPage_taoBao.svg'))
                    .width('40vp')
                    .height('40vp')
                    .fillColor(item.isDone && this.hasChanged? Color.Gray:$r('app.color.default_green'))
                }
                .markAnchor({x:'20vp',y:0})
                .width('40vp')
                .height('40vp')
                .backgroundColor(Color.White)
                .onClick(()=>{
                  //检查网络权限
                  if(this.detect()){
                    this.apply();
                    console.info('###Try to get web');
                  }
                  //跳转到webPage
                  this.jumpWebPage(item.thing);
                })

                //京东按钮
                Button({type: ButtonType.Capsule, stateEffect:true}){
                  Image($rawfile('toBuyPage_jingdong.svg'))
                    .width('40vp')
                    .height('40vp')
                    .fillColor(item.isDone && this.hasChanged? Color.Gray:$r('app.color.default_green'))
                }
                .markAnchor({x:'20vp',y:0})
                .width('40vp')
                .height('40vp')
                .backgroundColor(Color.White)
                .onClick(()=>{
                  //检查网络权限
                  if(this.detect()){
                    this.apply();
                  }
                  //跳转到webPage
                  this.jumpWebPage_jing(item.thing);
                })

              }
              .onClick(()=>{
                this.selectListItem(item);
                this.dialogController.open();
              })
            }
          })
        }
        .position({x:'1%',y:'20%'})



        //在这里补充界面下方的UI
        Row() {
          //“添加”按钮：增加记账记录
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
            this.dialogController.open();
            try {
              //this.isInsert = true;
              this.newToBuy = new ToBuyData(null,false,null);
            } catch (e:any){
              console.info('###'+e)
            }
          })

          //左1：明细
          Column() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($rawfile('page_detail.svg'))
                .fillColor(Color.Gray)
                .width('35vp')
                .height('35vp')
            }
            .width('40vp')
            .height('40vp')
            .backgroundColor('#F1F3F5')
            .onClick(()=>{
              this.jumpDetailPage();
            })

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
                .fillColor($r('app.color.default_green'))
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
          .position({x:'65%',y:'91%'})

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
          .position({ x: '85%', y: '91%' })

        }//Row-UI
        .sharedTransition('sharedImage1', { duration: 500, curve: Curve.Linear })
        .position({ x: '50%', y: '100%' })
      }
      .width('100%')
      .height('100%')
    }

  }
}