import router from '@ohos.router'

import { initDB } from '../common/game/core'
import { http } from '@kit.NetworkKit'

import { BusinessError } from '@kit.BasicServicesKit'

let text: string = ''


@Entry
@Component
struct Index {

  @State disable: boolean = true
  @State reGetKey: boolean = false
  @State loading: boolean = false



  initGameDB() {
    if (this.loading) return
    this.loading = true
    initDB((ret?: http.HttpResponse) => {
      this.loading = false
      if (!ret) {
        this.disable = false
      } else {
        this.reGetKey = true
      }
    })
  }

  onPageShow(): void {
    console.log(text)
  }

  onDidBuild(): void {
    console.log('启动界面构建完成,执行初始化')
    this.initGameDB()
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
          Text('基础数据初始化中...')
            .fontColor('#fff')
            .offset({ top: '10%' }).opacity(0.4)
        } else {
          Button('开始挖矿')
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

      if (this.reGetKey) {
        Column() {
          Row(){
            Text('初始化数据失败,').fontColor('#fff')
            Text('请重新初始化').fontColor('#Fff').onClick(() => this.initGameDB())
          }
        }
      }

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
