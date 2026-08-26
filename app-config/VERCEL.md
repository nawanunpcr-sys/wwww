# ส่วน Vercel

โฟลเดอร์นี้คือทุกอย่างที่ใช้รันฝั่งเซิร์ฟเวอร์บน Vercel

```
app-config/
├── vercel.json        การตั้งค่า build + เพดานเวลาของแต่ละ function
├── package.json       dependencies และคำสั่ง build
├── .env.example       รายชื่อ environment variable (ค่าเป็นตัวอย่าง ต้องใส่เอง)
└── api/               serverless functions · 9 ไฟล์ 2,579 บรรทัด
    ├── law-analyze.js       สรุปกฎหมาย + แตกเป็นข้อปฏิบัติ
    ├── law-relate.js        ตามอ่านกฎหมายที่ตัวบทอ้างถึง
    └── _lib/                โค้ดที่สอง endpoint ใช้ร่วมกัน
        ├── guard.js             กันเรียกข้ามโดเมน + จำกัด 10 ครั้ง/นาที/IP
        ├── anchor-answer.js     หาคำตอบจากตัวบทที่ถูกอ้างถึง
        ├── osh-law-relate.js    ตรรกะหลักของการตามอ้างอิง
        ├── law-source.js        ดึงตัวบทจากแหล่งที่เชื่อถือได้
        ├── ref-classify.js      แยกประเภทการอ้างอิง
        ├── verify-numbers.js    กันไม่ให้ AI แต่งตัวเลขเอง
        └── effective-date.js    คำนวณวันบังคับใช้
```

## การตั้งค่าใน vercel.json

| ค่า | ที่ตั้งไว้ |
|---|---|
| framework | `vite` |
| build command | `npm run build` |
| output directory | `dist` |
| `api/law-analyze.js` maxDuration | 300 วินาที |
| `api/law-relate.js` maxDuration | 300 วินาที |
| rewrites | ทุก path ที่ไม่ขึ้นต้นด้วย `api/` ส่งไปที่ `/` (SPA routing) |

maxDuration 300 วินาทีเป็นเพดานสูงสุดของแพลนที่ใช้อยู่ และงานสรุปกฎหมายถูก
**ตั้งใจแยกเป็น 2 endpoint** เพราะเดิมทำต่อกันในคำขอเดียวแล้วชนเพดานเป็นประจำ
ถ้าย้ายไปแพลนที่เพดานต่ำกว่า 300 วินาที ต้องปรับค่านี้และคาดหวังว่างานจะทำไม่จบ

## Environment variables ที่ต้องตั้ง

โค้ดฝั่ง Vercel เรียกใช้ 5 ตัวนี้:

| ชื่อ | ใช้ที่ไหน | จำเป็น |
|---|---|---|
| `VITE_SUPABASE_URL` | ทั้ง frontend และ api | ต้องมี |
| `VITE_SUPABASE_ANON_KEY` | ทั้ง frontend และ api | ต้องมี |
| `ANTHROPIC_API_KEY` | `api/` เท่านั้น (ห้ามให้หลุดไป frontend) | ต้องมี ถ้าจะใช้ฟีเจอร์ AI |
| `ANTHROPIC_MODEL` | `api/` — ใช้ทับรุ่นเริ่มต้น | ไม่จำเป็น |
| `ALLOWED_ORIGIN` | `api/_lib/guard.js` — โดเมนที่อนุญาต คั่นด้วย comma | ไม่จำเป็น |

`ALLOWED_ORIGIN` ไม่จำเป็นเมื่อ deploy บน `*.vercel.app` เพราะ `guard.js` ยอมรับ
same-origin อยู่แล้ว แต่ **ถ้าผูกโดเมนของตัวเอง ต้องตั้งค่านี้** ไม่งั้น endpoint AI
จะปฏิเสธคำขอทั้งหมด

นอกจากนี้ frontend ยังใช้ `VITE_AUTH_MODE` และ `VITE_DEMO_PASSWORD` (ดู `.env.example`)

## วิธี deploy

```bash
# ในโฟลเดอร์ที่มีโค้ดแอปครบ (ไม่ใช่โฟลเดอร์ export นี้)
npm install
vercel                 # ครั้งแรก — สร้างโปรเจกต์ใหม่ในบัญชีของผู้รับ
vercel env add ANTHROPIC_API_KEY production
vercel --prod
```

## หมายเหตุ

- **ไม่ได้แนบ `.vercel/project.json`** ไฟล์นั้นผูกกับโปรเจกต์และทีม Vercel ของเจ้าของเดิม
  ผู้รับควรสร้างโปรเจกต์ของตัวเองด้วย `vercel` แล้วระบบจะสร้างไฟล์นี้ให้ใหม่
- **ไม่มีค่าคีย์จริงในโฟลเดอร์นี้** ตรวจแล้วมีแต่ placeholder ค่าจริงต้องไปเอาจาก
  Vercel Dashboard → Project → Settings → Environment Variables
- **ไม่ได้แนบโค้ด frontend** (`src/`, `index.html`, `vite.config.js`) โฟลเดอร์นี้เน้นข้อมูล
  กับส่วนเซิร์ฟเวอร์ ถ้าต้องการแอปทั้งตัวให้ clone จาก
  `https://github.com/nawanunpcr-sys/Legal-Web.git`
