import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form"];
  static values = { container: String, fields: Array };

  connect() {}

  call() {
    const fields = this.fieldsValue;
    const query = {};

    const formElements = this.formTarget.elements;
    [...formElements].forEach((element) => {
      if (fields.includes(element.name)) {
        query[element.name] = element.value;
      }
    });

    const formData = new FormData(this.formTarget);
    // for (const [key, value] of formData) {
    //   console.log(`${key}: ${value}\n`);
    // }

    // this.formTarget.submit();
    Turbo.navigator.submitForm(this.formTarget);
  }

  reset() {
    this.formTarget.reset();
    const url = new URL(window.location.href);
    url.search = ""; // Remove all query parameters

    // Use the Turbo library to navigate to the cleared URL
    Turbo.visit(url.toString(), { action: "replace" });
  }
}
