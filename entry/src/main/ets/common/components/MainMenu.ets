import { WORLD } from '../game/world'
import Btn from './MainMenuButton'

@Component
export struct MainMenu {
  @Link command: String;

  build() {
    RowSplit() {
      Btn({
        title: `探险`
      }).onClick(() => this.command = 'adventure')
      Btn({
        title: '修炼'
      }).onClick(() => this.command = 'meditation')
      Btn({
        title: '系统'
      }).onClick(() => this.command = 'system')
    }.width('100%').height('100%').backgroundColor($r('app.color.start_window_background'))
  }
}