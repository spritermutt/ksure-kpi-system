"use client" // <--- บรรทัดนี้สำคัญมาก! บอกว่าเป็น Client Component

import { useState } from "react"
import { signIn } from "next-auth/react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Mail,Lock } from "lucide-react"

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
    <div className="flex items-center justify-center min-h-screen bg-white">
      <div className="flex gap-[5px] w-full max-w-6xl mx-auto p-4">
      {/* Left Section */}
      <div className="flex-1 flex items-center justify-center rounded-[20px] min-h-[800px] ">
        <div className="relative w-full h-full rounded-[20px] overflow-hidden">
          <img 
            src="/LoginBG.jpg" 
            alt="KSURE KPI Background" 
            className="w-full h-full object-cover"
          />
          {/* Inner Shadow Overlay */}
          <div className="absolute inset-0 shadow-[inset_0_0_50px_rgba(0,0,0,0.6)] pointer-events-none" />
                    <div className="absolute inset-0 shadow-[inset_0_0_50px_rgba(0,0,0,0.6)] pointer-events-none" >
                      <span className="text-white text-[1024px] font-bold z-1">K</span>
                      </div>
          <h1 className="absolute top-10 left-10 text-white text-5xl font-bold z-10">
            Work Smart, <br /> Track Clearly
          </h1>
        </div>
      </div>
      <div className="flex-1 flex items-center justify-center rounded-[20px] max-w-[400px]">
      {/* Right Section - Login Form */}
      <Card className="w-[350px] p-6 rounded-[20px] ">
        <CardHeader className="space-y-1">
          <img src="/Logo.png" alt="KSURE Logo" className="w-full mx-auto mb-4" />
        <CardTitle className="text-4xl font-bold text-center text-destructive">Login</CardTitle>
        </CardHeader>
        
        <form onSubmit={handleSubmit}>
        <CardContent className="grid gap-4">
          {error && <div className="text-red-500 text-sm text-center bg-red-50 p-2 rounded">{error}</div>}
          
            <div className="grid gap-2">
            <Label htmlFor="email" className="font-black text-xl text-primary">E-mail</Label>
            <div className="relative">
              <Input
              id="email"
              type="email"
              placeholder="mail@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="rounded-[20px] border-primary border-2 pl-10 bg-bg placeholder:text-black/10 placeholder:font-boldasd"
              required
              />
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary font-bold" strokeWidth={3} />
            </div>
            </div>
          <div className="grid gap-2">
          <Label htmlFor="password" className="font-black text-xl text-primary">Password</Label>
          <div className="relative">
          <Input 
            id="password" 
            type="password" 
            placeholder="••••••••" 
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="rounded-[20px] border-primary border-2 pl-10 bg-bg placeholder:text-black/10 placeholder:font-bold"
            required
          />
          <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary" strokeWidth={3}/>
          </div>
          </div>
        </CardContent>
        <CardFooter className="mt-5">
              <div className="w-full flex flex-col gap-4">
              <Button className="w-full rounded-[20px] font-black text-xl" disabled={loading}>
                {loading ? "Verifying..." : "Sign In"}
              </Button>
              <hr className="border border-secondary/10" />
              <div className="w-full flex justify-center ">
                <span className="text-sm text-destructive cursor-pointer hover:none font-bold">Forget Password?</span>
              </div>
              </div>
        </CardFooter>
        </form>
      </Card>
      </div>
      </div>
    </div>
  )
}
