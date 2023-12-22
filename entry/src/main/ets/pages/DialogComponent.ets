/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import prompt from '@ohos.promptAction';
import AccountData from '../bean/AccountData';
import AccountItem from '../bean/AccountItem';
import CommonConstants from '../database/CommonConstants';
import { PayList, EarnList } from '../bean/AccountList';
import AccountTable from '../database/AccountTable';
import systemDateTime from '@ohos.systemDateTime';

@CustomDialog
export struct DialogComponent {
  controller?: CustomDialogController;
  @Link isInsert: boolean;
  @Link newAccount: AccountData;
  confirm?: (isInsert: boolean, newAccount: AccountData) => void;//点击确定时的逻辑
  private scroller: Scroller = new Scroller();
  private inputAmount = '';
  private inputRemind = '';
  private currDate = '';

  @State payList: Array<AccountItem> = PayList;
  @State earnList: Array<AccountItem> = EarnList;
  @State bgColor: string = '';
  @State curIndex: number = 0;
  @State curType: string = '';
  @State curDay: string = '';
  @State curYear: string = '';
  @State curMonth: string = '';
  @State curReminder: string = '';
  selected_date: Date;

  @State drag: boolean = false;

  @Builder
  TabBuilder(index: number) {
    Column() {
      Text(index === 0 ? $r('app.string.pay_text') : $r('app.string.income_text'))
        .fontSize('16vp')
        .fontColor(this.curIndex === index ? '#018F90' : Color.Gray)
    }
    .width('48vp')
    .padding({ top: '17vp', bottom: '8vp' })
    .margin({ bottom: '8vp' })
    .border(this.curIndex === index ? {
      width: { bottom: '2vp' },
      color: '#018F90'
    } : { color: Color.White })
  }

  aboutToAppear() {
    this.inputAmount = this.newAccount.amount.toString();
    this.curIndex = this.newAccount.accountType;
    this.curType = this.newAccount.typeText;
  }

  selectAccount(item: AccountItem) {
    this.newAccount.accountType = item.accountType;
    this.newAccount.typeText = item.typeText;
    this.curType = item.typeText;
  }

  build() {
    Column() {
      Image($rawfile('half.png'))
        .width('64vp')
        .height('24vp')
        .onClick(() => {
          this.controller?.close();
        })

      Tabs({ barPosition: BarPosition.Start, index: this.curIndex }) {

        //支出
        TabContent() {
          Scroll(this.scroller) {
            Row() {
              ForEach(this.payList, (item: AccountItem) => {
                Column() {
                  Image(item.icon)
                    .width($r('app.float.image_size'))
                    .aspectRatio(CommonConstants.FULL_SIZE)
                    .fillColor(this.curType === item.typeText ? Color.White:'#018F90');

                  Text(item.typeText)
                    .fontSize($r('app.float.font_size_S'))
                    .fontColor(this.curType === item.typeText ? Color.White : '#018F90')
                    .margin({ top: $r('app.float.edge_size_S') })
                }
                .width($r('app.float.component_size_LP'))
                .aspectRatio(CommonConstants.FULL_SIZE)
                .padding({ top: $r('app.float.edge_size_M') })
                .margin({ top: $r('app.float.edge_size_MP'), left: $r('app.float.edge_size_M') })
                .align(Alignment.TopStart)
                .backgroundColor(this.curType === item.typeText ? '#018F90' : '#FFF1F3F5')
                .borderRadius($r('app.float.radius_size_S'))
                .onClick(() => {
                  this.selectAccount(item);
                })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }//支出
        .tabBar(this.TabBuilder(0))
        .margin({ bottom: $r('app.float.edge_size_LP') })

        //收入
        TabContent() {
          Scroll(this.scroller) {
            Row() {
              ForEach(this.earnList, (item: AccountItem) => {
                Column() {
                  Image(item.icon)
                    .width($r('app.float.image_size'))
                    .aspectRatio(CommonConstants.FULL_SIZE)
                    .fillColor(this.curType === item.typeText ? Color.White:'#018F90');

                  Text(item.typeText)
                    .fontSize($r('app.float.font_size_S'))
                    .fontColor(this.curType === item.typeText ? Color.White : '#018F90')
                    .margin({ top: $r('app.float.edge_size_S') })
                }
                .width($r('app.float.component_size_LP'))
                .aspectRatio(CommonConstants.FULL_SIZE)
                .padding({ top: $r('app.float.edge_size_M') })
                .margin({ top: $r('app.float.edge_size_MP'), left: $r('app.float.edge_size_M') })
                .align(Alignment.TopStart)
                .backgroundColor(this.curType === item.typeText ? '#018F90' : '#FFF1F3F5')
                .borderRadius($r('app.float.radius_size_S'))
                .onClick(() => {
                  this.selectAccount(item);
                })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }//收入
        .tabBar(this.TabBuilder(1))
        .margin({ bottom: $r('app.float.edge_size_LP') })

      }//Tab
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.TABS_HEIGHT)
      .vertical(false)
      .barMode(BarMode.Fixed)
      .onChange((index) => {
        this.curIndex = index;
      })

      Column() {
        Text($r('app.string.count_text'))
          .width(CommonConstants.FULL_WIDTH)
          .fontSize($r('app.float.font_size_MP'))
          .fontColor(Color.Black)

        Column() {
          //金额
          TextInput({
            placeholder: $r('app.string.input_text'),
            text: this.newAccount.amount === 0 ? this.inputAmount : this.newAccount.amount.toString()
          })
            .padding({ left: CommonConstants.MINIMUM_SIZE })
            .borderRadius(CommonConstants.MINIMUM_SIZE)
            .backgroundColor(Color.White)
            .type(InputType.Number)
            .onChange((value: string) => {
              this.inputAmount = value;
            })
            .onSubmit(() =>{
              this.newAccount.amount = Number.parseInt(this.inputAmount);
            })
        }
        .height($r('app.float.component_size_MP'))
        .padding({ top: $r('app.float.edge_size_MPM'), bottom: $r('app.float.edge_size_MM') })
        .borderWidth({ bottom: CommonConstants.FULL_SIZE })
        .borderColor('#33182431')
      }//金额
      .width(CommonConstants.FULL_WIDTH)
      .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })

      //日期or时间
      Text('时间')
      .width('100%')
      .fontSize('20vp')
      .fontColor(Color.Black)
        .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M'),top: '5vp' })

      Column(){
        Text(this.newAccount.day)
          .padding({left:CommonConstants.MINIMUM_SIZE})
          .borderRadius(CommonConstants.MINIMUM_SIZE)
          .backgroundColor('#F1F3F5')
          .fontSize('20vp')
          .onClick(()=>{
            let cur_date = new Date();
            this.selected_date = cur_date;
            DatePickerDialog.show({
              start: new Date("2022-1-1"),
              end: new Date("2024-1-1"),
              selected: this.selected_date,
              onAccept: (value: DatePickerResult) => {
                this.selected_date.setFullYear(value.year, value.month, value.day);
                this.newAccount.day = value.year.toString() + '年'
                + (value.month + 1).toString() + '月'
                + value.day.toString() + '日';
                this.newAccount.year = value.year.toString();
                this.newAccount.month = value.year.toString() + '-' + (value.month + 1).toString();
                this.newAccount.day = value.year.toString() + '年' + (value.month + 1).toString() + '月' + value.day.toString() + '日';
                console.info("###DatePickerDialog Accept: " + JSON.stringify(value));
              },
              onCancel: () => {
                console.info("###DatePickerDialog: Cancel()");
              },
              onChange: () => {
                console.info("###DatePickerDialog: onChange()");
              }
            })
          })
      }//选择日期
      .height('50vp')
      .width('100%')
      .padding({top:'15vp', bottom: '11vp'})
      .borderWidth({bottom:CommonConstants.FULL_SIZE})
      .borderColor('#3348478C')

      //备注
      Column(){
        Text('备注')
          .width(CommonConstants.FULL_WIDTH)
          .fontSize($r('app.float.font_size_MP'))
          .fontColor(Color.Black)

        TextInput({
          placeholder: '备注是...',
          text: this.newAccount.reminder === '' ? this.inputRemind : this.newAccount.reminder
        })
          .padding({ left: CommonConstants.MINIMUM_SIZE })
          .borderRadius(CommonConstants.MINIMUM_SIZE)
          .backgroundColor(Color.White)
          .type(InputType.Normal)
          .onChange((value: string) => {
            this.inputRemind = value;
          })
          .onSubmit(() =>{
            this.newAccount.reminder = this.inputRemind;
          })
      }
      .width(CommonConstants.FULL_WIDTH)
      .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })

      //确定
      Column() {
        Button() {
          Text($r('app.string.confirm_text'))
            .fontSize($r('app.float.font_size_M'))
            .fontColor(Color.White)
        }
        .width(CommonConstants.FULL_WIDTH)
        .height($r('app.float.component_size_M'))
        .onClick(() => {
          if (this.newAccount.typeText === '' || this.curIndex !== this.newAccount.accountType) {
            prompt.showToast({ message: CommonConstants.TOAST_TEXT_1, bottom: CommonConstants.PROMPT_BOTTOM });
          } else {
            let regex: RegExp = new RegExp('[1-9][0-9]*');
            let matchValue: Array<string> | null = this.inputAmount.match(regex);
            if (matchValue !== null && matchValue[0] === this.inputAmount) {
              this.newAccount.amount = Number(this.inputAmount);
              this.confirm && this.confirm(this.isInsert, this.newAccount);
              this.controller?.close();
            } else {
              prompt.showToast({ message: CommonConstants.TOAST_TEXT_2, bottom: CommonConstants.PROMPT_BOTTOM });
            }
          }
        })
      }
      .layoutWeight(CommonConstants.FULL_SIZE)
      .padding({
        bottom: $r('app.float.font_size_L'),
        left: $r('app.float.font_size_L'),
        right: $r('app.float.font_size_L')
      })
      .justifyContent(FlexAlign.End)
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.DIALOG_HEIGHT)
    .borderRadius({ topLeft: $r('app.float.font_size_L'), topRight: $r('app.float.font_size_L') })
    .backgroundColor(Color.White)
    .align(Alignment.BottomEnd)
  }
}