const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    screens: {
      'sm': '640px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
    },
    minHeight:{
      '4/5': '80%',
      '3/5': '60%',
      '2/5': '40%',
      '1/5': '20%'
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        serif: ['Montserrat'],
      },
      keyframes: {
        'fade-out': {
          '0%': { 'opacity': 0},
          '7.5%': { 'opacity': 1},
          '92.5%': {'opacity': 1},
          '100%': {'opacity': 0, 'left': '-9999px'}
        },
      },
      animation: {
        'fade-out': 'fade-out 7s forwards '
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
