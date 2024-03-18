import NestedForm from "stimulus-rails-nested-form";

export default class extends NestedForm {
  connect() {
    super.connect();
  }

  remove(e) {
    super.remove(e);
    const lineItemRemoved = new CustomEvent("line-item-removed");
    window.dispatchEvent(lineItemRemoved);
  }
}
