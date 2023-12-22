//导入程序访问控制管理模块
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl'

//导入common
import common from '@ohos.app.ability.common';

//定义待动态申请的权限列表
const permissionsList: Array<Permissions> = ['ohos.permission.INTERNET']

const APPROVAL:number = 0

//模块的日志标签
const TAG = '------[Applicant] '

//默认导出的模块接口
export default async function Request_Permission_From_Users(context:common.UIAbilityContext){

  //预定义函数执行结果的状态
  let isFinished:boolean = false

  //创建AtManager实例
  let atManager = abilityAccessCtrl.createAtManager()

  //等待程序访问控制模块完成权限请求的异步操作，完成后根据返回结果执行then()或catch()
  await atManager.requestPermissionsFromUser(context, permissionsList).then((result)=>{

    //将API返回的数据存储到变量grantStatus中
    let grantStatus: Array<number> = result.authResults

    //判断用户是否提供所有相关权限
    for(let i = 0 ; i < grantStatus.length ; i++){
      if(grantStatus[i] === APPROVAL){   //用户提供所有权限， ===指的是全等
        console.info(TAG+'###Succeed! Obtain all the permissions')
        isFinished = true   //将函数执行结果的状态设置为true
      }else{   //用户未提供所有权限
        console.error(TAG+'###User denies providing the permissions')
      }
    }
  }).catch((err)=>{
    console.error(TAG+`Request permission failed, code is ${err.code}, message is ${err.message}`)
  })

  return isFinished

}