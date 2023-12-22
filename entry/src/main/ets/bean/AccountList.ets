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

import AccountItem from './AccountItem';

export const PayList: Array<AccountItem> = [
  {
    icon: $rawfile('foods.svg'),
    iconSelected: $rawfile('foods.svg'),
    accountType: 0,
    typeText: '吃饭'
  },
  {
    icon: $rawfile('snacks.svg'),
    iconSelected: $rawfile('snacks.svg'),
    accountType: 0,
    typeText: '零食'
  },
  {
    icon: $rawfile('fuel.svg'),
    iconSelected: $rawfile('fuel.svg'),
    accountType: 0,
    typeText: '汽车加油'
  },
  {
    icon: $rawfile('travel.svg'),
    iconSelected: $rawfile('travel.svg'),
    accountType: 0,
    typeText: '旅游'
  },
  {
    icon: $rawfile('games.svg'),
    iconSelected: $rawfile('games.svg'),
    accountType: 0,
    typeText: '娱乐'
  },
  {
    icon: $rawfile('pets.svg'),
    iconSelected: $rawfile('pets.svg'),
    accountType: 0,
    typeText: '宠物'
  },
  {
    icon: $rawfile('competition.svg'),
    iconSelected: $rawfile('competition.svg'),
    accountType: 0,
    typeText: '竞赛'
  },
  {
    icon: $rawfile('digit.svg'),
    iconSelected: $rawfile('digit.svg'),
    accountType: 0,
    typeText: '数码'
  },
  {
    icon: $rawfile('festival.svg'),
    iconSelected: $rawfile('festival.svg'),
    accountType: 0,
    typeText: '节日'
  },
  {
    icon: $rawfile('gift.svg'),
    iconSelected: $rawfile('gift.svg'),
    accountType: 0,
    typeText: '礼物'
  },
  {
    icon: $rawfile('sneaker.svg'),
    iconSelected: $rawfile('sneaker.svg'),
    accountType: 0,
    typeText: '鞋子'
  },
  {
    icon: $rawfile('fruit.svg'),
    iconSelected: $rawfile('fruit.svg'),
    accountType: 0,
    typeText: '水果'
  },
  {
    icon: $rawfile('workout.svg'),
    iconSelected: $rawfile('workout.svg'),
    accountType: 0,
    typeText: '健身'
  },
  {
    icon: $rawfile('PE.svg'),
    iconSelected: $rawfile('PE.svg'),
    accountType: 0,
    typeText: '运动'
  },
  {
    icon: $rawfile('badminton.svg'),
    iconSelected: $rawfile('badminton.svg'),
    accountType: 0,
    typeText: '羽毛球'
  },
  {
    icon: $rawfile('social.svg'),
    iconSelected: $rawfile('social.svg'),
    accountType: 0,
    typeText: '社交'
  }
]

export const EarnList: Array<AccountItem> = [
  {
    icon: $rawfile('income.svg'),
    iconSelected: $rawfile('income.svg'),
    accountType: 1,
    typeText: '工作收入'
  },
  {
    icon: $rawfile('invest.svg'),
    iconSelected: $rawfile('invest.svg'),
    accountType: 1,
    typeText: '投资'
  },
  {
    icon: $rawfile('awards.svg'),
    iconSelected: $rawfile('awards.svg'),
    accountType: 1,
    typeText: '奖金'
  },
  {
    icon: $rawfile('extraIncome.svg'),
    iconSelected: $rawfile('extraIncome.svg'),
    accountType: 1,
    typeText: '外快'
  }
]

export const ImageList: Record<string,Resource> = {
  '吃饭': $rawfile('foods.svg'),
  '零食': $rawfile('snacks.svg'),
  '汽车加油': $rawfile('fuel.svg'),
  '旅游': $rawfile('travel.svg'),
  '娱乐': $rawfile('games.svg'),
  '宠物': $rawfile('pets.svg'),
  '竞赛': $rawfile('competition.svg'),
  '数码': $rawfile('digit.svg'),
  '节日': $rawfile('festival.svg'),
  '礼物': $rawfile('gift.svg'),
  '鞋子': $rawfile('sneaker.svg'),
  '水果': $rawfile('fruit.svg'),
  '健身': $rawfile('workout.svg'),
  '运动': $rawfile('PE.svg'),
  '羽毛球': $rawfile('badminton.svg'),
  '社交': $rawfile('social.svg'),
  '工作收入': $rawfile('income.svg'),
  '投资': $rawfile('invest.svg'),
  '奖金': $rawfile('awards.svg'),
  '外快': $rawfile('extraIncome.svg')
}