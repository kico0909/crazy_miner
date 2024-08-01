import { WORLD } from '../../game/world'
import * as utils from '../../utils'
import * as core from '../../game/core'
import * as conf from '../../game/config'

import { MessageLine } from '../MessageLine'
import { AdventureProcessBar } from './AdventureProcessBar'

export class TMessage {
  text: string = '';
  date?: string = '';
  time?: string = '';
}

@Component
export struct Adventure {
  onDidBuild(): void {
    console.log('挖矿创建完毕!')
  }

  private listScroller: Scroller = new Scroller();

  @Link World: WORLD
  @Link per: number
  @Watch('onMsgChange') @Link messages: TMessage[]

  // 监听消息变化, 自动滚动制最后一条消息的位置
  onMsgChange() {
    this.listScroller.scrollToIndex(this.messages.length - 1)
  }

  @Styles StyleInfoLine() {
    .width('100%')
    .height('50lpx')
    .margin({bottom: '12lpx'})
  }
  @Styles StyleInfoItem() {
    .width('50%')
    .height('100%')
  }

  build(){
    ColumnSplit() {

      Row(){
          List({
            scroller: this.listScroller
          }){
            ForEach(this.messages, (item: TMessage) => {
              if (item){
                ListItem(){
                  MessageLine({
                    message: item.text
                  })
                }.padding('5lpx')
              }
            })
          }.width('100%').height('100%').padding('5lpx')
      }.width('100%').height('calc(50% - 75lpx)').padding('10lpx')
      .backgroundColor($r('app.color.start_window_background'))

      Row(){
        AdventureProcessBar({
          process: $per
        })
      }.width('100%').height('150lpx').backgroundColor('#f0f0f0')

      Column(){
        Row() {
          Row(){
            Text(`矿坑: ${this.World.map.name}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color')).width('100%')
          }
        }.StyleInfoLine()
        Row() {
          Row(){
            Text(`${conf.AttrToText.get('deep')}: ${this.World.deep}米`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
            Text(`${conf.AttrToText.get('complatePer')}: ${(utils.formatToDecimal(this.World.deep/this.World.map.finished*100))}%`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
          }
        }.StyleInfoLine()

        Row(){
          Text(`矿工信息: ${this.World.player.name}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color')).width('100%')
        }.StyleInfoLine()

        Row() {
          Row(){
            Text(`${conf.AttrToText.get('level')}: ${this.World.player.level}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
            Text(`${conf.AttrToText.get('exp')}: ${utils.formatToDecimal(this.World.player.exp)}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
          }
        }.StyleInfoLine()
        Row() {
          Row(){
            Text(`${conf.AttrToText.get('strength')}: ${this.World.player.attr.strength}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
            Text(`${conf.AttrToText.get('strong')}: ${this.World.player.attr.strong}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
          }
        }.StyleInfoLine()
        Row() {
          Row(){
            Text(`${conf.AttrToText.get('intellect')}: ${this.World.player.attr.intellect}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
            Text(`${conf.AttrToText.get('luck')}: ${this.World.player.attr.luck}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
          }
        }.StyleInfoLine()

        Row() {
          Row(){
            Text(`${conf.AttrToText.get('meditationPoint')}: ${this.World.player.meditationPoint}/${core.meditationPointsMaxByLevel(this.World.player.level)}`).StyleInfoItem().fontColor($r('app.color.normal_text_font_color'))
          }
        }.StyleInfoLine()
      }
      .width('100%').height('calc(50% - 75lpx)')
      .padding('15lpx').backgroundColor($r('app.color.start_window_background'))
    }.width('100%').height('100%')
  }
}