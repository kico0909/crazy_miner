// @Entry
@Component
export struct AdventureProcessBar {
  @Link process: number

  // @State process: number = 20
  // onPageShow(): void {
  //   setInterval(() => {
  //     // this.process += 2
  //   }, 1000)
  // }

  build() {
    Column(){
      Column(){
        Column(){
        }
        .width(`${100-this.process}%`).height('100%').justifyContent(FlexAlign.End)
        .backgroundColor('#ff000000').animation({ duration: 500 })
      }
      .width('100%').height('100%').justifyContent(FlexAlign.End).alignItems(HorizontalAlign.End)
      .backgroundImage($r('app.media.MountainMinerBar')).backgroundImageSize(ImageSize.Cover).padding(0)
      Column(){
        Text(`${this.process}%`)
          .fontColor('#fff').fontSize('40lpx').textShadow({
            radius: 0,
            type: ShadowType.COLOR,
            offsetX: 5,
            offsetY: 5
        })
      }.width('100%').height('100%').position({x:0, y:0}).justifyContent(FlexAlign.Center)
    }.width('100%').height('100%')
  }
}