import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'

// Prisma v7 ต้องการให้ใส่ option อย่างน้อย 1 อย่าง หรือเป็น object ว่าง
// เราใส่ log เพื่อให้เห็นว่ามันทำงานอยู่ และช่วยแก้ error "non-empty options"
const prisma = new PrismaClient({
  log: ['info', 'warn', 'error'],
})

async function main() {
  console.log("⏳ กำลังสร้างรหัสผ่าน...")
  
  // 1. สร้าง Hash รหัสผ่าน "123456"
  const hashedPassword = await bcrypt.hash("123456", 10)

  // 2. อัปเดต Admin (User ID 1)
  // หมายเหตุ: ต้องมั่นใจว่าใน Database มี User ID 1 อยู่แล้ว (จากไฟล์ SQL)
  try {
    await prisma.users.update({
      where: { user_id: 1 },
      data: { password_hash: hashedPassword }
    })
    console.log("✅ สำเร็จ! อัปเดตรหัสผ่าน Admin เป็น '123456' เรียบร้อยแล้ว")
  } catch (error) {
    console.error("❌ ไม่พบ User ID 1 หรือเกิดข้อผิดพลาดอื่น:", error)
  }
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => await prisma.$disconnect())
