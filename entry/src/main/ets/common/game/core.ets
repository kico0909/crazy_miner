import * as conf from './config'
import * as DB from './db'
import * as utils from '../utils'
import { WORLD, TArchiveFile } from './world'
import { EPlayerAttrs, TAchiveItem, TAchiveUser, Person, TPersonAttr } from './player'
import { JSON } from '@kit.ArkTS'

// 游戏存档状态声明
export interface TGameState {
  per: number
  mapIndex: number
  deep: number
}

// init world data
export function initWorldData(): TArchiveFile {
  const defaultUserData: TAchiveUser = {
    name: '',
    attrs: {
      strength: 0, strong: 0, intellect: 0, luck: 0
    },
    items: [],
    mapIndex: 0,
    exp: 0,
    level: 1,
    meditationPoint: 0,
  }
  const defaultGameState: TGameState = {
    per: 0,
    mapIndex: 0,
    deep: 0,
  }
  const avhieveDefaultData: TArchiveFile = {
    user: defaultUserData,
    game: defaultGameState
  }
  const str = JSON.stringify(avhieveDefaultData)
  PersistentStorage.persistProp(conf.PersistentStoragePath, utils.encodeStr(str))
  return avhieveDefaultData
}

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
// 效果脚本执行
interface THandlerEffectScriptResult {
  msg: string
  effect: string
  value: number
  levelUp: boolean
}
export function handlerEffectScript(event: DB.TActionEvent, w: WORLD): THandlerEffectScriptResult {
  const res: THandlerEffectScriptResult = {
    msg: '',
    effect: '',
    value: 0,
    levelUp: false
  }
  if (event.type === 'default') {
    res.msg = event.textTemplate
  }
  if (!event.effect) {
    return res
  }
  const scriptArr =  event.effect.split(':')
  if(scriptArr.length !== 2) {
    res.msg = '碰到了无法解释的灵异事件'
    return res
  }
  let type = scriptArr[0]
  let value = 0
  const valueArr = scriptArr[1].split('-')
  if (valueArr.length < 1) {
    res.msg = '碰到了无法解释的事件'
    return res
  }
  if (valueArr.length > 1) {
    value = utils.getRandomInt(parseInt(valueArr[0]), parseInt(valueArr[1]))
  } else {
    value = parseInt(valueArr[0])
  }
  res.msg = `${event.textTemplate}。[${type}: ${value}]`
  res.value = value
  switch (type) {
    case 'exp':
      res.levelUp = w.player.setExp(value)
      break
    case 'deep':
      w.deep = value
      break
    case 'strong':
      w.player.setAttr(EPlayerAttrs.Strong, value)
      break
    case 'intellect':
      w.player.setAttr(EPlayerAttrs.Intellect, value)
      break
    default:
      console.warn('挖掘事件特效触发错误', '无法识别的特效脚本[${script}]')
      res.msg = '你的智商,貌似没办法理解这个事情如何发生的'
      return res
  }
  return res
}

/*
 * 事件数据归类
 * */
export interface TTypeEventBox {
  items: DB.TActionEvent[]
  probability: number
}
enum EnumEventTypeSort {
  default = 0,
  normal = 1,
  middle = 2,
  advance = 3
}
export function handlerEvents(events: DB.TActionEvent[]): TTypeEventBox[] {
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
* 基于等级计算总经验值
* */
function calcExpFromLevel(level: number): number {
  const exp = (3/40) * (Math.pow(level, 3) +39*Math.pow(level,2 )+360*level - 400) + 30 * level
  return exp
}

/*
* 基于EXP计算player等级
* */
export function calcPlayerLevelByExp(exp: number) {
  let level = 1
  let countExp = 0
  do {
    countExp = calcExpFromLevel(level++)
  } while (exp > countExp)
  return level - 1
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
* 每一次挖掘,触发的动作
* */
// 角色做出一个动作 返回数据的声明
export interface TWorldAction {
  perStep: number // 挖掘进度条步长
  event: DB.TActionEvent | undefined
  message: string[] // 挖掘消息
  exp: number  // 一次动作获得的经验
  levelUp: boolean // player 是否升级
}
// 创建具体动作内容
function createActionEvent(world: WORLD, stepLong: number): DB.TActionEvent {
  const luck = world.player.attr.luck
  const luckRand = utils.getRandomInt(0, 100)
  if (luckRand <= luck + stepLong) { // 触发特殊事件
    // 获得一个特殊事件 分类
    const eventType = utils.getRandomObjectByProbability<TTypeEventBox>(world.events)
    // 获得一个特殊事件
    const event = utils.getRandomObjectByProbability<DB.TActionEvent>(eventType.items)
    return event
  } else { // 普通事件直接返回
    const event = utils.getRandomObjectByProbability<DB.TActionEvent>(world.events[EnumEventTypeSort.default].items)
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
interface TMeditationEffectActivitedResult {
  msg: string
  type: string
  val: number
  quality: number
}
function meditationEffectActivited(): TMeditationEffectActivitedResult | undefined {
  // 随机获得一个修炼事件
  const effect = utils.getRandomObjectByProbability<DB.TMeditationEventItem>(DB.Meditations)
  if (!effect) return undefined
  const msg = effect.msg
  const efs = effect.effect.split(',')
  const randEfs = efs[utils.formatToDecimal(0, efs.length - 1)]
  const efContent = randEfs.split(':')
  const type = efContent[0]
  const valArea = efContent[1].split('-')
  const quality = effect.quality
  let val = 0
  if (valArea.length < 2) val = parseFloat(valArea[0])
  if (valArea.length > 1) val = utils.getRandomInt(parseInt(valArea[0]), parseInt(valArea[1]))
  const result: TMeditationEffectActivitedResult = {
    msg, type, val, quality
  }
  return result
}
export function actionPlayerMeditation(w: WORLD): TMeditationResult {
  const randPer = utils.getRandomInt(0, conf.Meditation.maxPer)
  const success = randPer <= conf.Meditation.basePer
  let effect = success ? meditationEffectActivited() : undefined
  let msg = !!effect ? effect.msg : ''
  const effectType = !effect ? '' : conf.AttrToText.get(effect.type)
  msg += effect ? `[${effectType}: +${!!effect ? effect.val : 0}]|${!!effect ? effect.quality : 1}` : ''
  const result: TMeditationResult ={
    result: success,
    msg,
    effType: !!effect ? effect.type : '',
    effValue: !!effect ? effect.val : 0,
  }
  return result
}

/*
 * 按级别计算打坐点数上限
 * */
export function meditationPointsMaxByLevel(level: number) {
  return level * 5
}