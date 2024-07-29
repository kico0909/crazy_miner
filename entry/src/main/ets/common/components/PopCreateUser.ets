@CustomDialog
export struct PopCreateUser {

  @Link inputName: string
  @Prop confirmCB: () => void

  controller?: CustomDialogController

  cancel: () => void = () => {}
  confirm: () => void = () => { }

  onInput(val: string) {
    this.inputName = val
  }

  build(){
    Column(){
      Text('请输入探险者的昵称')
        .margin({bottom: '40lpx'})
      TextInput({
        placeholder: '昵称', text: this.inputName
      })
        .onChange(e => {this.onInput(e)})
        .margin({bottom: '50lpx'})
      Row(){
        Button('确定')
          .onClick(() => this.confirm())
          .margin({right: '50lpx'})
        Button('取消').backgroundColor('#ccc')
      }
    }.width('90%').height('350lpx')
    .backgroundColor('#fff').borderRadius('50lpx').margin({bottom: '40lpx'})
    .padding({top: '40lpx',bottom: '40lpx',left: '40lpx',right: '40lpx'})
    .alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.End)
  }
}