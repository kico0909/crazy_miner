import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

import { util } from '@kit.ArkTS'
import { initialize } from '@hw-agconnect/hmcore';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // 初始化云函数SDK
    this.context.resourceManager.getRawFileContent('agconnect-services.json').then(input => {
      let jsonString: string = util.TextDecoder.create('utf-8', {
        ignoreBOM: true
      }).decodeWithStream(input, {
        stream: false
      });
      initialize(this.context, JSON.parse(jsonString));
    })
  }


  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    let context = this.context;
    let resourceManager = context.resourceManager;

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
      // Main window is destroyed, release UI related resources
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
      // Ability has brought to foreground
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
      // Ability has back to background
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
