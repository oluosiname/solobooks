import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["dropdownButton", "dropdownContainer"];
  connect() {}

  actionToggle(e) {
    document.querySelectorAll(".dropdown").forEach((dropdown) => {
      if (dropdown !== this.dropdownContainerTarget) {
        dropdown.classList.remove("open");
      }
    });
    this.dropdownContainerTarget.classList.toggle("open");
  }
}
