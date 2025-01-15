MIDDLEWARE=$(cat << 'EOL'
import createMiddleware from 'next-intl/middleware';

import { routing } from '@/i18n/routing';

export default createMiddleware(routing);

export const config = {
  // Match only internationalized pathnames.
  matcher: ['/', '/(en|zh)/:path*'],
};
EOL
)

NEXT_CONFIG=$(cat << 'EOL'
import type { NextConfig } from 'next';
import createNextIntlPlugin from 'next-intl/plugin';

const withNextIntl = createNextIntlPlugin();

const nextConfig: NextConfig = {
  /* config options here */
};

export default withNextIntl(nextConfig);
EOL
)

TAILWIND_CONFIG=$(cat << 'EOL'
import type { Config } from 'tailwindcss';
import { fontFamily } from 'tailwindcss/defaultTheme';
import tailwindcssAnimate from 'tailwindcss-animate';

export default {
  darkMode: ['class'],
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        chart: {
          '1': 'hsl(var(--chart-1))',
          '2': 'hsl(var(--chart-2))',
          '3': 'hsl(var(--chart-3))',
          '4': 'hsl(var(--chart-4))',
          '5': 'hsl(var(--chart-5))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      fontFamily: {
        sans: ['var(--font-sans)', ...fontFamily.sans],
        heading: ['var(--font-heading)', ...fontFamily.sans],
      },
    },
  },
  plugins: [tailwindcssAnimate],
} satisfies Config;
EOL
)

APP_LAYOUT=$(cat << 'EOL'
import './globals.css';

import type { Metadata, Viewport } from 'next';
import type { NextFontWithVariable } from 'next/dist/compiled/@next/font';
import { Inter } from 'next/font/google';
import localFont from 'next/font/local';
import { ThemeProvider } from 'next-themes';

import { TailwindIndicator } from '@/components/tailwind-indicator';
import { Toaster } from '@/components/ui/toaster';
import { cn } from '@/lib/utils';

const inter: NextFontWithVariable = Inter({
  subsets: ['latin'],
  variable: '--font-sans',
});

const fontHeading: NextFontWithVariable = localFont({
  src: '../assets/fonts/CalSans-SemiBold.woff2',
  variable: '--font-heading',
});

export const viewport: Viewport = {
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
};

export const metadata: Metadata = {
  title: 'NextKit',
  description: 'Next.js + TypeScript SaaS Starter',
  keywords: ['Next.js', 'TypeScript', 'Tailwind CSS', 'SaaS', 'Starter', 'Kit'],
  authors: [
    {
      name: 'Peng-Yu Chen',
      url: 'https://pengyuc.com',
    },
    {
      name: 'shadcn',
      url: 'https://shadcn.com',
    },
  ],
  creator: 'Peng-Yu Chen',
};

interface RootLayoutProps {
  children: React.ReactNode;
}

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html suppressHydrationWarning>
      <body
        className={cn(
          'min-h-screen bg-background font-sans antialiased',
          inter.variable,
          fontHeading.variable,
        )}
      >
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          {children}
          <Toaster />
          <TailwindIndicator />
        </ThemeProvider>
      </body>
    </html>
  );
}
EOL
)

APP_LOCALE_LAYOUT=$(cat << 'EOL'
import { notFound } from 'next/navigation';
import { NextIntlClientProvider } from 'next-intl';
import { getMessages } from 'next-intl/server';

import { routing } from '@/i18n/routing';

export default async function LocaleLayout({
  children,
  params,
}: Readonly<{
  children: React.ReactNode;
  params: { locale: string };
}>) {
  const { locale } = await params;

  // Ensure that the incoming `locale` is valid
  if (!routing.locales.includes(locale as 'en' | 'zh')) {
    notFound();
  }

  // Providing all messages to the client side is the easiest way to get started
  const messages = await getMessages();

  return (
    <NextIntlClientProvider messages={messages}>
      {children}
    </NextIntlClientProvider>
  );
}
EOL
)

APP_LOCALE_MARKETING_LAYOUT=$(cat << 'EOL'
import { Footer } from '@/components/footer';
import { Navbar } from '@/components/navbar';
import { marketingConfig } from '@/config/marketing';

interface MarketingLayoutProps {
  children: React.ReactNode;
}

export default function MarketingLayout({ children }: MarketingLayoutProps) {
  return (
    <>
      <Navbar navItems={marketingConfig.navItems} />
      {children}
      <Footer />
    </>
  );
}
EOL
)

APP_LOCALE_MARKETING_PAGE=$(cat << 'EOL'
import Link from 'next/link';
import { useTranslations } from 'next-intl';

import { buttonVariants } from '@/components/ui/button';
import { siteConfig } from '@/config/site';
import { cn } from '@/lib/utils';

export default function IndexPage() {
  const t = useTranslations('Marketing');

  return (
    <>
      <section className="space-y-6 pb-8 pt-6 md:pb-12 md:pt-10 lg:py-32">
        <div className="container mx-auto flex max-w-[64rem] flex-col items-center gap-2 text-center">
          <h1 className="font-heading text-3xl sm:text-5xl md:text-6xl lg:text-7xl">
            {t('title')}
          </h1>
          <p className="leading-normal text-muted-foreground sm:text-xl sm:leading-8">
            {t('description')}
          </p>
          <div className="mt-4 grid grid-cols-2 gap-4">
            <Link
              href="/login"
              className={cn(buttonVariants({ size: 'lg' }), 'text-center')}
            >
              {t('get-nextkit')}
            </Link>
            <Link
              href={siteConfig.links.github}
              target="_blank"
              rel="noreferrer"
              className={cn(
                buttonVariants({ variant: 'outline', size: 'lg' }),
                'text-center',
              )}
            >
              {t('view-on-github')}
            </Link>
          </div>
        </div>
      </section>
      <section
        id="features"
        className="space-y-6 bg-slate-50 py-8 dark:bg-transparent md:py-12 lg:py-24"
      >
        <div className="container mx-auto flex flex-col items-center space-y-4 text-center">
          <h2 className="font-heading text-3xl leading-[1.1] sm:text-3xl md:text-6xl">
            {t('features.title')}
          </h2>
          <p className="leading-normal text-muted-foreground sm:text-lg sm:leading-7">
            {t('features.description')}
          </p>
        </div>
        <div className="container mx-auto grid justify-center gap-4 sm:grid-cols-2">
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <svg viewBox="0 0 24 24" className="h-12 w-12 fill-current">
                <path d="M11.572 0c-.176 0-.31.001-.358.007a19.76 19.76 0 0 1-.364.033C7.443.346 4.25 2.185 2.228 5.012a11.875 11.875 0 0 0-2.119 5.243c-.096.659-.108.854-.108 1.747s.012 1.089.108 1.748c.652 4.506 3.86 8.292 8.209 9.695.779.25 1.6.422 2.534.525.363.04 1.935.04 2.299 0 1.611-.178 2.977-.577 4.323-1.264.207-.106.247-.134.219-.158-.02-.013-.9-1.193-1.955-2.62l-1.919-2.592-2.404-3.558a338.739 338.739 0 0 0-2.422-3.556c-.009-.002-.018 1.579-.023 3.51-.007 3.38-.01 3.515-.052 3.595a.426.426 0 0 1-.206.214c-.075.037-.14.044-.495.044H7.81l-.108-.068a.438.438 0 0 1-.157-.171l-.05-.106.006-4.703.007-4.705.072-.092a.645.645 0 0 1 .174-.143c.096-.047.134-.051.54-.051.478 0 .558.018.682.154.035.038 1.337 1.999 2.895 4.361a10760.433 10760.433 0 0 0 4.735 7.17l1.9 2.879.096-.063a12.317 12.317 0 0 0 2.466-2.163 11.944 11.944 0 0 0 2.824-6.134c.096-.66.108-.854.108-1.748 0-.893-.012-1.088-.108-1.747-.652-4.506-3.859-8.292-8.208-9.695a12.597 12.597 0 0 0-2.499-.523A33.119 33.119 0 0 0 11.573 0zm4.069 7.217c.347 0 .408.005.486.047a.473.473 0 0 1 .237.277c.018.06.023 1.365.018 4.304l-.006 4.218-.744-1.14-.746-1.14v-3.066c0-1.982.01-3.097.023-3.15a.478.478 0 0 1 .233-.296c.096-.05.13-.054.5-.054z" />
              </svg>
              <div className="space-y-2">
                <h3 className="font-bold">{t('features.nextjs')}</h3>
                <p className="text-sm text-muted-foreground">
                  {t('features.nextjs-description')}
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <svg viewBox="0 0 24 24" className="h-12 w-12 fill-current">
                <path d="M14.23 12.004a2.236 2.236 0 0 1-2.235 2.236 2.236 2.236 0 0 1-2.236-2.236 2.236 2.236 0 0 1 2.235-2.236 2.236 2.236 0 0 1 2.236 2.236zm2.648-10.69c-1.346 0-3.107.96-4.888 2.622-1.78-1.653-3.542-2.602-4.887-2.602-.41 0-.783.093-1.106.278-1.375.793-1.683 3.264-.973 6.365C1.98 8.917 0 10.42 0 12.004c0 1.59 1.99 3.097 5.043 4.03-.704 3.113-.39 5.588.988 6.38.32.187.69.275 1.102.275 1.345 0 3.107-.96 4.888-2.624 1.78 1.654 3.542 2.603 4.887 2.603.41 0 .783-.09 1.106-.275 1.374-.792 1.683-3.263.973-6.365C22.02 15.096 24 13.59 24 12.004c0-1.59-1.99-3.097-5.043-4.032.704-3.11.39-5.587-.988-6.38a2.167 2.167 0 0 0-1.092-.278zm-.005 1.09v.006c.225 0 .406.044.558.127.666.382.955 1.835.73 3.704-.054.46-.142.945-.25 1.44a23.476 23.476 0 0 0-3.107-.534A23.892 23.892 0 0 0 12.769 4.7c1.592-1.48 3.087-2.292 4.105-2.295zm-9.77.02c1.012 0 2.514.808 4.11 2.28-.686.72-1.37 1.537-2.02 2.442a22.73 22.73 0 0 0-3.113.538 15.02 15.02 0 0 1-.254-1.42c-.23-1.868.054-3.32.714-3.707.19-.09.4-.127.563-.132zm4.882 3.05c.455.468.91.992 1.36 1.564-.44-.02-.89-.034-1.345-.034-.46 0-.915.01-1.36.034.44-.572.895-1.096 1.345-1.565zM12 8.1c.74 0 1.477.034 2.202.093.406.582.802 1.203 1.183 1.86.372.64.71 1.29 1.018 1.946-.308.655-.646 1.31-1.013 1.95-.38.66-.773 1.288-1.18 1.87a25.64 25.64 0 0 1-4.412.005 26.64 26.64 0 0 1-1.183-1.86c-.372-.64-.71-1.29-1.018-1.946a25.17 25.17 0 0 1 1.013-1.954c.38-.66.773-1.286 1.18-1.868A25.245 25.245 0 0 1 12 8.098zm-3.635.254c-.24.377-.48.763-.704 1.16-.225.39-.435.782-.635 1.174-.265-.656-.49-1.31-.676-1.947.64-.15 1.315-.283 2.015-.386zm7.26 0c.695.103 1.365.23 2.006.387-.18.632-.405 1.282-.66 1.933a25.952 25.952 0 0 0-1.345-2.32zm3.063.675c.484.15.944.317 1.375.498 1.732.74 2.852 1.708 2.852 2.476-.005.768-1.125 1.74-2.857 2.475-.42.18-.88.342-1.355.493a23.966 23.966 0 0 0-1.1-2.98c.45-1.017.81-2.01 1.085-2.964zm-13.395.004c.278.96.645 1.957 1.1 2.98a23.142 23.142 0 0 0-1.086 2.964c-.484-.15-.944-.318-1.37-.5-1.732-.737-2.852-1.706-2.852-2.474 0-.768 1.12-1.742 2.852-2.476.42-.18.88-.342 1.356-.494zm11.678 4.28c.265.657.49 1.312.676 1.948-.64.157-1.316.29-2.016.39a25.819 25.819 0 0 0 1.341-2.338zm-9.945.02c.2.392.41.783.64 1.175.23.39.465.772.705 1.143a22.005 22.005 0 0 1-2.006-.386c.18-.63.406-1.282.66-1.933zM17.92 16.32c.112.493.2.968.254 1.423.23 1.868-.054 3.32-.714 3.708-.147.09-.338.128-.563.128-1.012 0-2.514-.807-4.11-2.28.686-.72 1.37-1.536 2.02-2.44 1.107-.118 2.154-.3 3.113-.54zm-11.83.01c.96.234 2.006.415 3.107.532.66.905 1.345 1.727 2.035 2.446-1.595 1.483-3.092 2.295-4.11 2.295a1.185 1.185 0 0 1-.553-.132c-.666-.38-.955-1.834-.73-3.703.054-.46.142-.944.25-1.438zm4.56.64c.44.02.89.034 1.345.034.46 0 .915-.01 1.36-.034-.44.572-.895 1.095-1.345 1.565-.455-.47-.91-.993-1.36-1.565z" />
              </svg>
              <div className="space-y-2">
                <h3 className="font-bold">{t('features.react')}</h3>
                <p className="text-sm text-muted-foreground">
                  {t('features.react-description')}
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <svg viewBox="0 0 24 24" className="h-12 w-12 fill-current">
                <path d="M0 12C0 5.373 5.373 0 12 0c4.873 0 9.067 2.904 10.947 7.077l-15.87 15.87a11.981 11.981 0 0 1-1.935-1.099L14.99 12H12l-8.485 8.485A11.962 11.962 0 0 1 0 12Zm12.004 12L24 12.004C23.998 18.628 18.628 23.998 12.004 24Z" />
              </svg>
              <div className="space-y-2">
                <h3 className="font-bold">{t('features.database')}</h3>
                <p className="text-sm text-muted-foreground">
                  {t('features.database-description')}
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <svg viewBox="0 0 24 24" className="h-12 w-12 fill-current">
                <path d="M12.001 4.8c-3.2 0-5.2 1.6-6 4.8 1.2-1.6 2.6-2.2 4.2-1.8.913.228 1.565.89 2.288 1.624C13.666 10.618 15.027 12 18.001 12c3.2 0 5.2-1.6 6-4.8-1.2 1.6-2.6 2.2-4.2 1.8-.913-.228-1.565-.89-2.288-1.624C16.337 6.182 14.976 4.8 12.001 4.8zm-6 7.2c-3.2 0-5.2 1.6-6 4.8 1.2-1.6 2.6-2.2 4.2-1.8.913.228 1.565.89 2.288 1.624 1.177 1.194 2.538 2.576 5.512 2.576 3.2 0 5.2-1.6 6-4.8-1.2 1.6-2.6 2.2-4.2 1.8-.913-.228-1.565-.89-2.288-1.624C10.337 13.382 8.976 12 6.001 12z" />
              </svg>
              <div className="space-y-2">
                <h3 className="font-bold">{t('features.components')}</h3>
                <p className="text-sm text-muted-foreground">
                  {t('features.components-description')}
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <svg
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1"
                className="h-12 w-12 fill-current"
              >
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
              </svg>
              <div className="space-y-2">
                <h3 className="font-bold">{t('features.authentication')}</h3>
                <p className="text-sm text-muted-foreground">
                  {t('features.authentication-description')}
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <svg viewBox="0 0 24 24" className="h-12 w-12 fill-current">
                <path d="M13.976 9.15c-2.172-.806-3.356-1.426-3.356-2.409 0-.831.683-1.305 1.901-1.305 2.227 0 4.515.858 6.09 1.631l.89-5.494C18.252.975 15.697 0 12.165 0 9.667 0 7.589.654 6.104 1.872 4.56 3.147 3.757 4.992 3.757 7.218c0 4.039 2.467 5.76 6.476 7.219 2.585.92 3.445 1.574 3.445 2.583 0 .98-.84 1.545-2.354 1.545-1.875 0-4.965-.921-6.99-2.109l-.9 5.555C5.175 22.99 8.385 24 11.714 24c2.641 0 4.843-.624 6.328-1.813 1.664-1.305 2.525-3.236 2.525-5.732 0-4.128-2.524-5.851-6.594-7.305h.003z" />
              </svg>
              <div className="space-y-2">
                <h3 className="font-bold">{t('features.subscriptions')}</h3>
                <p className="text-sm text-muted-foreground">
                  {t('features.subscriptions-description')}
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="mx-auto text-center">
          <p className="leading-normal text-muted-foreground sm:text-lg sm:leading-7">
            {t('features.blog')}
          </p>
        </div>
      </section>
      <section id="open-source" className="py-8 md:py-12 lg:py-24">
        <div className="container mx-auto flex flex-col items-center justify-center gap-4 text-center">
          <h2 className="font-heading text-3xl leading-[1.1] sm:text-3xl md:text-6xl">
            {t('boost.title')}
          </h2>
          <p className="leading-normal text-muted-foreground sm:text-lg sm:leading-7">
            {t('boost.ad-1')}
            <br />
            {t('boost.ad-2')}
            <br />
            {t('boost.ad-3')}
          </p>
        </div>
      </section>
    </>
  );
}
EOL
)

COMPONENTS_FOOTER=$(cat << 'EOL'
import * as React from 'react';

import { Icons } from '@/components/icons';

type FooterProps = React.HTMLAttributes<HTMLElement>;

export function Footer({ className }: FooterProps) {
  return (
    <footer className={className}>
      <div className="container mx-auto flex flex-col items-center justify-between gap-4 py-10 md:h-24 md:flex-row md:py-0">
        <div className="flex flex-col items-center gap-4 px-8 md:flex-row md:gap-2 md:px-0">
          <Icons.logo />
          <p className="text-center text-sm leading-loose md:text-left">
            Built with love in New York
          </p>
        </div>
      </div>
    </footer>
  );
}
EOL
)

COMPONENTS_ICON=$(cat << 'EOL'
import {
  AlertTriangle,
  ArrowRight,
  Check,
  ChevronLeft,
  ChevronRight,
  CreditCard,
  File,
  FileText,
  HelpCircle,
  Image,
  Laptop,
  Loader2,
  LucideProps,
  Moon,
  MoreVertical,
  Pizza,
  Plus,
  Settings,
  SunMedium,
  Trash,
  Twitter,
  User,
  X,
  type XIcon as LucideIcon,
} from 'lucide-react';

export type Icon = typeof LucideIcon;

export const Icons = {
  logo: ChevronRight,
  close: X,
  spinner: Loader2,
  chevronLeft: ChevronLeft,
  chevronRight: ChevronRight,
  trash: Trash,
  post: FileText,
  page: File,
  media: Image,
  settings: Settings,
  billing: CreditCard,
  ellipsis: MoreVertical,
  add: Plus,
  warning: AlertTriangle,
  user: User,
  arrowRight: ArrowRight,
  help: HelpCircle,
  pizza: Pizza,
  sun: SunMedium,
  moon: Moon,
  laptop: Laptop,
  gitHub: ({ ...props }: LucideProps) => (
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fab"
      data-icon="github"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 496 512"
      {...props}
    >
      <path
        fill="currentColor"
        d="M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3 .3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5 .3-6.2 2.3zm44.2-1.7c-2.9 .7-4.9 2.6-4.6 4.9 .3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3 .7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3 .3 2.9 2.3 3.9 1.6 1 3.6 .7 4.3-.7 .7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3 .7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3 .7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z"
      ></path>
    </svg>
  ),
  twitter: Twitter,
  check: Check,
};
EOL
)

COMPONENTS_MOBILE_NAV=$(cat << 'EOL'
import Link from 'next/link';
import * as React from 'react';

import { Icons } from '@/components/icons';
import { siteConfig } from '@/config/site';
import { useLockBody } from '@/hooks/use-lock-body';
import { cn } from '@/lib/utils';
import { NavItem } from '@/types';

interface MobileNavProps {
  navItems: NavItem[];
  children?: React.ReactNode;
}

export function MobileNav({ navItems, children }: MobileNavProps) {
  useLockBody();

  return (
    <div
      className={cn(
        'fixed inset-0 top-16 z-50 grid h-[calc(100vh-4rem)] grid-flow-row auto-rows-max overflow-auto p-6 pb-32 shadow-md animate-in slide-in-from-bottom-80 md:hidden',
      )}
    >
      <div className="relative z-20 grid gap-6 rounded-md bg-popover p-4 text-popover-foreground shadow-md">
        <Link href="/" className="flex items-center space-x-2">
          <Icons.logo />
          <span className="font-bold">{siteConfig.name}</span>
        </Link>
        <nav className="grid grid-flow-row auto-rows-max text-sm">
          {navItems.map((navItem, index) => (
            <Link
              key={index}
              href={navItem.disabled ? '#' : navItem.href}
              className={cn(
                'flex w-full items-center rounded-md p-2 text-sm font-medium hover:underline',
                navItem.disabled && 'cursor-not-allowed opacity-60',
              )}
            >
              {navItem.title}
            </Link>
          ))}
        </nav>
        {children}
      </div>
    </div>
  );
}
EOL
)

COMPONENTS_MOBILE_TOGGLE=$(cat << 'EOL'
'use client';

import { useTheme } from 'next-themes';
import * as React from 'react';

import { Icons } from '@/components/icons';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';

export function ModeToggle() {
  const { setTheme } = useTheme();

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="sm" className="h-8 w-8 px-0">
          <Icons.sun className="rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
          <Icons.moon className="absolute rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => setTheme('light')}>
          <Icons.sun className="mr-2 h-4 w-4" />
          <span>Light</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme('dark')}>
          <Icons.moon className="mr-2 h-4 w-4" />
          <span>Dark</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme('system')}>
          <Icons.laptop className="mr-2 h-4 w-4" />
          <span>System</span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
EOL
)

COMPONENTS_MODE_TOGGLE=$(cat << 'EOL'
'use client';

import { useTheme } from 'next-themes';
import * as React from 'react';

import { Icons } from '@/components/icons';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';

export function ModeToggle() {
  const { setTheme } = useTheme();

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="sm" className="h-8 w-8 px-0">
          <Icons.sun className="rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
          <Icons.moon className="absolute rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => setTheme('light')}>
          <Icons.sun className="mr-2 h-4 w-4" />
          <span>Light</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme('dark')}>
          <Icons.moon className="mr-2 h-4 w-4" />
          <span>Dark</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme('system')}>
          <Icons.laptop className="mr-2 h-4 w-4" />
          <span>System</span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
EOL
)

COMPONENTS_NAVBAR=$(cat << 'EOL'
'use client';

import Link from 'next/link';
import { useSelectedLayoutSegment } from 'next/navigation';
import * as React from 'react';

import { Icons } from '@/components/icons';
import { MobileNav } from '@/components/mobile-nav';
import { ModeToggle } from '@/components/mode-toggle';
import { buttonVariants } from '@/components/ui/button';
import { siteConfig } from '@/config/site';
import { cn } from '@/lib/utils';
import { NavItem } from '@/types';

interface NavbarProps extends React.HTMLAttributes<HTMLDivElement> {
  navItems?: NavItem[];
  children?: React.ReactNode;
}

export function Navbar({ navItems, children, className }: NavbarProps) {
  const segment = useSelectedLayoutSegment();
  const [showMobileMenu, setShowMobileMenu] = React.useState<boolean>(false);

  return (
    <header className={className}>
      <div className="container mx-auto flex h-16 items-center justify-between">
        <div className="flex gap-6 md:gap-10">
          <Link href="/" className="hidden items-center space-x-2 md:flex">
            <Icons.logo />
            <span className="hidden font-bold sm:inline-block">
              {siteConfig.name}
            </span>
          </Link>
          <nav className="hidden gap-6 md:flex">
            {navItems?.map((navItem, index) => (
              <Link
                key={index}
                href={navItem.disabled ? '#' : navItem.href}
                className={cn(
                  'flex items-center text-lg font-medium transition-colors hover:text-foreground/80 sm:text-sm',
                  navItem.href.startsWith(`/${segment}`)
                    ? 'text-foreground/100'
                    : 'text-foreground/50',
                  navItem.disabled && 'cursor-not-allowed opacity-80',
                )}
              >
                {navItem.title}
              </Link>
            ))}
          </nav>
          <button
            className="flex items-center space-x-2 md:hidden"
            onClick={() => setShowMobileMenu(!showMobileMenu)}
          >
            {showMobileMenu ? <Icons.close /> : <Icons.logo />}
            <span className="font-bold">Menu</span>
          </button>
          {showMobileMenu && navItems && (
            <MobileNav navItems={navItems}>{children}</MobileNav>
          )}
        </div>
        <div className="flex items-center space-x-2">
          <ModeToggle />
          <Link
            href="/login"
            className={cn(
              buttonVariants({ variant: 'secondary', size: 'sm' }),
              'px-4',
            )}
          >
            Login
          </Link>
        </div>
      </div>
    </header>
  );
}
EOL
)

COMPONENTS_TAILWIND_INDICATOR=$(cat << 'EOL'
export function TailwindIndicator() {
  if (process.env.NODE_ENV === 'production') return null;

  return (
    <div className="fixed bottom-1 left-1 z-50 flex h-6 w-6 items-center justify-center rounded-full bg-gray-800 p-3 font-mono text-xs text-white">
      <div className="block sm:hidden">xs</div>
      <div className="hidden sm:block md:hidden lg:hidden xl:hidden 2xl:hidden">
        sm
      </div>
      <div className="hidden md:block lg:hidden xl:hidden 2xl:hidden">md</div>
      <div className="hidden lg:block xl:hidden 2xl:hidden">lg</div>
      <div className="hidden xl:block 2xl:hidden">xl</div>
      <div className="hidden 2xl:block">2xl</div>
    </div>
  );
}
EOL
)

COMPONENTS_THEME_PROVIDER=$(cat << 'EOL'
'use client';

import { ThemeProvider as NextThemesProvider } from 'next-themes';
import { ThemeProviderProps } from 'next-themes';
import * as React from 'react';

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>;
}
EOL
)

CONFIG_MARKETING=$(cat << 'EOL'
import { MarketingConfig } from '@/types';

export const marketingConfig: MarketingConfig = {
  navItems: [
    {
      title: 'Features',
      href: '/#features',
    },
    {
      title: 'Pricing',
      href: '/pricing',
    },
    {
      title: 'Demo',
      href: '/demo',
      disabled: true,
    },
    {
      title: 'Documentation',
      href: '/docs',
    },
  ],
};
EOL
)

CONFIG_SITE=$(cat << 'EOL'
import { SiteConfig } from '@/types';

export const siteConfig: SiteConfig = {
  name: 'NextKit',
  description: 'Next.js + TypeScript SaaS Starter',
  url: 'https://next-kit.com',
  links: {
    twitter: 'https://twitter.com/pengyuc_',
    github: 'https://github.com/walkccc/nextkit',
  },
};
EOL
)

HOOKS_USE_LOCK_BODY=$(cat << 'EOL'
import * as React from 'react';

// @see https://usehooks.com/useLockBodyScroll.
export function useLockBody() {
  React.useLayoutEffect((): (() => void) => {
    const originalStyle: string = window.getComputedStyle(
      document.body,
    ).overflow;
    document.body.style.overflow = 'hidden';
    return () => (document.body.style.overflow = originalStyle);
  }, []);
}
EOL
)

I18N_REQUEST=$(cat << 'EOL'
import { getRequestConfig } from 'next-intl/server';

import { routing } from '@/i18n/routing';

export default getRequestConfig(async ({ requestLocale }) => {
  // This typically corresponds to the `[locale]` segment
  let locale = await requestLocale;

  // Ensure that a valid locale is used
  if (!locale || !routing.locales.includes(locale as 'en' | 'zh')) {
    locale = routing.defaultLocale;
  }

  return {
    locale,
    messages: (await import(`../public/locales/${locale}.json`)).default,
  };
});
EOL
)

I18N_ROUTING=$(cat << 'EOL'
import { createNavigation } from 'next-intl/navigation';
import { defineRouting } from 'next-intl/routing';

export const routing = defineRouting({
  locales: ['en', 'zh'],
  defaultLocale: 'en',
});

// Lightweight wrappers around Next.js' navigation APIs
// that will consider the routing configuration
export const { Link, redirect, usePathname, useRouter, getPathname } =
  createNavigation(routing);
EOL
)

PUBLIC_LOCALES_EN=$(cat << 'EOL'
{
  "Marketing": {
    "title": "Build your SaaS in minutes with NextKit",
    "description": "Dive into the NextJS boilerplate – your toolkit for crafting SaaS, AI wonders, or any cool web app, and speedily pocket your first online bucks!",
    "get-nextkit": "Get NextKit",
    "view-on-github": "View on GitHub",
    "features": {
      "title": "Features",
      "description": "Explore the latest features and tutorials on NextKit.",
      "nextjs": "Next.js 15",
      "nextjs-description": "App dir, Routing, Layouts, Loading UI 和 API routes.",
      "react": "React 19",
      "react-description": "Server and Client Components. Use hook.",
      "database": "Database",
      "database-description": "ORM using Prisma and deployed on Neon.tech.",
      "components": "Components",
      "components-description": "UI components built using shadcn/ui and styled with Tailwind CSS.",
      "authentication": "Authentication",
      "authentication-description": "Authentication using NextAuth.js and middlewares.",
      "subscriptions": "Subscriptions",
      "subscriptions-description": "Free and paid subscriptions using Stripe.",
      "blog": "NextKit also includes a blog and a full-featured documentation site built using Velite and MDX.",
      "boost": {
        "title": "Boost your app to the next level in a flash and watch the $$ roll in!",
        "ad-1": "Whiz through user logins, payments, and emails like a pro.",
        "ad-2": "Spend less time wrangling APIs and more on your startup masterpiece.",
        "ad-3": "NextKit hands you the perfect boilerplate to launch at warp speed!"
      }
    }
  }
}
EOL
)

PUBLIC_LOCALES_ZH=$(cat <<'ELO'
{
  "Marketing": {
    "title": "使用 NextKit 在幾分鐘內打造您的 SaaS",
    "description": "深入了解 NextJS 模板 – 您的工具包，用於打造 SaaS、AI 奇蹟或任何酷炫的網頁應用，並快速賺取您的第一筆在線收入！",
    "get-nextkit": "取得 NextKit",
    "view-on-github": "在 GitHub 上查看",
    "features": {
      "title": "功能",
      "description": "探索 NextKit 的最新功能和教程。",
      "nextjs": "Next.js 15",
      "nextjs-description": "App dir, Routing, Layouts, Loading UI 和 API routes.",
      "react": "React 19",
      "react-description": "服務端和客戶端組件。使用 hook。",
      "database": "資料庫",
      "database-description": "使用 Prisma 的 ORM 並部署在 Neon.tech 上。",
      "components": "組件",
      "components-description": "使用 shadcn/ui 構建的 UI 組件，並使用 Tailwind CSS 進行樣式設計。",
      "authentication": "身份驗證",
      "authentication-description": "使用 NextAuth.js 和 middleware 進行身份驗證。",
      "subscriptions": "訂閱",
      "subscriptions-description": "使用 Stripe API 進行免費和付費訂閱管理。",
      "blog": "NextKit 還包括一個使用 Velite 和 MDX 構建的部落格和功能齊全的文檔網站。"
    },
    "boost": {
      "title": "快速提升您的應用程式到下一個級別，並觀看收入滾滾而來！",
      "ad-1": "像專業人士一樣快速完成用戶登錄、付款和電子郵件。",
      "ad-2": "花更少的時間處理 API，更多時間專注於您的創業傑作。",
      "ad-3": "NextKit 為您提供完美的樣板，以光速啟動！"
    }
  }
}
ELO
)

function update_or_create_file() {
  local filename="$1"
  local content="$2"
  local directory=$(dirname "$filename")
  mkdir -p "$directory"
  if [ -f "$filename" ]; then
    echo "$content" >|"$filename"
    echo "$filename has been updated."
  else
    echo "$content" >"$filename"
    echo "$filename has been created."
  fi
}

update_or_create_file "middlewire.ts" "$MIIDDLEWARE"
update_or_create_file "next.config.ts" "$NEXT_CONFIG"
update_or_create_file "tailwind.config.ts" "$TAILWIND_CONFIG"
update_or_create_file "app/layout.tsx" "$APP_LAYOUT"
update_or_create_file "app/[locale]/marketing/layout.tsx" "$APP_LOCALE_MARKETING_LAYOUT"
update_or_create_file "app/[locale]/marketing/page.tsx" "$APP_LOCALE_MARKETING_PAGE"
update_or_create_file "components/footer" "$COMPONENTS_FOOTER"
update_or_create_file "components/icons.tsx" "$COMPONENTS_ICON"
update_or_create_file "components/mobile-nav.tsx" "$COMPONENTS_MOBILE_NAV"
update_or_create_file "components/mobile-toggle.tsx" "$COMPONENTS_MOBILE_TOGGLE"
update_or_create_file "components/mode-toggle.tsx" "$COMPONENTS_MODE_TOGGLE"
update_or_create_file "components/navbar.tsx" "$COMPONENTS_NAVBAR"
update_or_create_file "components/tailwind-indicator.tsx" "$COMPONENTS_TAILWIND_INDICATOR"
update_or_create_file "components/theme-provider.tsx" "$COMPONENTS_THEME_PROVIDER"
update_or_create_file "config/marketing.ts" "$CONFIG_MARKETING"
update_or_create_file "config/site.ts" "$CONFIG_SITE"
update_or_create_file "hooks/use-lock-body.ts" "$HOOKS_USE_LOCK_BODY"
update_or_create_file "i18n/request.ts" "$I18N_REQUEST"
update_or_create_file "i18n/routing.ts" "$I18N_ROUTING"
update_or_create_file "public/locales/en.json" "$PUBLIC_LOCALES_EN"
update_or_create_file "public/locales/zh.json" "$PUBLIC_LOCALES_ZH"

npm install next-intl
npm install next-themes
npm install -D @tailwindcss/typography
npx shadcn-ui@latest add button dropdown-menu toast

git add .
git commit -m <<EOF
feat(ui): add \`app/layout\` and \`app/[locale]/(marketing)\`

\`\`\`bash
bash <(curl -s https://raw.githubusercontent.com/walkccc/snippets/main/init-next-app-layout-and-i18n.sh)
\`\`\`
EOF
