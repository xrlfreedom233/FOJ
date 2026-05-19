import Vue from 'vue'
import VueI18n from 'vue-i18n'
import elzhCN from 'element-ui/lib/locale/lang/zh-CN'
import vxeZhCN from 'vxe-table/lib/locale/lang/zh-CN'

Vue.use(VueI18n)

const ojZh = require('./oj/zh-CN').m
const adminZh = require('./admin/zh-CN').m
const m = Object.assign({}, ojZh, adminZh)
const ui = Object.assign({}, vxeZhCN, elzhCN)

export default new VueI18n({
  locale: 'zh-CN',
  messages: {
    'zh-CN': Object.assign({ m }, ui)
  }
})
