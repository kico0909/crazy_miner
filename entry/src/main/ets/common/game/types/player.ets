/**
 * 玩家类型声明
 */
export interface TAchiveItem {
  name: string
  count: number
}

// 用户属性存档
export interface TAchiveUser {
  name: string
  attrs: TPersonAttr
  items: TAchiveItem[]
  mapIndex: number
  exp: number
  level: number
  meditationPoint: number
}

// 用户属性
export interface TPersonAttr { // 角色属性类
  strength: number // 精力
  strong: number // 强壮
  intellect: number // 智力
  luck: number // 幸运
}

export enum EPlayerAttrs {
  Strength = 'strength',
  Strong = 'strong',
  Intellect = 'intellect',
  Luck = 'luck',
  Exp = 'exp'
}

// 修炼事件
export interface TMeditationEventItem {
  msg: string
  effect: string
  probability: number
  quality: number
}

/*
 * player 完成一次打坐
 * */
export interface TMeditationResult {
  result: boolean
  msg: string
  effType?: string
  effValue?: number
}

// 打坐特效激活
export interface TMeditationEffectActivitedResult {
  msg: string
  type: string
  val: number
  quality: number
}
