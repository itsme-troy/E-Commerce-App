// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

// Initializing Select2 on the tag selector
document.addEventListener("turbo:load", function () {
    const tagField = document.querySelector("#product_tag_ids");
    if (tagField && $(tagField).select2) {
      $(tagField).select2({
        tags: true,
        tokenSeparators: [',']
      });
    }
  });

  