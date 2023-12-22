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
import ToBuyData from '../bean/ToBuyData';

@CustomDialog
export struct toBuyDialog {
  controller?: CustomDialogController;
  @Link isInsert: boolean;
  @Link newToBuy: ToBuyData;
  confirm?: (isInsert: boolean, newToBuy: ToBuyData) => void;//点击确定时的逻辑
  private inputThing = '';

  @State timeSelected: string = '今天';

  selected_date: Date;

  getRealDate(date: Date): string{
    return date.getFullYear().toString() + '-' + (date.getMonth()+1).toString() +'-' + date.getDate().toString();
  }

  @Builder
  TabBuilder(index: number) {
    Column() {
      Text('待购清单')
        .fontSize('16vp')
        .fontColor('#018F90')
    }
    .width('48vp')
    .padding({ top: '17vp', bottom: '8vp' })
    .margin({ bottom: '8vp' })
    .border({
      width: { bottom: '2vp' },
      color: '#018F90'
    })
  }

  build() {
    Column() {
      //取消栏
      Image($rawfile('half.png'))
        .width('64vp')
        .height('24vp')
        .onClick(() => {
          this.controller?.close();
        })

      //日期和时间
      Column() {
        Text('截止时间')
          .width('100%')
          .fontSize('20vp')
          .fontColor(Color.Black)
          .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M'),top: '5vp' })
          .margin({bottom:'5vp'})

        Row() {
          //今天
          Text('今天')
            .onClick(()=>{
              this.timeSelected = '今天';
              this.newToBuy.ddl = new Date();
            })
            .fontColor(Color.White)
            .fontSize('25vp')
            .backgroundColor(this.timeSelected == '今天'? $r('app.color.default_green'):'#C3C3C3')
            .margin({right:'5vp'})

          //明天
          Text('明天')
            .fontColor(Color.White)
            .fontSize('25vp')
            .onClick(()=>{
              this.timeSelected = '明天';
              this.newToBuy.ddl = new Date();
            })
            .backgroundColor(this.timeSelected == '明天'? $r('app.color.default_green'):'#C3C3C3')
            .margin({right:'5vp'})

          //自己选时间
          Text(this.getRealDate(this.newToBuy.ddl===null?new Date():this.newToBuy.ddl))
            .fontColor(Color.White)
            .fontSize('25vp')
            .onClick(() => {
              this.timeSelected = '任意';
              let cur_date = new Date();
              this.selected_date = cur_date;
              DatePickerDialog.show({
                start: new Date("2022-1-1"),
                end: new Date("2024-1-1"),
                selected: this.selected_date,
                //确认时
                onAccept: (value: DatePickerResult) => {
                  this.selected_date.setFullYear(value.year, value.month, value.day);
                  this.newToBuy.ddl = new Date(value.year.toString() + '-' + (value.month + 1).toString() + '-' + value.day.toString() + '-');
                }
              })
            })
            .backgroundColor(this.timeSelected=='任意'? $r('app.color.default_green') : '#C3C3C3')
        }
      }

      Blank()
      .layoutWeight(1)

      //商品
      Column(){
        Text('商品')
          .width(CommonConstants.FULL_WIDTH)
          .fontSize($r('app.float.font_size_MP'))
          .fontColor(Color.Black)

        TextInput({
          placeholder: '准备买什么...',
          text: this.newToBuy.thing === '' ? this.inputThing : this.newToBuy.thing
        })
          .padding({ left: CommonConstants.MINIMUM_SIZE })
          .borderRadius(CommonConstants.MINIMUM_SIZE)
          .backgroundColor(Color.White)
          .type(InputType.Normal)
          .onChange((value: string) => {
            this.inputThing = value;
            this.newToBuy.thing = this.inputThing;
          })
          .onSubmit(() =>{
            this.newToBuy.thing = this.inputThing;
          })
      }
      .width(CommonConstants.FULL_WIDTH)
      .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })

      Blank()
      .layoutWeight(4)

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
          if (this.newToBuy.thing === '') {
            prompt.showToast({ message: CommonConstants.TOAST_NULL_BUY, bottom: CommonConstants.PROMPT_BOTTOM });
          } else {
            this.confirm && this.confirm(this.isInsert, this.newToBuy);
            this.controller?.close();
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