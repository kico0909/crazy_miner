import router from '@ohos.router'
// import { AppCopyRightInfo } from '../common/values'
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {

  onPageShow(): void {

  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.MountainMiner'))
          .width('80%').offset({
          top: '-15%'
        })

        Text($r('app.string.app_full_name'))
          .fontColor('#fff').offset({  top: '-10%' })
          .fontSize('30fp')

        Button('进入游戏')
          .offset({
            top: '10%'
          })
          .onClick(() => {
            console.log(`click button!!!`)
            router.pushUrl({
              url:'pages/Game'
            })
          })
      }
      .width('100%').height('90%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text($r('app.string.app_copy_right'))
          .fontColor('#fff')
      }
      .width('100%').height('10%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

    }
    .width('100%').height('100%')
    .backgroundColor($r('app.color.start_window_background'))
    .alignItems(HorizontalAlign.Center)
  }
}
