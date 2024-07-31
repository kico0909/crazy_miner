import * as utils from '../../utils'
import * as core from '../../game/core'
import * as conf from '../../game/config'
import { WORLD } from '../../game/world'
import { Person } from '../../game/player'
import { MeditionBtn } from './MeditationBtn'
import { MeditationMessageItem } from './MeditationMessageItem'

interface TMeditationMessage {
  probability: number
  messageTemplate: string
}
const MeditationMessage: TMeditationMessage[] = [
  {
    probability: 10,
    messageTemplate: '修炼: 你尝试进行一次突破[很可惜无功而返]|1'
  },
  {
    probability: 10,
    messageTemplate: '修炼: 你强行突破[可惜不成功]|1'
  },
  {
    probability: 10,
    messageTemplate: '修炼: 你感觉好像要顿悟[可惜半途醒了]|1'
  }
]

@Component
export struct Meditation {
  @Watch('watcPlayerChange')@Link w: WORLD
  @Watch('onMeditationMsgsChange') @State MeditationMsgs: string[] = ['你准备通过修炼进行突破']

  @State pointMsg: string = ''

  private listScroller: Scroller = new Scroller();
  private meditationOK: boolean = true

  watcPlayerChange(propName: string) {
    this.pointMsg = `${this.w.player.meditationPoint}/${core.meditationPointsMaxByLevel(this.w.player.level)}`
  }

  clickToMeditation() {
    if (!this.meditationOK) return
    this.meditationOK = false
    setTimeout(() => {
      this.meditationOK = true
    }, conf.Meditation.onceTimeLen)

    this.w.player.meditation(this.w).then(result => {
      if (!result.result) {
        if (result.msg) {
          this.MeditationMsgs.push(`修炼: ${result.msg}`)
        } else {
          const text = utils.getRandomObjectByProbability(MeditationMessage)
          if (!text) {
            this.MeditationMsgs.push(`修炼: 你尝试进行一次突破[很可惜无功而返]|1`)
          } else {
            this.MeditationMsgs.push(text.messageTemplate)
          }
        }
      } else {
        this.MeditationMsgs.push(`你灵光一闪: ${result?.msg}`)
      }
    })
  }

  onMeditationMsgsChange(propName: string){
    setTimeout(() => {
      this.listScroller.scrollToIndex(this.MeditationMsgs.length - 1)
    }, 0)
  }

  build() {
    Column(){
      Column(){
        List({
          scroller: this.listScroller
        }){
          ForEach(this.MeditationMsgs, (msg: string) => {
            MeditationMessageItem({
              msg: msg.split('|')[0],
              quality: msg.split('|')[1]
            })
          })
        }.width('100%').height('100%')
      }.width('100%').height('600lpx').padding('20lpx')
      .backgroundColor($r('app.color.start_window_background'))

      Column(){
        Column(){
          MeditionBtn({
            click: () => { this.clickToMeditation() }
          }).width('80%')
        }.width('100%').height('calc(100% - 50lpx)').justifyContent(FlexAlign.Center)
        Column(){

          Text(`请点击打坐图标进行修炼(${this.pointMsg})`).fontColor($r('app.color.normal_text_font_color'))

        }
          .width('100%').height('50lpx').justifyContent(FlexAlign.Center)

      }
      .width('100%').height('calc(100% - 600lpx)').backgroundColor($r('app.color.start_window_background'))

    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}