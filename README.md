# LexGuard — ชุดข้อมูลส่งออก

ข้อมูลทั้งหมดจากฐานข้อมูลทะเบียนกฎหมาย SHE ส่งออกเมื่อ **20 สิงหาคม 2569**
รวม **1,002 แถว จาก 33 ตาราง**

ต้นทาง: Supabase project `exugnmdsyqbqtxsrwhbm` (legal-registry 2)

---

## โครงสร้างโฟลเดอร์

```
lexguard-export/
├── README.md                 ← ไฟล์นี้
├── data/
│   ├── csv/                  33 ไฟล์ · เปิดด้วย Excel / Google Sheets ได้เลย
│   ├── json/                 33 ไฟล์ · ข้อมูลครบทุก field ไม่มีการแปลงค่า
│   ├── sql/                  33 ไฟล์ · คำสั่ง INSERT สำหรับกู้คืนลงฐานข้อมูล
│   ├── restore-all.sql       สคริปต์กู้คืนทุกตารางตามลำดับที่ถูกต้อง
│   └── manifest.json         สรุปจำนวนแถว/คอลัมน์ของแต่ละตาราง
├── schema/
│   ├── schema.sql            โครงสร้างฐานข้อมูลฉบับเต็ม (ตาราง view index policy comment)
│   └── migrations/           ประวัติการแก้โครงสร้าง 41 ไฟล์ (001–041)
├── supabase-functions/       Edge Functions ฝั่ง Supabase (ai-law-search, ai-law-summary)
└── app-config/               ← ส่วน Vercel
    ├── VERCEL.md             อธิบายการตั้งค่า env var และวิธี deploy
    ├── vercel.json           build config + เพดานเวลา 300 วิของแต่ละ function
    ├── package.json          dependencies และคำสั่ง build
    ├── .env.example          รายชื่อ environment variable
    └── api/                  serverless functions 9 ไฟล์ (law-analyze, law-relate, _lib)
```

> ฝั่งเซิร์ฟเวอร์แยกเป็นสองที่: **Vercel** รัน `app-config/api/` (งาน AI หนักๆ ที่ต้องใช้เวลา
> ถึง 300 วินาที) ส่วน **Supabase Edge Functions** อยู่ใน `supabase-functions/`
> รายละเอียดการตั้งค่าฝั่ง Vercel อ่านที่ `app-config/VERCEL.md`

---

## ตารางที่มีข้อมูล

### ระบบทะเบียนกฎหมายปัจจุบัน (`lg_*`)

| ตาราง | แถว | เนื้อหา |
|---|---:|---|
| `lg_laws` | 161 | ทะเบียนกฎหมาย — ชื่อ หน่วยงาน วันประกาศ/บังคับใช้ สถานะ เลขราชกิจจาฯ |
| `lg_requirements` | 576 | ข้อปฏิบัติรายข้อของแต่ละกฎหมาย + ผลประเมินความสอดคล้อง |
| `lg_communications` | 26 | เมทริกซ์การสื่อสารภายใน/ภายนอก + รอบกำหนดส่ง |
| `lg_ref_answers` | 22 | คำตอบที่ AI สรุปจากกฎหมายที่ถูกอ้างถึง (cache ตาม topic_key) |
| `lg_activity_log` | 21 | บันทึกการเพิ่ม/ยกเลิก/แก้ไขกฎหมาย |
| `lg_reports` | 19 | รายงานที่ต้องยื่นราชการ + กำหนดส่งครั้งถัดไป |
| `lg_departments` | 16 | หน่วยงานผู้รับผิดชอบ |
| `lg_law_refs` | 16 | ตัวบทของกฎหมายที่ถูกอ้างถึง พร้อมลิงก์แหล่งที่มา |
| `lg_process_substatus` | 15 | ตารางอ้างอิงสถานะย่อยของแต่ละขั้นตอน |
| `lg_compliance_months` | 14 | การติ๊กทวนสอบรายเดือน |
| `lg_law_quarter_stats` | 14 | สถิติกฎหมายเพิ่ม/ยกเลิก รายไตรมาส |
| `lg_categories` | 7 | หมวดกฎหมาย (LA–LG) |
| `lg_notification_log` | 5 | ประวัติการแจ้งเตือน |
| `lg_ai_discovered_laws` | 5 | คิวกฎหมายที่ AI ค้นเจอ/สรุปไว้ |
| `lg_improvement_plans` | 2 | แผนปรับปรุงกรณีไม่สอดคล้อง |
| `lg_search_log` | 2 | ประวัติการค้นหากฎหมายใหม่ |
| `lg_import_staging` | 2 | (เลิกใช้แล้ว) staging เดิมก่อนเปลี่ยนมาใช้ `lg_ai_discovered_laws` |
| `lg_settings` | 1 | ชื่อองค์กร/หัวเรื่องที่แสดงในระบบ |

### ชุดข้อมูลเดิมก่อนย้ายมาโครงสร้าง `lg_*`

| ตาราง | แถว | เนื้อหา |
|---|---:|---|
| `communication_matrix` | 21 | เมทริกซ์การสื่อสารฉบับเดิม |
| `laws` | 19 | ทะเบียนกฎหมายฉบับเดิม |
| `compliance_summary` | 18 | สรุปความสอดคล้องรายหมวดรายปี |
| `regulatory_documents` | 14 | เอกสารที่ต้องยื่นราชการฉบับเดิม |
| `law_categories` | 6 | หมวดกฎหมายฉบับเดิม |

### ตารางที่มีโครงสร้างแต่ยังไม่มีข้อมูล

`lg_law_workflow`, `lg_assessment_flow`, `lg_process_tracker`, `lg_process_items`,
`lg_review_log`, `lg_attachments`, `lg_agent_queue`, `lg_agent_runs`,
`lg_law_updates`, `compliance_logs` — ส่งออกเป็นไฟล์เปล่าไว้ให้ครบชุด

---

## วิธีกู้คืนลงฐานข้อมูลใหม่

```bash
# 1. สร้างโครงสร้าง
psql "<connection string>" -f schema/schema.sql

# 2. ใส่ข้อมูล (ต้องรันจากในโฟลเดอร์ lexguard-export)
psql "<connection string>" -f data/restore-all.sql
```

ถ้าใช้ Supabase SQL Editor ที่เปิดทีละไฟล์ ให้วางเนื้อหา `schema/schema.sql` ก่อน
แล้วค่อยวางไฟล์ใน `data/sql/` ทีละตารางตามลำดับที่ระบุใน `data/restore-all.sql`
(ลำดับสำคัญ เพราะตารางลูกอ้างถึงตารางแม่)

ไฟล์ SQL ใช้วิธีให้ Postgres แปลงค่าจาก JSON เอง จึงรองรับข้อความไทย เครื่องหมายคำพูด
การขึ้นบรรทัดใหม่ ค่า jsonb และ array ได้ถูกต้องโดยไม่ต้องแก้อะไรเพิ่ม

---

## หมายเหตุ

- **ไฟล์ CSV มี BOM** เพื่อให้ Excel อ่านภาษาไทยไม่เป็นตัวต่างด้าว ถ้าเปิดด้วยโปรแกรมอื่น
  แล้วเห็นอักขระแปลกที่ต้นไฟล์ ให้เลือก encoding เป็น UTF-8
- **ค่า id เดิมถูกเก็บไว้ทุกแถว** ความสัมพันธ์ระหว่างตาราง (เช่น `lg_requirements.law_id`
  → `lg_laws.id`) จึงยังตรงกันหลังกู้คืน
- **ไม่มีตารางสำรอง 6 ตัว** (`lg_requirements_bak_20260717`, `lg_laws_datebackup_20260721`,
  `lg_laws_ccsbak_20260731`, `lg_requirements_ccsbak_20260731`,
  `lg_categories_ccsbak_20260731`, `lg_laws_datefix_bak_20260731`)
  ตารางเหล่านี้เป็นสแนปช็อตเก่าที่แอปไม่ได้ใช้ และถูกตั้งค่าปิดการเข้าถึงจากภายนอกไว้
  โครงสร้างของมันยังอยู่ใน `schema/schema.sql`
- **ไม่มีรหัสผ่านหรือคีย์ใดๆ ในโฟลเดอร์นี้** `app-config/.env.example` เป็นไฟล์ตัวอย่าง
  ที่มีแต่ชื่อตัวแปร ผู้รับต้องใส่ค่าเอง
