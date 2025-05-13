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

  
// use URL params (params[:min_price]/
// params[:max_price]) to initialize the slider values
document.addEventListener("turbo:load", function () {
  const slider = document.getElementById('price-slider');
  if (!slider || slider.noUiSlider) return; // prevent double initialization 

  const minPriceParam = parseInt(document.getElementById("min-price-input")?.value || "0", 10);
  const maxPriceParam = parseInt(document.getElementById("max-price-input")?.value || "5000", 10);

  noUiSlider.create(slider, {
    start: [minPriceParam, maxPriceParam],
    connect: true,
    range: {
      min: 0,
      max: 5000
    },
    tooltips: false, 
    format: {
      to: value => Math.round(value),
      from: value => Number(value)
    }
  });

  const minInput = document.getElementById("min-price-input");
  const maxInput = document.getElementById("max-price-input");
  const minDisplay = document.getElementById("min-price-display");
  const maxDisplay = document.getElementById("max-price-display");
  const form = document.getElementById("price-form");

  // Initial display values
  minDisplay.textContent = minInput.value;
  maxDisplay.textContent = maxInput.value;

  slider.noUiSlider.on('update', function (values) {
    minInput.value = values[0];
    maxInput.value = values[1];
    minDisplay.textContent = values[0];
    maxDisplay.textContent = values[1];
  });

  slider.noUiSlider.on('change', function () {
    form.submit();
  });
});