/*
 * 修炼相关的处理
 * */

import * as conf from '../config'
import * as DB from './db'
import * as utils from '../../utils'
import * as t from '../types'

import { WORLD } from '../world'
import { Person } from '../player'

import { JSON } from '@kit.ArkTS'

function meditationEffectActivited(): Promise<t.TMeditationEffectActivitedResult | undefined> {
  return new Promise<t.TMeditationEffectActivitedResult | undefined>(resolve => {
    DB.getDB().then((gameDB) => {
      // 随机获得一个修炼事件
      const effect = utils.getRandomObjectByProbability<t.TMeditationEventItem>(gameDB.meditations)
      console.warn('effect', JSON.stringify(effect))
      if (!effect) {
        resolve(undefined)
        return
      }
      const msg: string = effect.msg
      const efs: string[] = effect.effect.split(',')
      const randEfs = efs[utils.formatToDecimal(0, efs.length - 1)]
      const efContent = randEfs.split(':')
      const type = efContent[0]
      const valArea = efContent[1].split('-')
      const quality: number = effect.quality
      let val = 0
      if (valArea.length < 2) val = parseFloat(valArea[0])
      if (valArea.length > 1) val = utils.getRandomInt(parseInt(valArea[0]), parseInt(valArea[1]))
      const result: t.TMeditationEffectActivitedResult = {
        msg, type, val, quality
      }
      resolve(result)
    })
  })
}
export function actionPlayerMeditation(w: WORLD): Promise<t.TMeditationResult> {




  return new Promise<t.TMeditationResult>(resolve => {

    DB.getDB().then(db => {
      const MeditationConf = db.config?.meditation
      const randPer = utils.getRandomInt(0, MeditationConf?.maxPer)
      const success = randPer <= (MeditationConf ? MeditationConf.basePer : 0)
      let effect: t.TMeditationEffectActivitedResult | undefined = undefined;
      let result: t.TMeditationResult = {
        result: false,
        msg: '',
      }
      if (success) {
        meditationEffectActivited().then(res => {
          if (!!res) {
            effect = res
          }
          const effectType = !effect ? '' : conf.AttrToText.get(effect.type)
          let msg = effect ? effect.msg : '';
          msg += effect ? `[${effectType}: +${!!effect ? effect.val : 0}]|${!!effect ? effect.quality : 1}` : ''
          let result: t.TMeditationResult ={
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
  })
}

/*
 * 按级别计算打坐点数上限
 * */
export function meditationPointsMaxByLevel(level: number) {
  return level * 5
}