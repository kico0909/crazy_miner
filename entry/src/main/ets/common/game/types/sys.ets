/**
 * 系统级类型声明
 */

import { TMapDataItem } from './map'
import { TMeditationEventItem } from './player'
import { TMinerActionEventItem } from './world'

// 效果脚本执行
export interface THandlerEffectScriptResult {
  msg: string
  effect: string
  value: number
  levelUp: boolean
}

export interface TMeditationConf { // 修炼相关 配置信息
  basePer: number // 基础触发率
  maxPer: number // 最高触发率
  onceTimeLen: number // 两次打坐间隔
}

export interface TSysConfig { // 系统配置
  meditation: TMeditationConf
}

export interface TBaseDB { // 基础数据结构声明
  meditations: TMeditationEventItem[] // 修炼事件
  minerEvents: TMinerActionEventItem[] // 挖矿事件
  maps: TMapDataItem[], // 地图
  config: TSysConfig, // 基础配置设置
  quality: [string, string][], // 品质颜色设置
}