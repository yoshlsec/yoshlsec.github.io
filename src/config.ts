import type {
  LicenseConfig,
  NavBarConfig,
  ProfileConfig,
  SiteConfig,
} from './types/config'
import { LinkPreset } from './types/config'

export const siteConfig: SiteConfig = {
  title: 'yoshlsec',
  subtitle: 'Digital Forensics',
  lang: 'es',
  themeColor: {
    hue: 260, // Default hue for the theme color, from 0 to 360. e.g. red: 0, teal: 200, cyan: 250, pink: 345
    fixed: true, // Hide the theme color picker for visitors
  },
  banner: {
    enable: false,
    src: 'assets/images/banner.jpg', // Relative to the /src directory. Relative to the /public directory if it starts with '/'
    position: 'center', // Equivalent to object-position, defaults center
  },
  favicon: [
    {
      src: '/favicon/favicon-32x32.png', // Path of the favicon, relative to the /public directory
    },
  ],
}

export const navBarConfig: NavBarConfig = {
  links: [
    LinkPreset.Home,
    LinkPreset.Archive,
    LinkPreset.About,
  ],
}

export const profileConfig: ProfileConfig = {
  avatar: 'assets/images/profile.png', // Relative to the /src directory. Relative to the /public directory if it starts with '/'
  name: 'yoshlsec',
  bio: 'Digital Forensics',
  links: [
  ],
  quotes: {
    es: [
      '',
    ],
    en: [
      '',
    ],
  },
}

export const licenseConfig: LicenseConfig = {
  enable: false,
  name: 'CC BY-NC-SA 4.0',
  url: 'https://creativecommons.org/licenses/by-nc-sa/4.0/',
}
