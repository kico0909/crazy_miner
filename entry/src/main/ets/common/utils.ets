import * as conf from './game/config'
import { TAchiveItem, TAchiveUser, Person, TPersonAttr } from './game/player'
// import { TGameState } from './game/core'
import { TArchiveFile, WORLD } from './game/world'
import { TItemData, Item } from './game/item'
import * as core from './game/core'

/**
 * 在一个包含 probability 字段的对象数组中按照概率随机返回一个对象。
 *
 * @param items - 包含 probability 字段的对象数组
 * @returns 按概率随机选择的对象
 */
interface TProbableObject<T>{ probability: number, T };

export function getRandomObjectByProbability<T>(items: T[]): T {
  // 计算总概率
  const totalProbability = items.reduce((sum, item) => sum + (item as TProbableObject<T>).probability, 0);

  // 生成一个0到totalProbability之间的随机数
  const random = Math.random() * totalProbability;

  // 按照概率选择对象
  let cumulativeProbability = 0;
  for (const item of items) {
    cumulativeProbability += (item as TProbableObject<T>).probability;
    if (random <= cumulativeProbability) {
      return item as T;
    }
  }

  // 这是一个防御性返回，通常不会到这里
  return items[items.length - 1] as T;
}

/**
 * 将一个数字或数字字符串格式化成保留两位小数的数字。
 *
 * @param value - 要格式化的数字或数字字符串
 * @returns 格式化后的数字，保留两位小数
 */
export function formatToDecimal(value: number | string, decimal: number = 2): number {

  let num = typeof value === 'string' ? parseFloat(value) : value;
  if (isNaN(num)) {
    throw new Error("Invalid input: not a number");
  }
  return Math.round(num * Math.pow(10, decimal)) / Math.pow(10, decimal);
}

/**
 * 返回随机整数的函数，根据不同参数进行不同范围的随机数生成。
 *
 * @param minOrMax - 可选参数，单个整数表示最大值，两个整数表示最小值和最大值
 * @param max - 可选参数，表示最大值
 * @returns 一个随机整数
 */
export function getRandomInt(minOrMax?: number, max?: number): number {

  if (minOrMax === undefined && max === undefined || minOrMax === undefined) {
    // 不限定区间范围返回随机整数
    return Math.floor(Math.random() * Number.MAX_SAFE_INTEGER);
  }
  if (max === undefined) {
    // 传入1个整数参数，返回0-参数间的随机整数
    return Math.floor(Math.random() * (minOrMax! + 1));
  }
  if (minOrMax === max) {
    // 如果参数1 == 参数2 返回0-参数1之间的随机整数
    return Math.floor(Math.random() * (minOrMax + 1));
  }
  return Math.floor(Math.random() * (max - minOrMax + 1)) + minOrMax;
}

// 解码
export function decodeStr(str: string) {
  const text = decodeURIComponent(str)
  return text
}

// 编码
export function encodeStr(str: string) {
  const text = encodeURIComponent(str)
  return text
}

export function resetData() {

}

// 将storage中的用户存档初始化
export function initData() {
  const avhieveDefaultData = core.initWorldData()
}

// 获得用户存档数据
export const getData = (cb: (data?: TArchiveFile) => void) => {
  const archiveData = core.getWorldData()
  console.warn('获得用户数据: ', JSON.stringify(archiveData))
  cb ? cb(archiveData) : false;
}

// 恢复用户道具
export function createUsetItem(data: TAchiveItem): Item {
  const item: Item = new Item(data)
  return item
}

// 创建用户属性
export function createPlayerAttrs(): TPersonAttr {
  const attr: TPersonAttr = {
    strength: Math.floor(Math.random() * 1e10 % 5) + 1,
    strong: Math.floor(Math.random() * 1e10 % 5) + 1,
    intellect: Math.floor(Math.random() * 1e10 % 5) + 1,
    luck: Math.floor(Math.random() * 1e10 % 3) + 1,
  }
  return attr
}