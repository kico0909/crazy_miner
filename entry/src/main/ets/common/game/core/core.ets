import * as conf from '../config'
import * as DB from '../db'
import * as utils from '../../utils'
import { WORLD, TArchiveFile } from '../world'
import { EPlayerAttrs, TAchiveItem, TAchiveUser, Person, TPersonAttr } from '../player'
import { JSON } from '@kit.ArkTS'


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
