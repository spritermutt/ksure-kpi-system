"use client" // <--- บรรทัดนี้สำคัญมาก! บอกว่าเป็น Client Component

import { useState } from "react"
import { signIn } from "next-auth/react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError("")

    try {
      // ส่งข้อมูลไปเช็คกับ NextAuth
      const result = await signIn("credentials", {
        email,
        password,
        redirect: false, // ไม่ให้เปลี่ยนหน้าเอง เราจะคุมเอง
      })

      if (result?.error) {
        setError("อีเมลหรือรหัสผ่านไม่ถูกต้อง")
        setLoading(false)
      } else {
        // ถ้าผ่าน ให้ไปหน้า Dashboard (เดี๋ยวเราค่อยสร้างหน้านี้)
        router.push("/dashboard") 
      }
    } catch (err) {
      setError("เกิดข้อผิดพลาด กรุณาลองใหม่")
      setLoading(false)
    }
  }

  return (
    <div className="flex items-center justify-center min-h-screen bg-slate-100">
      <Card className="w-[350px] shadow-xl border-slate-200">
        <CardHeader className="space-y-1">
          <CardTitle className="text-2xl font-bold text-center">KSURE KPI</CardTitle>
          <CardDescription className="text-center">เข้าสู่ระบบเพื่อใช้งาน</CardDescription>
        </CardHeader>
        
        <form onSubmit={handleSubmit}>
          <CardContent className="grid gap-4">
            {error && <div className="text-red-500 text-sm text-center bg-red-50 p-2 rounded">{error}</div>}
            
            <div className="grid gap-2">
              <Label htmlFor="email">อีเมล</Label>
              <Input 
                id="email" 
                type="email" 
                placeholder="admin@example.com" 
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="grid gap-2">
              <Label htmlFor="password">รหัสผ่าน</Label>
              <Input 
                id="password" 
                type="password" 
                placeholder="••••••••" 
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
          </CardContent>
          
          <CardFooter>
            <Button className="w-full" disabled={loading}>
              {loading ? "กำลังตรวจสอบ..." : "เข้าสู่ระบบ"}
            </Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  )
}
