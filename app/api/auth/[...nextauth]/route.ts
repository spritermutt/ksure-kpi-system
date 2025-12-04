import NextAuth, { AuthOptions } from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { PrismaClient } from "@prisma/client"
import bcrypt from "bcryptjs"

const prisma = new PrismaClient()

export const authOptions: AuthOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) return null

        // 1. ค้นหา User จากอีเมล
        const user = await prisma.users.findUnique({
          where: { email: credentials.email }
        })

        // 2. ถ้าไม่เจอ User หรือ User ไม่มีรหัสผ่าน
        if (!user || !user.password_hash) {
          throw new Error("User not found")
        }

        // 3. เช็คว่ารหัสผ่านตรงกันไหม
        const isValid = await bcrypt.compare(credentials.password, user.password_hash)

        if (!isValid) {
          throw new Error("Invalid password")
        }

        // 4. ถ้าถูกต้อง ส่งข้อมูล User กลับไปเก็บใน Session
        return {
          id: user.user_id.toString(),
          name: user.full_name,
          email: user.email,
          role: user.role, // ส่ง Role ไปด้วย
          departmentId: user.department_id
        }
      }
    })
  ],
  pages: {
    signIn: '/', // บอกว่าหน้า Login ของเราคือหน้าแรก
  },
  callbacks: {
    async jwt({ token, user }: any) {
      if (user) {
        token.role = user.role
        token.id = user.id
      }
      return token
    },
    async session({ session, token }: any) {
      if (session.user) {
        (session.user as any).role = token.role;
        (session.user as any).id = token.id;
      }
      return session
    }
  },
  secret: process.env.NEXTAUTH_SECRET || "secret-key-mhai-tong-sai-kaw-dai", // ใส่คีย์ลับอะไรก็ได้
}

const handler = NextAuth(authOptions)
export { handler as GET, handler as POST }
