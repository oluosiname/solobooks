import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["input", "preview", "currentImage"];
  connect() {}

  preview() {
    const file = this.inputTarget.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result;
        this.previewTarget.classList.remove("hidden");
        this.currentImageTarget.classList.add("hidden");
      };
      reader.readAsDataURL(file);
    }
  }
}
