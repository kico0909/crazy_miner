import * as conf from '../config'
import * as DB from '../db'
import * as core from '../core'
import * as utils from '../../utils'

import { Person } from '../player'
import { WORLD, TArchiveFile } from '../world'
import { initWorldData } from './init'
import { handlerEffectScript } from './script'

// get world data
export function getWorldData(): TArchiveFile {
  const data = AppStorage.get<string>(conf.PersistentStoragePath)
  if (!data) {
    return initWorldData()
  }
  const res = JSON.parse(utils.decodeStr(data)) as TArchiveFile
  return res
}

export function saveWorldData(data: TArchiveFile): boolean {
  const str = utils.encodeStr(JSON.stringify(data))
  return AppStorage.set<string>(conf.PersistentStoragePath, str)
}



/*
 * 随机挖矿事件数据归类
 * */
export interface TTypeEventBox {
  items: core.TActionEvent[]
  probability: number
}
enum EnumEventTypeSort {
  default = 0,
  normal = 1,
  middle = 2,
  advance = 3
}
export function handlerEvents(events: core.TActionEvent[]): TTypeEventBox[] {
  const result: TTypeEventBox[] = [
    {items: [], probability: 0},
    {items: [], probability: 0},
    {items: [], probability: 0},
    {items: [], probability: 0}
  ]
  events.forEach(item => {
    switch(item.type) {
      case 'default':
        result[EnumEventTypeSort.default].items.push(item)
        result[EnumEventTypeSort.default].probability = 0
        break
      case 'normal':
        result[EnumEventTypeSort.normal].items.push(item)
        result[EnumEventTypeSort.normal].probability += item.probability
        break
      case 'middle':
        result[EnumEventTypeSort.middle].items.push(item)
        result[EnumEventTypeSort.middle].probability += item.probability
        break
      case 'advance':
        result[EnumEventTypeSort.advance].items.push(item)
        result[EnumEventTypeSort.advance].probability += item.probability
        break
      default:
        console.warn('事件归类整理', `未知事件,无法归类[${JSON.stringify(item)}]`)
    }
  })

  return result
}

/*
* 每一次挖掘,触发的动作
* */
// 角色做出一个动作 返回数据的声明
export interface TWorldAction {
  perStep: number // 挖掘进度条步长
  event: core.TActionEvent | undefined
  message: string[] // 挖掘消息
  exp: number  // 一次动作获得的经验
  levelUp: boolean // player 是否升级
}
// 创建具体动作内容
function createActionEvent(world: WORLD, stepLong: number): core.TActionEvent {
  const luck = world.player.attr.luck
  const luckRand = utils.getRandomInt(0, 100)
  if (luckRand <= luck + stepLong) { // 触发特殊事件
    // 获得一个特殊事件 分类
    const eventType = utils.getRandomObjectByProbability<TTypeEventBox>(world.events)
    // 获得一个特殊事件
    const event = utils.getRandomObjectByProbability<core.TActionEvent>(eventType.items)
    return event
  } else { // 普通事件直接返回
    const event = utils.getRandomObjectByProbability<core.TActionEvent>(world.events[EnumEventTypeSort.default].items)
    return event
  }
}

/*
* 用户一次挖掘动作获取的经验值
* */
function calcPlayerExpByActionOnce(step: number, w: WORLD): number {
  let exp = 1 + utils.getRandomInt(10, 50) / 100
  return  utils.formatToDecimal(exp)
}

/*
* 计算一次挖掘的步长值
* */
function calcPerStepVal(world: WORLD): number {
  /*
   * 计算一次挖掘的步长: 用户等级 + 地图级别修正 + 用户幸运修正 + 当前矿坑深度修正 +
   * */
  // 基础进度
  const base = utils.getRandomInt(90, 100) / 100
  // 等级 修正
  const level = 0
  // 随机修正
  const random = utils.getRandomInt(1,3) / 10
  // 地图修正
  const mapIndex = 0
  // 幸运修正
  const randomInt = utils.getRandomInt(0, 100)
  const luck = randomInt < world.player.attr.luck ? utils.getRandomInt(0, 2) : 0
  // 深度修正
  const deep = 0
  // 计算结果
  let perStep = base + level + mapIndex + luck + deep + random
  // 修正结果边界
  perStep = perStep < 1 ? 1 : perStep // 修正最小值边界
  perStep = perStep > 100 ? 100 : perStep // 修正最大值边界
  return perStep
}


/*
* 矿工世界运动一次
* */
export function playerActionOnce(world: WORLD): TWorldAction {
  let exp = 0
  // 创建深度
  const perStep = calcPerStepVal(world)
  exp = calcPlayerExpByActionOnce(perStep, world)
  // 创建事件
  const event = createActionEvent(world, perStep)

  // 创建消息
  let message: string[] = []

  if (world.per>=100) {
    message.push('你努力的将矿洞向前挖进了1米!')
    world.perFull()
  }

  // 处理挖掘事件
  const eventResult = handlerEffectScript(event, world)
  if (eventResult.msg) {
    message.push(eventResult.msg)
  }

  // 增加一次打坐能力
  world.player.meditationPoint = 1

  // // 处理经验值
  const levelUp = world.player.setExp(exp)
  if(levelUp) {
    message.push(`恭喜矿工升级了[等级: ${world.player.level}级]`)
  }
  const res: TWorldAction = {
    perStep, // 计算后的挖掘进度
    event, // 触发的事件
    message, // 动作事件
    exp, // 获得的经验
    levelUp: eventResult.levelUp,
  }
  return res
}