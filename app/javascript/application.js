// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "@fortawesome/fontawesome-free";

import "jquery";
import "select2";

document.addEventListener("turbo:load", () => {
  // Initialize Select2 on your select elements
  $(".select2").select2();

  $(".select2").on("select2:select", function (e) {
    const event = new Event("input", { bubbles: true });
    e.target.dispatchEvent(event);
  });

  function formatBank(bank) {
    if (!bank.id) {
      return bank.text;
    }

    let logo = $(bank.element).data("logo");
    return $(`
      <div class="flex items-center space-x-2">
        <img src="${logo}" alt="${bank.text}" class="w-6 h-6 rounded-full">
        <span>${bank.text}</span>
      </div>
    `);
  }

  $("#bank-select").select2({
    templateResult: formatBank,
    templateSelection: formatBank,
  });
});
document.addEventListener("turbo:frame-load", () => {
  // Initialize Select2 on your select elements loaded by turbo-frame like in a modal
  $(".select2").select2();

  $(".select2").on("select2:select", function (e) {
    const event = new Event("input", { bubbles: true });
    e.target.dispatchEvent(event);
  });
});
