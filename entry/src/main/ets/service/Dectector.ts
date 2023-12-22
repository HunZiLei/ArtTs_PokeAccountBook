//导入程序访问控制管理模块
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';

//导入包管理模块
import bundleManager from '@ohos.bundle.bundleManager';

///定义待检测的权限列表
const permissionsList: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION']     //权限数据的列表

//模块的日志标签
const TAG = '------[Detector] '

const APPROVAL:number = 0

//默认导出的模块接口
export default async function Check_Access(){

  //创建AtManager实例
  let atManager = abilityAccessCtrl.createAtManager()

  //定义局部变量grantStatus
  let grantStatus:abilityAccessCtrl.GrantStatus

  //定义局部变量tokenId
  let tokenId:number

  try{

    //等待包管理模块获取本模块所在的包的BundleInfo
    let bundleInfo:bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    //获取上述BundleInfo中携带的ApplicationInfo
    let appInfo:bundleManager.ApplicationInfo = bundleInfo.appInfo
    //获上述ApplicationInfo携带的accessTokenId
    tokenId = appInfo.accessTokenId

  }catch (err){
    console.error(TAG+`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`)
  }

  try{
    //利用AtManager实例检查是否已获得所需权限
    grantStatus = await atManager.checkAccessToken(tokenId,permissionsList[0])
  }catch (err){
    console.error(TAG+`checkAccessToken failed, code is ${err.code}, message is ${err.message}`)
  }

  //根据不同的检查结果做不同的输出
  if(grantStatus == APPROVAL){
    console.info(TAG+'Accessible')
    return true
  }else {
    console.error(TAG+'Inaccessible')
    return false
  }

}