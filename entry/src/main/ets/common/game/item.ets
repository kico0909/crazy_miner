import { Person, TAchiveUser, TAchiveItem, TPersonAttr } from './player'
import { TArchiveFile } from './world'

export interface TItemData {
  name: string
  isUse: boolean
  stacking: boolean
  effectScript: string
}

const items: TItemData[] = []

// 背包内道具类
export class Item {
  name: string = '' // 道具名称
  count: number = 0 // 堆叠数量, 如果不能堆叠 此值无效
  isUse: boolean = false // 是否可以被使用
  stacking: boolean = false // 是否能堆叠
  private _effectScript: string = '' // 执行时的脚本
  isTrash: boolean = false

  constructor(data: TAchiveItem, isTrash = false) {
    const itemData = items.find(v => v.name == data.name)
    if (!itemData) {
      return
    }
    this.name = data.name
    this.count = data.count
    this.isUse = itemData.isUse
    this.stacking = itemData.stacking
    this._effectScript = itemData.effectScript
  }

  effect(person: Person) { // 使用后触发的效果
    if (!this._effectScript) return
  }
}