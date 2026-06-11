/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        primary: { DEFAULT: '#1565C0', light: '#1E88E5', dark: '#0D47A1' },
        sidebar: { bg: '#0D2137', hover: '#1A3552', selected: '#1565C0' },
      },
      fontFamily: { sans: ['Inter', 'sans-serif'] },
    },
  },
  plugins: [],
}
