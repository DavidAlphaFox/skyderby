import { Controller } from 'stimulus'
import DesignatedLane from 'services/designated_lane'

const DEFAULT_DL_DIRECTION = 0
const DEFAULT_DL_LENGTH = 7000
const DEFAULT_DL_WIDTH = 1200

export default class extends Controller {
  static targets = [ 'map', 'length', 'width', 'direction' ]

  connect() {
    this.directionTarget.value = localStorage.last_used_dl_direction || DEFAULT_DL_DIRECTION
    this.lengthTarget.value = localStorage.last_used_dl_length || DEFAULT_DL_LENGTH
    this.widthTarget.value = localStorage.last_used_dl_width || DEFAULT_DL_WIDTH
  }

  toggle(event) {
    let button = event.currentTarget
    button.blur()
    button.classList.toggle('active')

    if (button.classList.contains('active')) {
      this.enable()
    } else {
      this.disable()
    }
  }

  on_change_length(event) {
    let length = Number(event.currentTarget.value)
    localStorage.last_used_dl_length = length

    this.designated_lane.set_length(length)
  }

  on_change_width(event) {
    let width = Number(event.currentTarget.value)
    localStorage.last_used_dl_width = width

    this.designated_lane.set_width(width)
  }

  on_change_direction(event) {
    let direction = Number(event.currentTarget.value)
    localStorage.last_used_dl_direction = direction

    this.designated_lane.set_direction(direction)
  }

  enable() {
    this.lengthTarget.disabled = false
    this.widthTarget.disabled = false
    this.directionTarget.disabled = false

    if (!this.designated_lane) {
      this.designated_lane = new DesignatedLane(
        google,
        this.map,
        this.widthTarget.value,
        this.lengthTarget.value,
        this.directionTarget.value,
        {
          on_rotate: (angle) => {
            this.directionTarget.value = angle
            localStorage.last_used_dl_direction = angle
          }
        }
      )
    }

    this.designated_lane.show()
  }

  disable() {
    this.lengthTarget.disabled = true
    this.widthTarget.disabled = true
    this.directionTarget.disabled = true

    this.designated_lane.hide()
  }

  get map() {
    return this.mapTarget.map_instance
  }
}
