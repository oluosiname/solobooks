import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form"];
  static values = { container: String, fields: Array };

  connect() {}

  call() {
    const path = location.pathname;
    const fields = this.fieldsValue;
    const displayContainerId = this.containerValue;
    const query = {};

    const formElements = this.formTarget.elements;
    [...formElements].forEach((element) => {
      if (fields.includes(element.name)) {
        query[element.name] = element.value;
      }
    });

    const formData = new FormData(this.formTarget);
    for (const [key, value] of formData) {
      console.log(`${key}: ${value}\n`);
    }

    // this.formTarget.submit();
    Turbo.navigator.submitForm(this.formTarget);

    // fetch(`${path}?query=${query}`, {
    //   contentType: "application/json",
    //   hearders: "application/json",
    // })
    //   .then((response) => response.text())
    //   .then((res) => {
    //     document.getElementById(displayContainerId).innerHTML = res;
    //   });
  }
}
