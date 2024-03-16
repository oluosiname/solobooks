import { Controller } from "@hotwired/stimulus";
import Flatpickr from "stimulus-flatpickr";

// import the translation files and create a translation mapping
import Deutsch from "flatpickr/dist/l10n/de.js";
import english from "flatpickr/dist/l10n/default.js";

// Connects to data-controller="flatpickr"
export default class extends Flatpickr {
  locales = {
    de: Deutsch,
    en: english,
  };

  connect() {
    this.config = {
      locale: this.locale,
      altInput: true,
    };

    super.connect();
  }

  get locale() {
    if (!this.locales || !this.data.has("locale")) {
      return "en";
    }
    return this.data.get("locale");
  }
}
