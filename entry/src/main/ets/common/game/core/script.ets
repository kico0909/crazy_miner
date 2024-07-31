/*
 * 脚本执行相关
 * */

import * as conf from '../config'
import * as core from '../core'
import * as DB from '../db'
import * as utils from '../../utils'

import { Person, EPlayerAttrs } from '../player'
import { WORLD, TArchiveFile } from '../world'

// 效果脚本执行
interface THandlerEffectScriptResult {
  msg: string
  effect: string
  value: number
  levelUp: boolean
}
export function handlerEffectScript(event: core.TActionEvent, w: WORLD): THandlerEffectScriptResult {
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
  const scriptArr: string[] =  event.effect.split(':')
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
