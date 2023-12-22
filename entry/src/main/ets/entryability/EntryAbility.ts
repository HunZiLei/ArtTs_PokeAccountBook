import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';

import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formProvider from '@ohos.app.form.formProvider';

let selectPage: string = "";
let currentWindowStage: window.WindowStage | null = null;

export default class EntryAbility extends FormExtensionAbility {
  /*在这里对目标页面进行调整*/
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    if(want.parameters.params !== undefined){
      let params = JSON.parse(want.parameters.params);
      console.info("onCreate router targetPage:" + params.targetPage);
      selectPage = params.targetPage;
    }
  }

  // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.info("onNewWant want:" + JSON.stringify(want));
    if (want.parameters?.params !== undefined) {
      let params: Record<string, string> = JSON.parse(want.parameters?.params.toString());
      console.info("onNewWant router targetPage:" + params.targetPage);
      selectPage = params.targetPage;
    }
    if (currentWindowStage != null) {
      this.onWindowStageCreate(currentWindowStage);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    let targetPage: string;
    // 根据传递的targetPage不同，选择拉起不同的页面
    switch (selectPage) {
      case 'sumPage':
        targetPage = 'pages/sumPage';
        break;
      case 'detailPage':
        targetPage = 'pages/Index';
        break;
      default:
        targetPage = 'pages/Index';
    }
    if (currentWindowStage === null) {
      currentWindowStage = windowStage;
    }
    windowStage.loadContent(targetPage, (err,data) => {
      if (err && err.code) {
        console.info('###Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
    });
  }
  /*以上是页面跳转的部分*/

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onFormEvent(formId, message){
    // Called when a specified message event defined by the form provider is triggered.
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    let formData = {
      'title': 'Poke AccountBook',
    };
    console.info("###FormID: "+formId + " || " + "message: "+message?.['newCurve'])
    let formInfo = formBindingData.createFormBindingData(formData)
    formProvider.updateForm(formId, formInfo).then((data) => {
      console.info('FormAbility updateForm success.' + JSON.stringify(data));
    }).catch((error) => {
      console.error('FormAbility updateForm failed: ' + JSON.stringify(error));
    })
    console.info('####[EntryFormAbility] onFormEvent');
  }

}


