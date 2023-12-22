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

import relationalStore from '@ohos.data.relationalStore';
import AccountData from '../bean/AccountData';
import CommonConstants from '../database/CommonConstants';
import Rdb from '../database/Rdb';

export default class AccountTable {
  private accountTable = new Rdb(CommonConstants.ACCOUNT_TABLE.tableName, CommonConstants.ACCOUNT_TABLE.sqlCreate,
    CommonConstants.ACCOUNT_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }

  insertData(account: AccountData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    this.accountTable.insertData(valueBucket, callback);
  }

  deleteData(account: AccountData, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    predicates.equalTo('id', account.id);
    this.accountTable.deleteData(predicates, callback);
  }

  updateData(account: AccountData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    predicates.equalTo('id', account.id);
    this.accountTable.updateData(predicates, valueBucket, callback);
  }

  query(amount: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.accountTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: AccountData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: AccountData = {
            id: 0, accountType: 0, typeText: '', amount: 0,day: '01', year: '2023',month:'01',reminder:'无'
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.accountType = resultSet.getDouble(resultSet.getColumnIndex('accountType'));
          tmp.typeText = resultSet.getString(resultSet.getColumnIndex('typeText'));
          tmp.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  //格式：xxx-xx
  queryMonth(date: string, callback:Function, isAll: boolean = true){
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    if(!isAll){
      predicates.equalTo('month',date);
    }
    this.accountTable.query(predicates, (resultSet: relationalStore.ResultSet)=>{
      let count: number = resultSet.rowCount;
      if(count ===0 || typeof count === 'string'){
        //若结果为0：返回空列表
        console.log(CommonConstants.TABLE_TAG.toString() + 'Query no result');
        callback([]);
      }else{
        resultSet.goToFirstRow();
        const result: AccountData[] = [];
        for(let i = 0; i< count; i++){
          //使用临时变量存储数据
          let tmp: AccountData = {
            id: 0, accountType:0, typeText:'', amount:0, day:'', month:'', reminder:'',year:''
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.accountType = resultSet.getDouble(resultSet.getColumnIndex('accountType'));
          tmp.typeText = resultSet.getString(resultSet.getColumnIndex('typeText'));
          tmp.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          tmp.day = resultSet.getString(resultSet.getColumnIndex('day'));
          tmp.year = resultSet.getString(resultSet.getColumnIndex('year'));
          tmp.month = resultSet.getString(resultSet.getColumnIndex('month'));
          tmp.reminder = resultSet.getString(resultSet.getColumnIndex('reminder'));
          //赋值
          result[i] = tmp;
          //跳转到结果的下一项
          resultSet.goToNextRow();
        }
        //返回结果
        callback(result);
      }
    })
  }

  //格式：xxx
  queryYear(date: string, callback:Function, isAll: boolean = true){
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    if(!isAll){
      predicates.equalTo('year',date);
    }
    this.accountTable.query(predicates, (resultSet: relationalStore.ResultSet)=>{
      let count: number = resultSet.rowCount;
      if(count ===0 || typeof count === 'string'){
        //若结果为0：返回空列表
        console.log(CommonConstants.TABLE_TAG.toString() + 'Query no result');
        callback([]);
      }else{
        resultSet.goToFirstRow();
        const result: AccountData[] = [];
        for(let i = 0; i< count; i++){
          //使用临时变量存储数据
          let tmp: AccountData = {
            id: 0, accountType:0, typeText:'', amount:0, day:'', month:'', reminder:'',year:''
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.accountType = resultSet.getDouble(resultSet.getColumnIndex('accountType'));
          tmp.typeText = resultSet.getString(resultSet.getColumnIndex('typeText'));
          tmp.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          tmp.day = resultSet.getString(resultSet.getColumnIndex('day'));
          tmp.year = resultSet.getString(resultSet.getColumnIndex('year'));
          tmp.month = resultSet.getString(resultSet.getColumnIndex('month'));
          tmp.reminder = resultSet.getString(resultSet.getColumnIndex('reminder'));
          //赋值
          result[i] = tmp;
          //跳转到结果的下一项
          resultSet.goToNextRow();
        }
        //返回结果
        callback(result);
      }
    })
  }

  queryType(text: string, callback:Function, isAll:boolean = true){
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    if(!isAll){
      predicates.like('typeText', '%'+text+'%').or().like('reminder', '%'+text+'%');
    }
    this.accountTable.query(predicates, (resultSet: relationalStore.ResultSet)=>{
      let count: number = resultSet.rowCount;
      if(count ===0 || typeof count === 'string'){
        //若结果为0：返回空列表
        console.log(CommonConstants.TABLE_TAG.toString() + 'Query no result');
        callback([]);
      }else{
        resultSet.goToFirstRow();
        const result: AccountData[] = [];
        for(let i = 0; i< count; i++){
          //使用临时变量存储数据
          let tmp: AccountData = {
            id: 0, accountType:0, typeText:'', amount:0, day:'', month:'', reminder:'',year:''
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.accountType = resultSet.getDouble(resultSet.getColumnIndex('accountType'));
          tmp.typeText = resultSet.getString(resultSet.getColumnIndex('typeText'));
          tmp.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          tmp.day = resultSet.getString(resultSet.getColumnIndex('day'));
          tmp.year = resultSet.getString(resultSet.getColumnIndex('year'));
          tmp.month = resultSet.getString(resultSet.getColumnIndex('month'));
          tmp.reminder = resultSet.getString(resultSet.getColumnIndex('reminder'));
          //赋值
          result[i] = tmp;
          //跳转到结果的下一项
          resultSet.goToNextRow();
        }
        //返回结果
        callback(result);
      }
    })
  }
}

function generateBucket(account: AccountData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.accountType = account.accountType;
  obj.typeText = account.typeText;
  obj.amount = account.amount;
  obj.day = account.day;
  obj.year = account.year;
  obj.month = account.month;
  return obj;
}