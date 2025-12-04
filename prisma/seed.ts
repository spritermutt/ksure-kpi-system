import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

async function main() {
  // 1. สร้างแผนก (ถ้ายังไม่มี)
  const itDept = await prisma.departments.upsert({
    where: { department_id: 1 }, // สมมติว่าเช็คจาก ID
    update: {},
    create: {
      department_name: 'Information Technology',
    },
  })

  // 2. สร้าง Admin (ถ้ายังไม่มี)
  const password = await bcrypt.hash('123456', 10)
  await prisma.users.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      full_name: 'System Admin',
      email: 'admin@example.com',
      password_hash: password,
      role: 'admin',
      invited_by: 1, // (อาจต้องปรับ logic ตรงนี้หน่อยตาม constraint)
      department_id: itDept.department_id
    },
  })

  console.log("🌱 Seeding ข้อมูลเสร็จเรียบร้อย!")
}

main()
  .then(async () => await prisma.$disconnect())
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
