@Component
export struct Default {
  build() {
    Column(){
      Image($r('app.media.MountainMiner')).width('100%').offset({top: '-10%'})
    }.width('100%').height('100%').backgroundColor($r('app.color.start_window_background'))
    .padding('30lpx').justifyContent(FlexAlign.Center)
  }
}