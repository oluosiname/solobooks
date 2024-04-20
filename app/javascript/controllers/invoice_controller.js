import { Controller } from "@hotwired/stimulus";
// import Rails from "rails-ujs";

// Connects to data-controller="invoice"
export default class extends Controller {
  static targets = [
    "subTotal",
    "total",
    "vatCharged",
    "vatIncluded",
    "vatRate",
    "vat",
    "vatFieldsWrapper",
    "vatFieldsMessage",
    "invoiceCurrency",
  ];

  connect() {
    console.log("Connected to invoice controller");
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }

  async handleClientChange(e) {
    const { vat_technique, message } = await this.getVatTechnique(
      e.target.value
    );
    console.log({ vat_technique, message });
    if (vat_technique == "standard") {
      this.vatFieldsWrapperTarget.style.display = "block";
      this.vatFieldsMessageTarget.style.display = "none";
      this.vatIncludedTarget.disabled = false;
      this.vatTarget.disabled = false;
      this.vatRateTarget.disabled = false;
    } else {
      this.vatIncludedTarget.disabled = true;
      this.vatTarget.disabled = true;
      this.vatRateTarget.disabled = true;
      this.vatFieldsWrapperTarget.style.display = "none";
      this.vatFieldsMessageTarget.style.display = "block";
      this.vatFieldsMessageTarget.innerHTML = message;
    }
    this.calculateTotal();
  }

  async getVatTechnique(client_id) {
    const locale = this.data.get("locale");
    return fetch(`/${locale}/invoices/vat_technique?client_id=${client_id}`, {
      method: "GET",
      mode: "cors",
      cache: "no-cache",
      credentials: "same-origin",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": this.getMetaValue("csrf-token"),
      },
    })
      .then((response) => response.json())
      .then((json) => {
        return json;
      });
  }

  //called when  any line item total field is changed

  handleLineItemPriceChange(e) {
    console.log(e);
    if (e.target.value == "") {
      e.target.classList.add("invalid");
    }

    this.calculateTotal();
  }

  calculateTotal() {
    const locale = this.data.get("locale");
    const lineItems = this.element.querySelectorAll(
      "[data-controller='line-item']"
    );
    let subtotal = 0;
    let total = 0;
    lineItems.forEach((lineItem) => {
      const lineItemPrice = parseFloat(
        lineItem.querySelector(".line-item-price").value || 0
      );
      const lineItemQuantity = parseFloat(
        lineItem.querySelector(".line-item-quantity").value || 0
      );
      const lineItemTotalField = lineItem.querySelector(".line-item-total");

      subtotal += this.calculateLineItemTotal(
        lineItemPrice,
        lineItemQuantity,
        lineItemTotalField
      );
    });

    if (this.vatFieldsWrapperTarget.style.display != "none") {
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
    const currency =
      this.invoiceCurrencyTarget.options[
        this.invoiceCurrencyTarget.selectedIndex
      ].text;
    const currencyStyle = {
      style: "currency",
      currency: currency,
    };
    this.subTotalTarget.innerHTML = new Intl.NumberFormat(
      locale,
      currencyStyle
    ).format(subtotal);
    this.totalTarget.innerHTML = new Intl.NumberFormat(
      locale,
      currencyStyle
    ).format(total);
  }

  calculateLineItemTotal(lineItemPrice, lineItemQuantity, lineItemTotalField) {
    const lineItemTotal = lineItemPrice * lineItemQuantity;
    lineItemTotalField.value = lineItemTotal;
    return lineItemTotal;
  }
}
