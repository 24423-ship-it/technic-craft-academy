# Technic Craft Academy — Supabase Auth + Vercel

เว็บนี้ใช้ **Supabase Auth Email OTP** สำหรับส่งรหัส OTP ทางอีเมล และใช้ Vercel สำหรับโฮสต์หน้าเว็บและ serverless config endpoint

## 1) ตั้งค่า Supabase

1. สร้างโปรเจกต์ที่ https://supabase.com/ แล้วเปิด Project Settings > API
2. คัดลอก Project URL และ Publishable key (หรือ anon/public key รุ่นเดิม)
3. ไปที่ Authentication > Providers > Email แล้วเปิดใช้งาน Email provider และ Email OTP
4. ตั้งค่า OTP length เป็น **6** และ OTP expiry เป็น **300 วินาที** (5 นาที)
5. ไปที่ Authentication > URL Configuration แล้วเพิ่ม Production URL ของ Vercel ใน Site URL และ Redirect URLs เช่น `https://your-project.vercel.app/**`
6. ตั้งค่า SMTP แบบกำหนดเองใน Authentication > SMTP Settings เพื่อให้อีเมลส่งถึงผู้ใช้ได้เสถียร (Supabase built-in email มีข้อจำกัดการส่ง)
7. ไปที่ Authentication > Email Templates > Magic Link แล้วใช้ `{{ .Token }}` ในเนื้อหาอีเมลเพื่อแสดงรหัส OTP เช่น:

   `รหัสยืนยัน Technic Craft Academy ของคุณคือ {{ .Token }}`

8. เปิด SQL Editor แล้วรันไฟล์ `supabase/schema.sql` เพื่อสร้างตารางโปรไฟล์นักเรียนและผลสอบ พร้อม Row Level Security

## 2) Deploy ไป Vercel

1. อัปโหลดโฟลเดอร์นี้ขึ้น GitHub repository
2. เข้า https://vercel.com/ แล้วกด Add New > Project และ Import repository
3. Framework Preset เลือก Other; ไม่ต้องตั้ง Build Command และ Output Directory ให้ใช้ค่าเริ่มต้น
4. ใน Project Settings > Environment Variables เพิ่ม:
   - `SUPABASE_URL` = Project URL จาก Supabase
   - `SUPABASE_ANON_KEY` = Publishable/anon public key จาก Supabase
5. กด Deploy และเปิด URL ที่ Vercel ให้มา

`SUPABASE_ANON_KEY` เป็น public key ที่ใช้ใน browser ได้เมื่อเปิด RLS ตาม SQL นี้แล้ว **ห้ามใส่ service_role/secret key ใน HTML หรือ Environment Variable ที่เปิดเผยให้ browser**

## 3) การทำงาน

- นักเรียนกรอกอีเมล > Supabase ส่ง OTP > กรอก OTP 6 หลักเพื่อยืนยัน
- Supabase จัดการ session และ refresh token
- โปรไฟล์นักเรียนเก็บใน `student_profiles`
- ผลสอบล่าสุดเก็บใน `quiz_results`
- RLS จำกัดให้ผู้ใช้แต่ละคนอ่าน/แก้ไขข้อมูลของตัวเองเท่านั้น

## 4) ข้อควรทราบ

- ไฟล์ HTML เดี่ยวที่เปิดด้วย `file://` จะใช้ API config ไม่ได้ ต้องเปิดผ่าน Vercel หรือ web server
- การส่งอีเมลจริงขึ้นกับการตั้งค่า SMTP และ Email Template ใน Supabase
- ตาราง `quiz_results` เก็บผลสอบล่าสุดต่อบัญชีผู้ใช้หนึ่งบัญชี (upsert)
- การจัดการนักเรียน/ดูผลรวมในมุมมองครูยังต้องเพิ่มระบบ role และหน้า admin แยกต่างหาก
