import * as utils from '../../utils'
import * as conf from '../../game/config'
import { WORLD } from '../../game/world'

@Component
export struct MeditionBtn {

  click: () => void = () => {}

  build() {
    Column(){
      Column(){
        Image($r('app.media.MeditationPic'))
          .width('100%')
          // .onClick(() => this.clickToMeditation())
      }.width('100%').height('100%').justifyContent(FlexAlign.Center).position({x: 0, y: 0})
      Column(){
        Image($r('app.media.effect'))
          .width('70%').opacity(0.3)
          .onClick(() => this.click())
      }.width('100%').height('100%').justifyContent(FlexAlign.Center).position({x: 0, y: 0})
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}