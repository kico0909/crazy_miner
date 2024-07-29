@Component
export default struct MainMenuButton {
  @Prop title: string = '-'
  build(){
    Button(this.title)
      .type(ButtonType.Normal)
      .width('33.33%').height('100%')
  }
}