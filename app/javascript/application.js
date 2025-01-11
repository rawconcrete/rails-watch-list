// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "@popperjs/core"
document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("movie-search");
  const searchInputEn = document.getElementById("movie-search-en");
  const resultsContainer = document.getElementById("search-results");
  let debounceTimeout;

  function fetchResults(query) {
    if (query.trim().length === 0) {
      resultsContainer.innerHTML = "";
      return;
    }

    fetch(`/movies/search?query=${encodeURIComponent(query)}`)
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

        // Add click listeners
        document.querySelectorAll(".search-result").forEach(result => {
          result.addEventListener("click", () => {
            const movieId = result.dataset.id;
            const movieTitle = result.querySelector("strong").textContent;

            // Set selected movie
            document.getElementById("selected-movie-id").value = movieId;
            (searchInput || searchInputEn).value = movieTitle;
            resultsContainer.innerHTML = ""; // Clear results
          });
        });
      })
      .catch(error => console.error("Error fetching search results:", error));
  }

  if (searchInput && searchInputEn) {
    // Attach input event listeners
    [searchInput, searchInputEn].forEach(input => {
      input.addEventListener("input", (event) => {
        const query = event.target.value;

        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => fetchResults(query), 500); // Debounce
      });
    });
  }
});
