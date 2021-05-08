window.Rails = require('@rails/ujs')
import 'controllers'

import './application.scss'
import '../images/splash.jpg'

import * as cola from "webcola/dist"

window.cola = cola

Rails.start()
