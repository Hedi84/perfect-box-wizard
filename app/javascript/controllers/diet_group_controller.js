import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["groupA", "groupB", "checkboxA", "checkboxB"]

  connect() {
    this.refresh()
  }

  refresh(event) {
    if (event && this.checkboxBTargets.includes(event.target)) {
      this.enforceSingleSelection(event.target, this.checkboxBTargets)
    }

    const aChecked = this.checkboxATargets.some((checkbox) => checkbox.checked)
    const bChecked = this.checkboxBTargets.some((checkbox) => checkbox.checked)

    this.setGroupState(this.groupBTarget, this.checkboxBTargets, aChecked)
    this.setGroupState(this.groupATarget, this.checkboxATargets, bChecked)
  }

  enforceSingleSelection(changedCheckbox, checkboxes) {
    if (!changedCheckbox.checked) return

    checkboxes.forEach((checkbox) => {
      if (checkbox !== changedCheckbox) checkbox.checked = false
    })
  }

  setGroupState(groupElement, checkboxes, shouldDisable) {
    groupElement.classList.toggle("checkbox-group--disabled", shouldDisable)

    checkboxes.forEach((checkbox) => {
      checkbox.disabled = shouldDisable
      if (shouldDisable) checkbox.checked = false
    })
  }
}
