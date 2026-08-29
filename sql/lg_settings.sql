-- lg_settings · 1 rows
insert into public.lg_settings overriding system value
select * from json_populate_recordset(null::public.lg_settings, $lexguard$
[{"id":1,"company_name":"Compliance Register","subtitle":"ระบบทะเบียนกฎหมาย SHE และกฎหมายอื่นๆ ที่เกี่ยวข้อง","org_name":"จัสเทล เน็ทเวิร์ค","user_name":"จป. วิชาชีพ","brand_mark":"CR","updated_at":"2026-08-03T11:20:23.425282+00:00"}]
$lexguard$::json);
