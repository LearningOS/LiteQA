module.exports = {
  content: [
    "./app/javascript/stylesheets/**/*.*css",
    "./app/javascript/controllers/*.js",
    "./app/views/**/*.*",
    "./app/components/**/*.*",
    "./app/helpers/**/*.*",
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('daisyui'),
  ],
  daisyui: {
    styled: true,
    themes: true,
    base: true,
    utils: true,
    logs: true,
    rtl: false,
    darkTheme: "light",
  },
}
