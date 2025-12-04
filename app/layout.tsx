import type { Metadata } from "next";
import { Noto_Sans_Thai } from "next/font/google"; 
import "./globals.css";
import { cn } from "@/lib/utils";

const fontSans = Noto_Sans_Thai({
  subsets: ["latin", "thai"],
  variable: "--font-sans", 
  weight: ["300", "400", "500", "600", "700"],
});

export const metadata: Metadata = {
  title: "KSURE KPI",
  description: "ระบบติดตามและประเมินผล KR/KPI",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="th">
      <body
        className={cn(
          "min-h-screen bg-background font-sans antialiased",
          fontSans.variable // 3. ยัดตัวแปรฟอนต์เข้าไป
        )}
      >
        {children}
      </body>
    </html>
  );
}