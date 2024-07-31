/*
 * 玩家打坐事件数据
 * */

import { cloudFunction } from '@kit.CloudFoundationKit';
import { BusinessError } from '@kit.BasicServicesKit';

export interface TMeditationEventItem {
  msg: string
  effect: string
  probability: number
  quality: number
}

export async function Meditations() {
  try {
    const res: cloudFunction.FunctionResult = await cloudFunction.call({
      name: 'mudcrazyminer-meditationdb',
    })
    return res.result
  } catch (e) {
    console.warn('获得修炼事件失败!', JSON.stringify(e))
  }
  return []
}


export function Meditations_old(): TMeditationEventItem[] {
  const MeditationsDB: TMeditationEventItem[] = [
    {
      msg: '突然好运缠身',
      effect: 'luck:1-2',
      probability: 5,
      quality: 4
    },
    {
      msg: '感觉变强壮了',
      effect: 'strong:1-3',
      probability: 10,
      quality: 3
    },
    {
      msg: '一瞬间头脑通明',
      effect: 'intellect:1-3',
      probability: 10,
      quality: 3
    },
    {
      msg: '打了鸡血',
      effect: 'strength:1-3',
      probability: 10,
      quality: 3
    },
    {
      msg: '吸收了矿洞中污秽的气息',
      effect: 'exp:3-5',
      probability: 20,
      quality: 3
    }
  ]
  return MeditationsDB
}