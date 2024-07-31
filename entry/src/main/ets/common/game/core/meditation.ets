/*
 * 修炼相关的处理
 * */

import * as conf from '../config'
import * as DB from './db'
import * as utils from '../../utils'
import { WORLD, TArchiveFile } from '../world'
import { EPlayerAttrs, TAchiveItem, TAchiveUser, Person, TPersonAttr } from '../player'
import { JSON } from '@kit.ArkTS'

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

function meditationEffectActivited(): Promise<TMeditationEffectActivitedResult | undefined> {
  return new Promise<TMeditationEffectActivitedResult | undefined>(resolve => {
    DB.getDB().then((gameDB) => {
      // 随机获得一个修炼事件
      const effect = utils.getRandomObjectByProbability<DB.TMeditationEventItem>(gameDB.meditations)
      console.warn('effect', JSON.stringify(effect))
      if (!effect) {
        resolve(undefined)
        return
      }
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
      resolve(result)
    })
  })
}
export function actionPlayerMeditation(w: WORLD): Promise<TMeditationResult> {
  const randPer = utils.getRandomInt(0, conf.Meditation.maxPer)
  const success = randPer <= conf.Meditation.basePer
  let effect: TMeditationEffectActivitedResult | undefined = undefined;
  let result: TMeditationResult = {
    result: false,
    msg: '',
  }
  return new Promise<TMeditationResult>(resolve => {
    if (success) {
      meditationEffectActivited().then(res => {
        if (!!res) {
          effect = res
        }
        const effectType = !effect ? '' : conf.AttrToText.get(effect.type)
        let msg = effect ? effect.msg : '';
        msg += effect ? `[${effectType}: +${!!effect ? effect.val : 0}]|${!!effect ? effect.quality : 1}` : ''
        let result: TMeditationResult ={
          result: success,
          msg,
          effType: !!effect ? effect.type : '',
          effValue: !!effect ? effect.val : 0,
        }
        resolve(result)
      })
    } else {
      resolve(result)
    }
  })
}

/*
 * 按级别计算打坐点数上限
 * */
export function meditationPointsMaxByLevel(level: number) {
  return level * 5
}