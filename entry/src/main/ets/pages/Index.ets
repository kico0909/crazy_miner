import router from '@ohos.router'

import { initDB } from '../common/game/core'

@Entry
@Component
struct Index {

  @State disable: boolean = true

  onPageShow(): void {

  }

  onDidBuild(): void {
    console.log('启动界面构建完成,执行初始化')
    initDB(() => {
      this.disable = false
      console.warn('false', this.disable)
    })
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

        if (this.disable) {
          Button('进入游戏')
            .stateEffect(false)
            .offset({ top: '10%' }).opacity(0.4)

        } else {
          Button('进入游戏')
            .offset({ top: '10%' })
            .onClick(() => {
              console.log(`click button!!!`)
              console.warn('router', !!router.pushUrl)
              router.pushUrl({
                url:'pages/Game'
              })
            })
        }
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
