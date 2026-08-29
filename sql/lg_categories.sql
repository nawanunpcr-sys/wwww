-- lg_categories · 7 rows
insert into public.lg_categories overriding system value
select * from json_populate_recordset(null::public.lg_categories, $lexguard$
[{"code":"LA","name":"การบริหารจัดการความปลอดภัย อาชีวอนามัยฯ","color":"#0f6b58","sort_order":1},{"code":"LB","name":"ไฟฟ้าและพลังงาน","color":"#cf8a12","sort_order":2},{"code":"LC","name":"การป้องกันและระงับอัคคีภัย","color":"#cf4040","sort_order":3},{"code":"LD","name":"ความร้อน แสงสว่าง เสียง สภาพแวดล้อม","color":"#4f72c4","sort_order":4},{"code":"LE","name":"ก่อสร้าง ลิฟต์ เครื่องจักร ปั้นจั่น","color":"#7a5bbf","sort_order":5},{"code":"LF","name":"Service","color":"#1f9d6b","sort_order":6},{"code":"LG","name":"คณะกรรมการสวัสดิการ","color":"#bd9a2e","sort_order":7}]
$lexguard$::json);
