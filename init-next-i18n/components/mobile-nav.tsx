import Link from 'next/link';
import { useParams } from 'next/navigation';
import * as React from 'react';

import { Icons } from '@/components/icons';
import { siteConfig } from '@/config/site';
import { useLockBody } from '@/hooks/use-lock-body';
import { cn } from '@/lib/utils';
import { NavItem } from '@/types';

interface MobileNavProps extends React.HTMLAttributes<HTMLDivElement> {
  navItems: NavItem[];
  children?: React.ReactNode;
}

export function MobileNav({ navItems, children }: MobileNavProps) {
  const { locale } = useParams();

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
              href={navItem.disabled ? '#' : `/${locale}${navItem.href}`}
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
