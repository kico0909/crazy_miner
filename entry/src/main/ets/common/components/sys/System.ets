import { WORLD } from '../../game/world'
import * as utils from '../../utils'
import * as core from '../../game/core'

@Component
export struct System {

  @Link w: WORLD
  @Link resetTag: boolean

  @Styles ButtonChipLine() {
    .width('100%').height('100lpx')
  }

  @Styles ButtonStyle() {
    .width('100%')
  }

  private _saveing = false
  private _toSaveGameAchiveFile() {
    if (this._saveing) return
    this._saveing = true
    this.w.saveData()
    AlertDialog.show({
      title: '提示',
      message: '进度已保存'
    })
    setTimeout(() => {
      this._saveing = false
    }, 500)
  }

  private _resetting = false
  private _resetData() {
    this.w.pause() // 暂停世界
    this.resetTag = true
  }
  private _toResetData() {
    AlertDialog.show({
      title: '重置数据',
      message: '重置存档数据后,游戏将完全从新开始!',
      isModal:true,
      confirm: {
        enabled: true,
        value: '重置',
        action: () => {
          this._resetData()
        }
      },
    })
  }

  private _closeApp() {
    AlertDialog.show({
      title: `关闭应用`,
      message: `是否完全关闭${$r('app.string.app_name')}`,
      isModal:true,
      confirm: {
        enabled: true,
        value: '关闭',
        action: () => {
          console.log('执行了退出应用')
          // app.terminate()
        }
      },
    })
  }

  private _toPause() {
    this.w.pause()
  }

  build() {
    Column(){
      Column(){
        Button('重置游戏存档')
          .onClick(() => this._toResetData())
          .type(ButtonType.Normal).ButtonStyle()
      }.ButtonChipLine().justifyContent(FlexAlign.Center)
      Column(){
        Button('手动保存游戏')
          .onClick(() => this._toSaveGameAchiveFile())
          .type(ButtonType.Normal).ButtonStyle()
      }.ButtonChipLine().justifyContent(FlexAlign.Center)
      Column(){
        Button(`${this.w.isPause() ? '启动' : '暂停'}游戏`)
          .onClick(() => this._toPause())
          .type(ButtonType.Normal).ButtonStyle()
      }.ButtonChipLine().justifyContent(FlexAlign.Center)
      Column(){
        Button('关闭APP')
          .onClick(() => this._closeApp())
          .type(ButtonType.Normal).ButtonStyle()
      }.ButtonChipLine().justifyContent(FlexAlign.Center)
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
    .padding('50lpx').backgroundColor($r('app.color.start_window_background'))
  }
}