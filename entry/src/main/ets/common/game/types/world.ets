/**
 * 世界的类型声明
 */
import { TAchiveUser } from './player'
import { TGameState } from './game'

export interface TArchiveFile {
  user: TAchiveUser
  game: TGameState
}

export interface TWordEventShow {
  per: number
  message: string[]
}

// 挖矿事件
export interface TMinerActionEventItem {
  type: string // 事件分类
  textTemplate: string // 文字模版
  quality: number // 事件品质
  effect?: string // 执行效果
  probability: number //
}

/*
 * 随机挖矿事件数据归类
 * */
export interface TTypeEventBox {
  items: TMinerActionEventItem[]
  probability: number
}
// 挖矿事件排序
export enum EnumEventTypeSort {
  default = 0,
  normal = 1,
  middle = 2,
  advance = 3
}

// 角色做出一个动作 返回数据的声明
export interface TWorldAction {
  perStep: number // 挖掘进度条步长
  event: TMinerActionEventItem | undefined
  message: string[] // 挖掘消息
  exp: number  // 一次动作获得的经验
  levelUp: boolean // player 是否升级
}