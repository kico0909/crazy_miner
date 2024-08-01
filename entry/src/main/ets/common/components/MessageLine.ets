import { getDB } from '../game/core'

@Component
export struct MessageLine {
  @Prop message: string = ''

  @State msg: string = ''
  @State quality: string = ''
  @State QualityConf: Map<string, string> = new Map()

  onDidBuild(): void {
    getDB().then(rs => {
      const arr = this.message.split('|')
      this.msg = arr[0] ? arr[0] : ''
      const q = rs.quality.get(arr[1] ? arr[1] : '0')
      this.quality = q ? q : ''
    })
  }

  build() {
    Text(`${this.msg}`).fontColor(this.quality)
  }
}