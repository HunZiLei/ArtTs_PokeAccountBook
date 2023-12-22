import router from '@ohos.router';
import AccountData from '../bean/AccountData';
import { ImageList } from '../bean/AccountList';
import AccountTable from '../database/AccountTable';
import CommonConstants from '../database/CommonConstants';
import Logger from '../utils/Logger';
import { DialogComponent } from './DialogComponent';

@Entry
@Component
struct sumPage {
  /*声明页面的变量*/
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(600, 600, this.settings)

  @State xPos: Array<number> = new Array<number>(30,80,130,180,230,280,330);
  @State params: Object = router.getParams();
  @State yPos: Array<number> = this.params?.['yPos']?this.params?.['yPos']:new Array<number>(1,1,1,1,1,1,1);

  /*页面跳转相关变量*/
  controller?: CustomDialogController;

  /*页面跳转的函数*/
  jumpDetailPage(): void{
    router.pushUrl({
      url: 'pages/Index' // 目标url
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
      url: 'pages/toBuyPage' // 目标url
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
      url: 'pages/mePage' // 目标url
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`###Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('###Invoke pushUrl succeeded.');
    });
  }
  /*跳转函数*/

  // /*页面跳转动画*/
  // pageTransition() {
  //   PageTransitionEnter({ duration: 400, curve: Curve.Ease })
  //     .slide(SlideEffect.Left)
  //   PageTransitionExit({ duration: 400, curve: Curve.Ease })
  // }


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




        /*图表部分*/
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
        /*图表部分*/





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
                .fillColor($r('app.color.default_green'))
                .width('35vp')
                .height('35vp')
            }
            .width('40vp')
            .height('40vp')
            .backgroundColor('#F1F3F5')

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

        }//Row
        .sharedTransition('sharedImage1', { duration: 500, curve: Curve.Linear })
        .position({ x: '50%', y: '100%' })
      }
      .width('100%')
      .height('100%')
    }

  }
}