-- lg_improvement_plans · 2 rows
insert into public.lg_improvement_plans overriding system value
select * from json_populate_recordset(null::public.lg_improvement_plans, $lexguard$
[{"id":1,"requirement_id":246,"law_id":30,"plan_text":"ติดตามการประกาศหลักสูตรอบรมผู้ชำนาญการด้านความปลอดภัยฯ จากกรมสวัสดิการฯ แล้วส่งบุคลากรเข้าอบรมและขอขึ้นทะเบียนให้ครบตามข้อกำหนด","owner_dept_id":1,"owner_name":"Safety","due_date":null,"status":"open","evidence":null,"closed_at":null,"closed_by":null,"created_at":"2026-07-12T10:08:30.887876+00:00","created_by":"ระบบ (ย้ายข้อมูลเริ่มต้น)"},{"id":2,"requirement_id":247,"law_id":31,"plan_text":"จัดทำการประเมินอันตรายและทบทวนทุก 3 ปีตามข้อ 5 — รอประกาศหลักสูตร/แนวทางผู้ชำนาญการฯ เพื่อดำเนินการให้สอดคล้อง","owner_dept_id":1,"owner_name":"Safety","due_date":null,"status":"open","evidence":null,"closed_at":null,"closed_by":null,"created_at":"2026-07-12T10:08:30.887876+00:00","created_by":"ระบบ (ย้ายข้อมูลเริ่มต้น)"}]
$lexguard$::json);
