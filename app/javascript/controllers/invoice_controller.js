import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="invoice"
export default class extends Controller {
  static targets = [
    "subTotal",
    "total",
    "vatCharged",
    "vatIncluded",
    "vatRate",
    "vat",
  ];

  connect() {
    console.log("Connected to invoice controller");
  }

  //called when  any line item total field is changed

  calculateTotal() {
    const lineItems = this.element.querySelectorAll(
      "[data-controller='line-item']"
    );
    let subtotal = 0;
    let total = 0;
    lineItems.forEach((lineItem) => {
      const lineItemPrice = parseFloat(
        lineItem.querySelector(".line-item-price").value
      );
      const lineItemQuantity = parseFloat(
        lineItem.querySelector(".line-item-quantity").value
      );
      const lineItemTotalField = lineItem.querySelector(".line-item-total");

      subtotal += this.calculateLineItemTotal(
        lineItemPrice,
        lineItemQuantity,
        lineItemTotalField
      );
    });

    if (this.vatChargedTarget.checked) {
      const vatRate = parseFloat(this.vatRateTarget.value);
      const vat = (subtotal * vatRate) / 100;
      this.vatTarget.value = vat;
      if (this.vatIncludedTarget.checked) {
        total = subtotal;
        subtotal = subtotal - vat;
      } else {
        total = subtotal + vat;
      }
    } else {
      this.vatTarget.value = 0;
      total = subtotal;
    }

    this.subTotalTarget.innerHTML = new Intl.NumberFormat("de").format(
      subtotal
    );
    this.totalTarget.innerHTML = new Intl.NumberFormat("de").format(total);
  }

  calculateLineItemTotal(lineItemPrice, lineItemQuantity, lineItemTotalField) {
    const lineItemTotal = lineItemPrice * lineItemQuantity;
    lineItemTotalField.value = lineItemTotal;
    return lineItemTotal;
  }

  toggleVatFields() {
    if (this.vatChargedTarget.checked) {
      this.vatIncludedTarget.disabled = false;
      this.vatTarget.disabled = false;
      this.vatRateTarget.disabled = false;
    } else {
      this.vatIncludedTarget.disabled = true;
      this.vatTarget.disabled = true;
      this.vatRateTarget.disabled = true;
    }
  }
}
