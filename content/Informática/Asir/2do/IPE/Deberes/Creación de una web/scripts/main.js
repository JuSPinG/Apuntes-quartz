document.addEventListener("DOMContentLoaded", () => {
    const quotes = document.querySelectorAll(".quote");
    const delayIncrement = 0.5; // 0.2 segundos entre cada uno

    quotes.forEach((quote, index) => {
        // 1. Calculamos y asignamos el delay
        const delay = index * delayIncrement;
        quote.style.animationDelay = `${delay}s`;

        // 2. Añadimos la clase para que la animación empiece AHORA
        //    (el navegador leerá el delay que acabamos de poner)
        quote.classList.add("terminal");
    });
});