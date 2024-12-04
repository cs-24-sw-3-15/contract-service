import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["attachments"];

  connect() {
    this.ensureEmptyField();
  }

  ensureEmptyField() {
    const container = this.attachmentsTarget;
    const fields = container.querySelectorAll(".document-field");
    const emptyFieldExists = Array.from(fields).some(field => !field.value);

    if (!emptyFieldExists) {
      this.addField();
    }
  }

  addField() {
    const clone = document.querySelector("#document-template").content.cloneNode(true);

    const index = this.attachmentsTarget.querySelectorAll(".document-field").length;

    const input = clone.querySelector(".document-field");
    input.setAttribute("name", `contract[documents_attributes][${index}][file]`);
    input.setAttribute("id", `contract_documents_attributes_${index}_file`);

    this.attachmentsTarget.appendChild(clone);
  }

  handleFileChange(event) {
    if (event.target.value) {
      this.ensureEmptyField();
    }
  }
}

