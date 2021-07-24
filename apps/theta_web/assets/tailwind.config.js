module.exports = {
  prefix: '',
  // important: false,
  purge: {
    //   preserveHtmlElements: false,
    // enabled: true, // Remove or change to `true` to enable purging.
    mode: 'layers',
      content: [
        '../lib/**/*.ex',
        '../lib/**/*.leex',
        '../lib/**/*.eex',
        './js/**/*.js'
      ]
  },

  corePlugins: {
    preflight: false,
    // Filter
    filter: false,
    blur: false,
    brightness: false,
    contrast: false,
    dropShadow: false,
    grayscale: false,
    hueRotate: false,
    invert: false,
    saturate: false,
    sepia: false,
    backdropFilter: false,
    backdropBlur: false,
    backdropBrightness: false,
    backdropContrast: false,
    backdropGrayscale: false,
    backdropHueRotate: false,
    backdropInvert: false,
    backdropOpacity: false,
    backdropSaturate: false,
    backdropSepia: false,
    // TRANSITIONS AND ANIMATION
    // transitionProperty: false,
    // transitionDuration: false,
    // transitionTimingFunction: false,
    // transitionDelay: false,
    // animation: false,
    // transform: false,
    // transformOrigin: false,
    scale: false,
    // rotate: false,
    // translate: false,
    skew: false,
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    // ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji
    fontFamily: {
      'sans': ['Nunito','ui-sans-serif', 'system-ui', '-apple-system', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', '"Noto Sans"', 'sans-serif', '"Apple Color Emoji"', '"Segoe UI Emoji"','"Segoe UI Symbol"','"Noto Color Emoji"'],
      'serif': ['ui-serif', 'Georgia'],
      'mono': ['ui-monospace', 'SFMono-Regular'],
    },
    flex: {
      '1': '1 1 0%',
      auto: '1 1 auto',
      initial: '0 1 auto',
      none: 'none',
      '3': '3 0 0%',
      '6': '6 0 0%'
    },
    screens: {
      'tab': '640px',
      'lap': '1024px',
      'des': '1280px'
    },
    extend: {
      colors: {
        primary: '#0157b1',
        second: '#333333',
        tags: '#f4f4f4',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/forms'),
  ],
}


