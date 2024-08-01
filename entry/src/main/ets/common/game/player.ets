import * as utils from '../utils'
import * as core from './core'
import * as t from './types'
import { WORLD } from './world'
import { Item } from './item'
import { calcPlayerLevelByExp } from './core/core'

export * from './types';

// 用户
export class Person {
  private _nickname: string = ''
  private _attrs: t.TPersonAttr
  private _bag: Item[] = []
  private _mapIndex: number = 0
  private _level: number = 1
  private _exp = 0
  private _meditationPoint = 0
  isDead: boolean = false

  constructor(
    name: string,
    attrs: t.TPersonAttr = {  strength: 0, strong: 0, intellect: 0, luck: 0 },
    bag: Item[] = [],
    mapIndex: number = 0,
    exp: number = 0,
    level: number = 1,
    meditationPoint: number = 0
  ) {
    this._nickname = name
    this._attrs = attrs
    this._bag = bag
    this._mapIndex = mapIndex ? mapIndex : 0
    this._exp = exp ? exp : 0
    this._level = level ? level : 1
    this._meditationPoint = meditationPoint ? meditationPoint : 0

  }

  // 用户打坐
  meditation(w: WORLD): Promise<t.TMeditationResult> {
    return new Promise<t.TMeditationResult>(resolve => {
      let res: t.TMeditationResult = { result: false, msg: ''}
      if (w.isPause()) {
        res.msg = '世界处于静止状态，你无法修炼!|1'
        resolve(res)
        return
      }
      if (this._meditationPoint <= 0) {
        res.msg = '没有灵感,无法修炼!|1'
        resolve(res)
        return
      }
      this.meditationPoint = -1

      core.actionPlayerMeditation(w).then(result => {
        if (result.result) {
          switch (result.effType) {
            case t.EPlayerAttrs.Strength:
              this._attrs.strength += result.effValue ? result.effValue : 0
              break
            case t.EPlayerAttrs.Intellect:
              this._attrs.intellect += result.effValue ? result.effValue : 0
              break
            case t.EPlayerAttrs.Strong:
              this._attrs.strong += result.effValue ? result.effValue : 0
              break
            case t.EPlayerAttrs.Luck:
              this._attrs.luck += result.effValue ? result.effValue : 0
              break
            case t.EPlayerAttrs.Exp:
              this._exp += result.effValue ? result.effValue : 0
              break
            default:
              console.warn('打坐特效触发', `[${result.effType}]无法识别的特效类型`)
          }
        }
        resolve(result)
      })
    })

  }

  set meditationPoint(num: number) {
    if (this._meditationPoint + num <= core.meditationPointsMaxByLevel(this._level)) {
      this._meditationPoint += num
    } else {
      this._meditationPoint = core.meditationPointsMaxByLevel(this._level)
    }
  }

  get meditationPoint() {
    return this._meditationPoint
  }

  get level() {
    return this._level
  }
  get exp() {
    return this._exp
  }

  get attr() {
    return this._attrs
  }

  // set attr(attr: TPersonAttr) {
  //   this._attrs = attr
  // }

  get name() {
    return this._nickname
  }

  get bag() {
    return this._bag
  }

  get mapIndex() {
    return this._mapIndex
  }

  // 设置角色处于哪个地图
  set mapIndex(index: number) {
    if (index < 0) {
      this._mapIndex = 0
    } else {
      this._mapIndex = index
    }
  }

  setAttr(attrType: t.EPlayerAttrs, value: number): boolean {
    switch (attrType) {
      case t.EPlayerAttrs.Strength:
        this._attrs.strength += value
        break;
      case t.EPlayerAttrs.Strong:
        this._attrs.strong += value
        break;
      case t.EPlayerAttrs.Intellect:
        this._attrs.intellect += value
        break;
      case t.EPlayerAttrs.Luck:
        this._attrs.luck += value
        break;
      case t.EPlayerAttrs.Exp:
        return this.setExp(value)
        break;
    }
    return false
  }

  setExp(exp: number): boolean {
    this._exp += exp
    const level = calcPlayerLevelByExp(this._exp)
    if (level > this._level) {
      this._level = level
      return true
    } else {
      return false
    }
  }

  // 查询背包内的道具
  findItem(itemName: string): Item | undefined {
    const item = this._bag.find(item => item.name === itemName)
    return item
  }

  // 插入一件道具
  addItem(item: Item): boolean {
    if(!item) return false
    if(!item.stacking) {
      this._bag.push(item)
      return true
    }
    const haveItem = this.findItem(item.name)
    if (!haveItem) {
      this._bag.push(item)
      return true
    }
    haveItem.count += 1
    return true
  }

  // 使用一件道具
  useItem(item: Item): boolean {
    if (!item) return false
    const haveItem = this.findItem(item.name)
    if (!haveItem) return false
    haveItem.effect(this)
    return true
  }

  // 获取全部用户信息
  getUserFile():　t.TAchiveUser {
    const name = this._nickname
    const attrs = JSON.parse((JSON.stringify(this._attrs))) as t.TPersonAttr
    const mapIndex = this._mapIndex
    const items: t.TAchiveItem[] = []
    const exp = this._exp
    const level = this._level
    const meditationPoint = this._meditationPoint
    this._bag.forEach(item => {
      items.push({
        name: item.name,
        count: item.count
      })
    })
    return {
      name, attrs, items, mapIndex, exp, level, meditationPoint
    }
  }
}

