import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "suggestions"];
  static values = { keywords: Array };

  connect() {
    this.selectedIndex = -1;
    this.clearSuggestions();
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase();
    const words = query.split(/\s+/);
    const lastWord = words[words.length - 1];
    this.clearSuggestions();

    if (query.trim() === "") return;

    const matches = this.keywordsValue.filter(keyword =>
      keyword.toLowerCase().startsWith(lastWord.toLowerCase())
    );

    if (matches.length > 0) {
      this.showSuggestions(matches);
    }
  }

  showSuggestions(matches) {
    this.suggestionsTarget.classList.remove("d-none");
    this.suggestionsTarget.innerHTML = matches
      .map((match, index) =>
        `<div class="p-2 suggestion-item" role="option" tabindex="${index}"
             data-action="click->autocomplete#select"
             data-autocomplete-index="${index}">
          ${match}
        </div>`
      )
      .join("");
  }

  navigate(event) {
    const items = this.suggestionsTarget.querySelectorAll(".suggestion-item");

    if (items.length === 0) return;

    if (event.key === "ArrowDown" || event.key === "Tab") {
      this.selectedIndex = (this.selectedIndex + 1) % items.length;
      this.highlight(items);
      event.preventDefault();
    } else if (event.key === "ArrowUp" || (event.shiftKey && event.key === "Tab")) {
      this.selectedIndex =
        (this.selectedIndex - 1 + items.length) % items.length;
      this.highlight(items);
      event.preventDefault();
    } else if (event.key === "Enter") {
      if (this.selectedIndex >= 0) {
        const words = this.inputTarget.value.split(' ');
        words[words.length - 1] = items[this.selectedIndex].textContent.trim() + ":";
        this.inputTarget.value = words.join(" ");
        this.clearSuggestions();
        event.preventDefault();
      }
    }
  }

  highlight(items) {
    items.forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.classList.add("bg-primary", "text-white");
        item.scrollIntoView({ block: "nearest" });
      } else {
        item.classList.remove("bg-primary", "text-white");
      }
    });
  }

  select(event) {
    const words = this.inputTarget.value.split(' ');
    words[words.length - 1] = event.target.textContent.trim() + ":";
    this.inputTarget.value = words.join(" ");
    this.clearSuggestions();
  }

  clearSuggestions() {
    this.selectedIndex = -1;
    this.suggestionsTarget.classList.add("d-none");
    this.suggestionsTarget.innerHTML = "";
  }
}
