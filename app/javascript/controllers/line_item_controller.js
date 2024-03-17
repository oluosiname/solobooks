import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="line-item"
export default class extends Controller {
  connect() {
    console.log("Connected to line item controller");
  }

  static targets = ["price", "quantity", "total"];

  //called when price field or quantity field is changed

  calculateTotal() {
    const price = parseFloat(this.priceTarget.value);
    const quantity = parseFloat(this.quantityTarget.value);
    console.log({ price, quantity });
    this.totalTarget.value = price * quantity;
  }
}
