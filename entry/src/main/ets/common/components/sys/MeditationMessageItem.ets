import * as conf from '../../game/config'
@Component
export struct MeditationMessageItem {
  @State msg: string = ''
  @State quality: string = '#fff'

  handlerColor(): string {
    if (!this.quality) {
      return '#ccc'
    }
    const col = conf.Quality.get(this.quality)
    if (!col) {
      return '#ccc'
    }

    return col
  }

  build() {
    ListItem(){
      Text(this.msg ? this.msg : '不明所以的一次修炼...').fontColor(this.handlerColor())
    }.padding('5lpx')
  }
}