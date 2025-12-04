import { getServerSession } from "next-auth"
import { authOptions } from "../api/auth/[...nextauth]/route"
import { redirect } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export default async function DashboardPage() {
  // 1. ดึงข้อมูล Session จาก Server (ปลอดภัยกว่าทำหน้าบ้าน)
  const session = await getServerSession(authOptions)

  // 2. ถ้ายังไม่ล็อกอิน ให้ดีดกลับไปหน้าแรก
  if (!session) {
    redirect("/")
  }

  return (
    <div className="p-8 min-h-screen bg-slate-50">
      <div className="max-w-4xl mx-auto space-y-6">
        
        {/* หัวข้อทักทาย */}
        <div className="flex justify-between items-center">
          <h1 className="text-3xl font-bold tracking-tight text-slate-900">
            Dashboard
          </h1>
          <div className="text-sm text-slate-500">
             สวัสดี, <span className="font-semibold text-slate-900">{session.user?.name}</span>
          </div>
        </div>

        {/* การ์ดแสดงข้อมูล */}
        <div className="grid gap-4 md:grid-cols-3">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">ตำแหน่ง</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold uppercase">{session.user?.role || "User"}</div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">แผนก</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">IT Support</div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">สถานะ</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">Active</div>
            </CardContent>
          </Card>
        </div>

        {/* ปุ่ม Logout แบบบ้านๆ (เดี๋ยวเราค่อยทำปุ่มดีๆ ทีหลัง) */}
        <div className="mt-8">
            <a href="/api/auth/signout">
                <Button variant="destructive">ออกจากระบบ</Button>
            </a>
        </div>

      </div>
    </div>
  )
}
