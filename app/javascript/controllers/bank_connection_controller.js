import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="bank-connection"

export default class extends Controller {
  static targets = ["toggle"];

  update(event) {
    let form = event.currentTarget.closest("form");
    if (form) {
      form.requestSubmit();
    }
  }
}
