import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: '⚽ ThreeFourThree - Football Tournament Management',
  description: 'Tournament management system for football/soccer',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
