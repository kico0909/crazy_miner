import * as utils from '../../utils'
/*
 * 用户可以触发的事件
 * */
export interface TActionEvent {
  type: string // 事件分类
  textTemplate: string // 文字模版
  level: number // 事件等级
  condition: Function // 执行成功率
  effect?: string // 执行效果
  probability: number //
}

export const eventTypeSort: string[] = ['normal']

export const DB_Events: TActionEvent[] = [

  // 基础默认事件
  {
    type: 'default',
    textTemplate: '你向下挖了一搞',
    level: 0,
    probability: 300,
    condition: () => true
  },
  {
    type: 'default',
    textTemplate: '你不情愿的向下挖了一镐',
    level: 0,
    probability: 50,
    condition: () => true
  },
  {
    type: 'default',
    textTemplate: '你费劲的向下挖了一镐',
    level: 0,
    probability: 50,
    condition: () => true
  },

  // 普通事件
  {
    type: 'normal',
    textTemplate: '你使劲向下挖了一铲子土',
    level: 0,
    probability: 200,
    condition: () => utils.getRandomInt(1,10) > 5,
    effect: 'exp:3'
  },
  {
    type: 'normal',
    textTemplate: '你疯狂的向下挖了一铲子土',
    level: 0,
    probability: 100,
    condition: () => utils.getRandomInt(1,10) > 8,
    effect: 'exp:5'
  },
  {
    type: 'normal',
    textTemplate: '你经过不断挖掘,感觉浑身充满力量',
    level: 0,
    probability: 100,
    condition: () => utils.getRandomInt(1,10) > 8,
    effect: 'strong:1'
  },
  {
    type: 'normal',
    textTemplate: '你挖掘时不小心撞到了洞壁,脑袋一痛',
    level: 0,
    probability: 100,
    condition: () => utils.getRandomInt(1,10) > 8,
    effect: 'intellect:1'
  },
  {
    type: 'normal',
    textTemplate: '你不小心挖到了空洞,掉下去了',
    level: 0,
    probability: 100,
    condition: () => utils.getRandomInt(1,10) > 8,
    effect: 'deep:1'
  }
]