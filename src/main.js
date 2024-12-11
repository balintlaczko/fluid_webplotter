import './assets/main.css'

import Tres from '@tresjs/core'
import { createApp } from 'vue'
import App from './App.vue'

export const app = createApp(App)

app.use(Tres)
app.mount('#app')