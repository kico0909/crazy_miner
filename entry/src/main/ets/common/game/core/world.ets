import * as conf from '../config'
import * as core from '../core'
import * as utils from '../../utils'
import * as t from '../types'

import { Person } from '../player'
import { WORLD } from '../world'
import { initWorldData } from './init'
import { handlerEffectScript } from './script'

// get world data
export function getWorldData(): t.TArchiveFile {
  const data = AppStorage.get<string>(utils.ResourceConvertString($r('app.string.PersistentStoragePath')))
  if (!data) {
    return initWorldData()
  }
  const res = JSON.parse(utils.decodeStr(data)) as t.TArchiveFile
  return res
}

export function saveWorldData(data: t.TArchiveFile): boolean {
  const str = utils.encodeStr(JSON.stringify(data))
  return AppStorage.set<string>(utils.ResourceConvertString($r('app.string.PersistentStoragePath')), str)
}

// 分类挖矿事件的数据
export function handlerEvents(events: t.TMinerActionEventItem[]): t.TTypeEventBox[] {
  const result: t.TTypeEventBox[] = [
    {items: [], probability: 0},
    {items: [], probability: 0},
    {items: [], probability: 0},
    {items: [], probability: 0}
  ]
  events.forEach(item => {
    switch(item.type) {
      case 'default':
        result[t.EnumEventTypeSort.default].items.push(item)
        result[t.EnumEventTypeSort.default].probability = 0
        break
      case 'normal':
        result[t.EnumEventTypeSort.normal].items.push(item)
        result[t.EnumEventTypeSort.normal].probability += item.probability
        break
      case 'middle':
        result[t.EnumEventTypeSort.middle].items.push(item)
        result[t.EnumEventTypeSort.middle].probability += item.probability
        break
      case 'advance':
        result[t.EnumEventTypeSort.advance].items.push(item)
        result[t.EnumEventTypeSort.advance].probability += item.probability
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
// 创建具体动作内容
function createActionEvent(world: WORLD, stepLong: number): t.TMinerActionEventItem {
  const luck = world.player.attr.luck
  const luckRand = utils.getRandomInt(0, 100)
  if (luckRand <= luck + stepLong) { // 触发特殊事件
    // 获得一个特殊事件 分类
    const eventType = utils.getRandomObjectByProbability<t.TTypeEventBox>(world.events)
    // 获得一个特殊事件
    const event = utils.getRandomObjectByProbability<t.TMinerActionEventItem>(eventType.items)
    return event
  } else { // 普通事件直接返回
    console.warn('world.events', JSON.stringify(world.events))
    const event = utils.getRandomObjectByProbability<t.TMinerActionEventItem>(world.events[t.EnumEventTypeSort.default].items)
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
export function playerActionOnce(world: WORLD): t.TWorldAction {
  let exp = 0
  // 创建深度
  const perStep = calcPerStepVal(world)
  exp = utils.getRandomInt(1,10) % 3 === 0 ? calcPlayerExpByActionOnce(perStep, world) : 0
  // 创建事件
  const event = createActionEvent(world, perStep)

  // 创建消息
  let message: string[] = []

  if (world.per>=100) {
    message.push('你努力的将矿洞向前挖进了1米!|2')
    world.perFull()
  }

  // 处理挖掘事件
  const eventResult = handlerEffectScript(event, world)
  if (eventResult.msg) {
    message.push(`${eventResult.msg}|${event.quality}`)
  }

  // 增加一次打坐能力
  world.player.meditationPoint = utils.getRandomInt(1,10) % 3 === 0 ? 1 : 0

  // // 处理经验值
  const levelUp = world.player.setExp(exp)
  if(levelUp) {
    message.push(`恭喜矿工升级了[等级: ${world.player.level}级]|2`)
  }

  console.warn('action message: ', message)
  const res: t.TWorldAction = {
    perStep, // 计算后的挖掘进度
    event, // 触发的事件
    message, // 动作事件
    exp, // 获得的经验
    levelUp: eventResult.levelUp,
  }
  return res
}