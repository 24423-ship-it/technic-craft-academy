# Technic Craft Academy — Supabase Auth + Vercel

เว็บนี้ใช้ **Supabase Auth Email OTP** สำหรับส่งรหัส OTP ทางอีเมล และใช้ Vercel สำหรับโฮสต์หน้าเว็บและ serverless config endpoint

## 1) ตั้งค่า Supabase

1. สร้างโปรเจกต์ที่ https://supabase.com/ แล้วเปิด Project Settings > API
2. คัดลอก Project URL และ Publishable key (หรือ anon/public key รุ่นเดิม)
3. ไปที่ Authentication > Providers > Email แล้วเปิดใช้งาน Email provider และ Email OTP
4. ตั้งค่า OTP length เป็น **6** และ OTP expiry เป็น **300 วินาที** (5 นาที)
5. ไปที่ Authentication > URL Configuration แล้วเพิ่ม Production URL ของ Vercel ใน Site URL และ Redirect URLs เช่น `https://your-project.vercel.app/**`
6. ตั้งค่า SMTP แบบกำหนดเองใน Authentication > SMTP Settings เพื่อให้อีเมลส่งถึงผู้ใช้ได้เสถียร
7. ไปที่ Authentication > Email Templates > Magic Link แล้วใช้ `{{ .Token }}` ในเนื้อหาอีเมลเพื่อแสดงรหัส OTP
8. เปิด SQL Editor แล้วรันไฟล์ `supabase/schema.sql`

## 2) Deploy ไป Vercel

1. เข้า https://vercel.com/ แล้วเลือก Add New > Project และ Import repository นี้
2. Framework Preset เลือก Other
3. เพิ่ม Environment Variables:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. กด Deploy

ห้ามใส่ service_role/secret key ใน HTML หรือค่าที่เปิดเผยให้ browser

## 3) ข้อควรทราบ

- การส่งอีเมลจริงขึ้นกับการตั้งค่า SMTP และ Email Template ใน Supabase
- ตาราง `quiz_results` เก็บผลสอบล่าสุดต่อบัญชีผู้ใช้หนึ่งบัญชี
- ระบบ role และหน้า admin สำหรับครูยังต้องพัฒนาเพิ่มเติม
