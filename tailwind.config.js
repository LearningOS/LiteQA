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
    require('daisyui'),
  ],
}
