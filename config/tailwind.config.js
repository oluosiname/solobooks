const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
        body: ["Baloo\\ Paaji\\ 2", "sans-serif"],
      },
      colors: {
        primary: {
          DEFAULT: "#3482F6",
          // 50: "#A3A8CB",
          // 100: "#969BC3",
          // 200: "#7C83B4",
          // 300: "#626AA6",
          // 400: "#51588E",
          // 500: "#424874",
          // 600: "#2E3250",
          // 700: "#191C2C",
          // 800: "#050509",
          // 900: "#000000",
        },
        secondary: {
          DEFAULT: "#DCD6F7",
          50: "#DCD6F7",
          100: "#C8BFF2",
          200: "#A090E9",
          300: "#7861E0",
          400: "#5032D7",
          500: "#3C22AF",
          600: "#2C1980",
          700: "#1C1051",
          800: "#0B0722",
          900: "#000000",
          950: "#000000",
        },
        grey: {
          DEFAULT: "#F1F5F9",
          // 50: "#CACFD6",
          100: "#e5e7eb",
          // 200: "#9BA4B1",
          // 300: "#7B8799",
          400: "#4b5563",
          // 500: "#47505C",
          // 600: "#2F353D",
          // 700: "#16191D",
          // 800: "#000000",
          // 900: "#000000",
          // 950: "#000000",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
