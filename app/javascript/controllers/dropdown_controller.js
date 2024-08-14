import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["dropdownButton", "dropdownContainer"];
  connect() {
    // Bind the handleClickOutside method to the instance of this class
    this.handleClickOutside = this.handleClickOutside.bind(this);

    // Listen for clicks outside the dropdown
    document.addEventListener("click", this.handleClickOutside);
  }

  disconnect() {
    // Clean up the event listener when the controller is disconnected
    document.removeEventListener("click", this.handleClickOutside);
  }

  actionToggle(e) {
    document.querySelectorAll(".dropdown").forEach((dropdown) => {
      if (dropdown !== this.dropdownContainerTarget) {
        dropdown.classList.remove("open");
      }
    });
    this.dropdownContainerTarget.classList.toggle("open");
  }

  handleClickOutside(e) {
    // Check if the click was outside the dropdownContainer
    if (!this.dropdownContainerTarget.contains(e.target)) {
      this.dropdownContainerTarget.classList.remove("open");
    }
  }
}
