// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "@popperjs/core"
document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("movie-search");
  const searchInputEn = document.getElementById("movie-search-en");
  const resultsContainer = document.getElementById("search-results");
  const languageToggle = document.getElementById("toggle-language");
  let debounceTimeout;

  // fetch search results based on query and language
  function fetchResults(query) {
    if (!query.trim()) {
      resultsContainer.innerHTML = "";
      return;
    }

    const language = languageToggle.textContent === "日本語" ? "en" : "ja";

    fetch(`/movies/search?query=${encodeURIComponent(query)}&language=${language}`)
      .then(response => response.json())
      .then(results => {
        resultsContainer.innerHTML = results
          .map(movie => `
            <div class="search-result" data-id="${movie.id}" data-source="${movie.source}">
              <strong>${movie.title}</strong> (${movie.release_date || "Unknown"})
              <p>${movie.overview}</p>
            </div>
          `)
          .join("");

        // click event for each result
        document.querySelectorAll(".search-result").forEach(result => {
          result.addEventListener("click", () => {
            document.getElementById("selected-movie-id").value = result.dataset.id;
            (searchInput || searchInputEn).value = result.querySelector("strong").textContent;
            resultsContainer.innerHTML = "";
          });
        });
      })
      .catch(error => console.error("error fetching results:", error));
  }

  // event listener for search inputs
  if (searchInput && searchInputEn) {
    [searchInput, searchInputEn].forEach(input => {
      input.addEventListener("input", event => {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => fetchResults(event.target.value), 500);
      });
    });
  }
});
