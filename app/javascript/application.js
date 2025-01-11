// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "@popperjs/core"
document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("movie-search");
  const resultsContainer = document.getElementById("search-results");

  if (searchInput) {
    searchInput.addEventListener("input", async (event) => {
      const query = event.target.value.trim();

      if (query.length === 0) {
        resultsContainer.innerHTML = "";
        return;
      }

      // fetch results
      const response = await fetch(`/movies/search?query=${encodeURIComponent(query)}`);
      const results = await response.json();

      // display results
      resultsContainer.innerHTML = results.map(movie => `
        <div class="search-result" data-id="${movie.id}" data-source="${movie.source}">
          <strong>${movie.title}</strong> (${movie.release_date || "Unknown"})
          <p>${movie.overview}</p>
          <small>Source: ${movie.source}</small>
        </div>
      `).join("");

      // add click event listeners to each
      document.querySelectorAll(".search-result").forEach(result => {
        result.addEventListener("click", () => {
          const movieId = result.dataset.id;
          const movieSource = result.dataset.source;
          const movieTitle = result.querySelector("strong").textContent;

          // set selected movie
          document.getElementById("selected-movie-id").value = `${movieSource}:${movieId}`;
          searchInput.value = movieTitle;
          resultsContainer.innerHTML = ""; // Clear results
        });
      });
    });
  }
});
