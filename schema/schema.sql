-- LexGuard · full schema (generated from the live database)
-- Apply to an empty Postgres/Supabase database before loading data/restore-all.sql


-- ============ TABLES ============

create table if not exists public.communication_matrix (
  id uuid default gen_random_uuid() not null,
  seq_no integer,
  info_type text not null,
  communicator text,
  recipient text,
  frequency text,
  method text,
  direction text,
  created_at timestamp with time zone default now()
);

create table if not exists public.compliance_logs (
  id uuid default gen_random_uuid() not null,
  law_id text,
  review_year integer not null,
  review_quarter text,
  new_laws_count integer default 0,
  cancelled_laws_count integer default 0,
  compliant_items integer default 0,
  non_compliant_items integer default 0,
  notes text,
  reviewed_by text,
  created_at timestamp with time zone default now()
);

create table if not exists public.compliance_summary (
  id uuid default gen_random_uuid() not null,
  category_id text,
  year integer not null,
  total_laws integer default 0,
  compliant_count integer default 0,
  non_compliant_count integer default 0,
  review_round text,
  created_at timestamp with time zone default now()
);

create table if not exists public.law_categories (
  id text not null,
  name_th text not null,
  name_en text,
  total_laws integer default 0,
  compliant_count integer default 0,
  non_compliant_count integer default 0,
  created_at timestamp with time zone default now()
);

create table if not exists public.laws (
  id text not null,
  category_id text,
  ministry text,
  title text not null,
  summary text,
  announced_date text,
  effective_date text,
  responsible_unit text,
  compliance_status text default 'C'::text,
  check_frequency text,
  reporting_channel text,
  related_documents text,
  remarks text,
  is_cancelled boolean default false,
  last_review_date date,
  review_period text,
  year integer,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

create table if not exists public.lg_activity_log (
  id bigint generated always as identity not null,
  action text not null,
  law_id bigint,
  law_code text,
  law_name text,
  detail text,
  actor text,
  created_at timestamp with time zone default now() not null
);

create table if not exists public.lg_agent_queue (
  id bigint generated always as identity not null,
  source_url text,
  title text,
  raw_text text,
  publication_date text,
  effective_date text,
  category_guess text,
  status text default 'pending'::text not null,
  error text,
  created_at timestamp with time zone default now() not null,
  processed_at timestamp with time zone
);

create table if not exists public.lg_agent_runs (
  id bigint generated always as identity not null,
  agent text,
  started_at timestamp with time zone default now() not null,
  finished_at timestamp with time zone,
  scanned integer default 0,
  created integer default 0,
  errors integer default 0,
  note text
);

create table if not exists public.lg_ai_discovered_laws (
  id uuid default gen_random_uuid() not null,
  law_name text not null,
  source text,
  summary jsonb,
  announced_date date,
  effective_date date,
  ministry text,
  related_docs text[],
  status text default 'draft'::text,
  registered_law_id bigint,
  searched_at timestamp with time zone default now(),
  created_at timestamp with time zone default now(),
  source_url text,
  ai_payload jsonb
);

create table if not exists public.lg_assessment_flow (
  id bigint generated always as identity not null,
  cat text,
  law_code text,
  law_name text,
  law_id bigint,
  screen_status text default 'pending'::text not null,
  screen_by text,
  screen_note text,
  screened_at timestamp with time zone,
  assigned_dept_id bigint,
  assigned_by text,
  assigned_at timestamp with time zone,
  assess_due_date date,
  assess_status text default 'pending'::text not null,
  assessed_by text,
  assessed_at timestamp with time zone,
  created_at timestamp with time zone default now() not null,
  created_by text,
  finalized_at timestamp with time zone,
  finalized_by text
);

create table if not exists public.lg_attachments (
  id bigint generated always as identity not null,
  ref_type text not null,
  ref_id bigint not null,
  file_url text not null,
  file_name text,
  uploaded_by text,
  uploaded_at timestamp with time zone default now() not null
);

create table if not exists public.lg_categories (
  code text not null,
  name text not null,
  color text not null,
  sort_order integer default 0
);

create table if not exists public.lg_categories_ccsbak_20260731 (
  code text,
  name text,
  color text,
  sort_order integer
);

create table if not exists public.lg_communications (
  id bigint generated always as identity not null,
  scope text not null,
  topic text not null,
  sender text,
  receiver text,
  frequency text,
  method text,
  scheduled_date date,
  recurrence_type text default 'annually'::text not null,
  next_scheduled_date date,
  notify_days_before integer default 7 not null,
  assigned_to text,
  file_reference text,
  last_sent_at timestamp with time zone
);

create table if not exists public.lg_compliance_months (
  id integer default nextval('lg_compliance_months_id_seq'::regclass) not null,
  year integer not null,
  month integer not null,
  checked boolean default false not null,
  checked_at timestamp with time zone,
  created_at timestamp with time zone default now()
);

create table if not exists public.lg_departments (
  id bigint generated always as identity not null,
  name text not null,
  active boolean default true not null,
  created_at timestamp with time zone default now() not null
);

create table if not exists public.lg_import_staging (
  id bigint generated always as identity not null,
  batch text,
  law_code text,
  law_name text,
  cat text,
  ministry text,
  issue_date text,
  req_seq integer,
  section_ref text,
  req_text text,
  responsible text,
  applicability text,
  method text,
  documents text,
  frequency text,
  other_terms text,
  source_url text,
  status text default 'proposed'::text not null,
  created_at timestamp with time zone default now() not null,
  announce_date text,
  effective_date text,
  doc_list text,
  verify_status text default 'pending'::text,
  verify_correct boolean,
  verify_accurate boolean,
  verify_complete boolean,
  verify_by text,
  verify_note text,
  verified_at timestamp with time zone,
  from_related_law text,
  gazette_ref text,
  ref_answers jsonb default '[]'::jsonb
);

create table if not exists public.lg_improvement_plans (
  id bigint generated always as identity not null,
  requirement_id bigint,
  law_id bigint,
  plan_text text not null,
  owner_dept_id bigint,
  owner_name text,
  due_date date,
  status text default 'open'::text not null,
  evidence text,
  closed_at timestamp with time zone,
  closed_by text,
  created_at timestamp with time zone default now() not null,
  created_by text
);

create table if not exists public.lg_law_quarter_stats (
  id bigint generated always as identity not null,
  year integer not null,
  quarter smallint not null,
  cat text not null,
  added integer default 0 not null,
  repealed integer default 0 not null,
  created_at timestamp with time zone default now() not null
);

create table if not exists public.lg_law_refs (
  id uuid default gen_random_uuid() not null,
  ref_key text not null,
  ref_law_name text not null,
  ref_clause text not null,
  resolved_text text,
  requirements jsonb default '[]'::jsonb,
  source_url text,
  confidence text,
  note text,
  resolve_status text,
  resolved_at timestamp with time zone default now(),
  related_laws jsonb default '[]'::jsonb,
  explain text
);

create table if not exists public.lg_law_updates (
  id bigint generated always as identity not null,
  source text,
  title text not null,
  ref_url text,
  published_date text,
  category_guess text,
  summary text,
  status text default 'new'::text not null,
  detected_at timestamp with time zone default now() not null
);

create table if not exists public.lg_law_workflow (
  id uuid default gen_random_uuid() not null,
  law_id bigint,
  discovered_law_id uuid,
  workflow_type text default 'add'::text not null,
  stage smallint default 1 not null,
  status text default 'รอประเมิน'::text not null,
  owner_name text,
  owner_at timestamp with time zone,
  follow_issue text,
  assessor_name text,
  assessed_at timestamp with time zone,
  assess_result text,
  improvement_plan text,
  measure text,
  reverify_date date,
  plan_closed_at timestamp with time zone,
  plan_closed_by text,
  completed_at timestamp with time zone,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now(),
  round integer default 1 not null
);

create table if not exists public.lg_laws (
  id bigint generated always as identity not null,
  code text not null,
  cat text not null,
  ministry text,
  name text not null,
  issue_date text,
  status text default 'ok'::text not null,
  review_date date,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now(),
  law_type text,
  hierarchy_level integer default 5 not null,
  repeal_date date,
  repeal_reason text,
  replaced_by_code text,
  repealed_by_authority text,
  effective_date text,
  doc_list text,
  source_url text,
  active boolean default true not null,
  responsible text,
  report_due_date date,
  ai_summary jsonb,
  ai_summary_at timestamp with time zone,
  gazette_ref text
);

create table if not exists public.lg_laws_ccsbak_20260731 (
  id bigint,
  code text,
  cat text,
  ministry text,
  name text,
  issue_date text,
  status text,
  review_date date,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  law_type text,
  hierarchy_level integer,
  repeal_date date,
  repeal_reason text,
  replaced_by_code text,
  repealed_by_authority text,
  effective_date text,
  doc_list text,
  source_url text,
  active boolean,
  responsible text,
  report_due_date date,
  ai_summary jsonb,
  ai_summary_at timestamp with time zone
);

create table if not exists public.lg_laws_datebackup_20260721 (
  id bigint,
  code text,
  cat text,
  issue_date text,
  effective_date text,
  backed_up_at timestamp with time zone
);

create table if not exists public.lg_laws_datefix_bak_20260731 (
  id bigint,
  code text,
  issue_date text,
  effective_date text,
  backed_up_at timestamp with time zone
);

create table if not exists public.lg_notification_log (
  id bigint generated always as identity not null,
  type text not null,
  ref_id bigint,
  ref_type text,
  message text not null,
  due_date date,
  created_at timestamp with time zone default now() not null,
  dismissed_at timestamp with time zone,
  link text
);

create table if not exists public.lg_process_items (
  id bigint generated always as identity not null,
  title text not null,
  ref_type text,
  ref_id bigint,
  stage text default 'discovery'::text not null,
  assignee text,
  note text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create table if not exists public.lg_process_substatus (
  stage integer not null,
  code text not null,
  label text not null,
  sort integer default 0 not null
);

create table if not exists public.lg_process_tracker (
  id bigint generated always as identity not null,
  law_id bigint,
  requirement_id bigint,
  stage integer default 1 not null,
  substatus text,
  assignee_name text,
  assignee_role text,
  status text default 'waiting'::text not null,
  note text,
  started_at timestamp with time zone,
  due_at timestamp with time zone,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null,
  assessment_round integer default 1 not null,
  review_round integer default 0 not null,
  last_review_date date,
  next_review_date date,
  completed_at timestamp with time zone
);

create table if not exists public.lg_ref_answers (
  id uuid default gen_random_uuid() not null,
  question_key text not null,
  anchor_question text not null,
  ref_type text default 'whole_law'::text not null,
  answer_plain text default ''::text,
  answer_detail jsonb default '{}'::jsonb,
  law_name text default ''::text,
  section_ref text default ''::text,
  from_table boolean default false,
  source_excerpt text default ''::text,
  source_url text default ''::text,
  status text default 'not_answered'::text not null,
  confidence text default ''::text,
  note text default ''::text,
  resolved_at timestamp with time zone default now() not null,
  topic_key text
);

create table if not exists public.lg_reports (
  id bigint generated always as identity not null,
  title text not null,
  law_id bigint,
  law_code text,
  authority text,
  responsible text,
  format text,
  retention text,
  category text,
  timeline_text text,
  trigger_type text default 'fixed'::text not null,
  recurrence text default 'annually'::text not null,
  offset_days integer,
  event_date date,
  next_due_date date,
  notify_days_before integer default 30 not null,
  last_submitted_at timestamp with time zone,
  file_reference text,
  note text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create table if not exists public.lg_requirements (
  id bigint generated always as identity not null,
  law_id bigint,
  seq integer default 0,
  text text not null,
  status text default 'pending'::text not null,
  responsible text,
  frequency text,
  documents text,
  note text,
  evaluated_by text,
  evaluated_at timestamp with time zone,
  evidence_url text,
  evidence_label text,
  from_related_law text,
  from_law_url text,
  from_law_confidence text,
  ref_answers jsonb default '[]'::jsonb
);

create table if not exists public.lg_requirements_bak_20260717 (
  id bigint,
  law_id bigint,
  seq integer,
  text text,
  status text,
  responsible text,
  frequency text,
  documents text,
  note text,
  evaluated_by text,
  evaluated_at timestamp with time zone,
  evidence_url text,
  evidence_label text
);

create table if not exists public.lg_requirements_ccsbak_20260731 (
  id bigint,
  law_id bigint,
  seq integer,
  text text,
  status text,
  responsible text,
  frequency text,
  documents text,
  note text,
  evaluated_by text,
  evaluated_at timestamp with time zone,
  evidence_url text,
  evidence_label text
);

create table if not exists public.lg_review_log (
  id bigint generated always as identity not null,
  law_id bigint,
  review_date date not null,
  reviewer text,
  result text,
  note text,
  created_at timestamp with time zone default now() not null
);

create table if not exists public.lg_search_log (
  id uuid default gen_random_uuid() not null,
  searched_by text not null,
  searched_at timestamp with time zone default now(),
  sources text[],
  results_count integer default 0,
  result_summary jsonb,
  no_new_laws boolean default false
);

create table if not exists public.lg_settings (
  id integer default 1 not null,
  company_name text default 'ComplyRegister'::text,
  subtitle text default 'ทะเบียนกฎหมาย SHE'::text,
  org_name text default 'จัสเทล เน็ทเวิร์ค'::text,
  user_name text default 'จป. วิชาชีพ'::text,
  brand_mark text default 'CR'::text,
  updated_at timestamp with time zone default now() not null
);

create table if not exists public.regulatory_documents (
  id uuid default gen_random_uuid() not null,
  seq_no text,
  document_name text not null,
  submission_timeline text,
  submission_location text,
  responsible_unit text,
  submission_format text,
  retention_period text,
  category text,
  created_at timestamp with time zone default now()
);


-- ============ CONSTRAINTS ============
alter table public.communication_matrix add constraint communication_matrix_pkey PRIMARY KEY (id);
alter table public.compliance_logs add constraint compliance_logs_pkey PRIMARY KEY (id);
alter table public.compliance_summary add constraint compliance_summary_pkey PRIMARY KEY (id);
alter table public.law_categories add constraint law_categories_pkey PRIMARY KEY (id);
alter table public.laws add constraint laws_pkey PRIMARY KEY (id);
alter table public.lg_activity_log add constraint lg_activity_log_pkey PRIMARY KEY (id);
alter table public.lg_agent_queue add constraint lg_agent_queue_pkey PRIMARY KEY (id);
alter table public.lg_agent_runs add constraint lg_agent_runs_pkey PRIMARY KEY (id);
alter table public.lg_ai_discovered_laws add constraint lg_ai_discovered_laws_pkey PRIMARY KEY (id);
alter table public.lg_assessment_flow add constraint lg_assessment_flow_pkey PRIMARY KEY (id);
alter table public.lg_attachments add constraint lg_attachments_pkey PRIMARY KEY (id);
alter table public.lg_categories add constraint lg_categories_pkey PRIMARY KEY (code);
alter table public.lg_communications add constraint lg_communications_pkey PRIMARY KEY (id);
alter table public.lg_compliance_months add constraint lg_compliance_months_pkey PRIMARY KEY (id);
alter table public.lg_departments add constraint lg_departments_pkey PRIMARY KEY (id);
alter table public.lg_import_staging add constraint lg_import_staging_pkey PRIMARY KEY (id);
alter table public.lg_improvement_plans add constraint lg_improvement_plans_pkey PRIMARY KEY (id);
alter table public.lg_law_quarter_stats add constraint lg_law_quarter_stats_pkey PRIMARY KEY (id);
alter table public.lg_law_refs add constraint lg_law_refs_pkey PRIMARY KEY (id);
alter table public.lg_law_updates add constraint lg_law_updates_pkey PRIMARY KEY (id);
alter table public.lg_law_workflow add constraint lg_law_workflow_pkey PRIMARY KEY (id);
alter table public.lg_laws add constraint lg_laws_pkey PRIMARY KEY (id);
alter table public.lg_notification_log add constraint lg_notification_log_pkey PRIMARY KEY (id);
alter table public.lg_process_items add constraint lg_process_items_pkey PRIMARY KEY (id);
alter table public.lg_process_substatus add constraint lg_process_substatus_pkey PRIMARY KEY (stage, code);
alter table public.lg_process_tracker add constraint lg_process_tracker_pkey PRIMARY KEY (id);
alter table public.lg_ref_answers add constraint lg_ref_answers_pkey PRIMARY KEY (id);
alter table public.lg_reports add constraint lg_reports_pkey PRIMARY KEY (id);
alter table public.lg_requirements add constraint lg_requirements_pkey PRIMARY KEY (id);
alter table public.lg_review_log add constraint lg_review_log_pkey PRIMARY KEY (id);
alter table public.lg_search_log add constraint lg_search_log_pkey PRIMARY KEY (id);
alter table public.lg_settings add constraint lg_settings_pkey PRIMARY KEY (id);
alter table public.regulatory_documents add constraint regulatory_documents_pkey PRIMARY KEY (id);
alter table public.compliance_summary add constraint compliance_summary_category_id_year_review_round_key UNIQUE (category_id, year, review_round);
alter table public.lg_compliance_months add constraint lg_compliance_months_year_month_key UNIQUE (year, month);
alter table public.lg_departments add constraint lg_departments_name_key UNIQUE (name);
alter table public.lg_law_quarter_stats add constraint lg_law_quarter_stats_year_quarter_cat_key UNIQUE (year, quarter, cat);
alter table public.lg_law_refs add constraint lg_law_refs_ref_key_key UNIQUE (ref_key);
alter table public.lg_laws add constraint lg_laws_cat_code_key UNIQUE (cat, code);
alter table public.lg_ref_answers add constraint lg_ref_answers_question_key_key UNIQUE (question_key);
alter table public.communication_matrix add constraint communication_matrix_direction_check CHECK ((direction = ANY (ARRAY['internal'::text, 'external'::text])));
alter table public.laws add constraint laws_compliance_status_check CHECK ((compliance_status = ANY (ARRAY['C'::text, 'NC'::text, 'N/A'::text])));
alter table public.lg_ai_discovered_laws add constraint lg_ai_discovered_laws_source_check CHECK ((source = ANY (ARRAY['ratchakitcha'::text, 'shawpat'::text, 'manual'::text, 'ai'::text])));
alter table public.lg_ai_discovered_laws add constraint lg_ai_discovered_laws_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'imported'::text, 'registered'::text, 'deleted'::text])));
alter table public.lg_attachments add constraint lg_attachments_ref_type_check CHECK ((ref_type = ANY (ARRAY['car'::text, 'report'::text, 'comm'::text, 'law'::text, 'assess'::text])));
alter table public.lg_compliance_months add constraint lg_compliance_months_month_check CHECK (((month >= 1) AND (month <= 12)));
alter table public.lg_law_quarter_stats add constraint lg_law_quarter_stats_quarter_check CHECK (((quarter >= 1) AND (quarter <= 4)));
alter table public.lg_law_refs add constraint lg_law_refs_resolve_status_check CHECK ((resolve_status = ANY (ARRAY['resolved'::text, 'not_found'::text, 'manual'::text, 'explained'::text, 'link_only'::text])));
alter table public.lg_law_workflow add constraint lg_law_workflow_assess_result_check CHECK ((assess_result = ANY (ARRAY['สอดคล้อง'::text, 'ไม่สอดคล้อง'::text])));
alter table public.lg_law_workflow add constraint lg_law_workflow_stage_check CHECK (((stage >= 1) AND (stage <= 3)));
alter table public.lg_law_workflow add constraint lg_law_workflow_status_check CHECK ((status = ANY (ARRAY['รอประเมิน'::text, 'สอดคล้อง'::text, 'ไม่สอดคล้อง'::text, 'เสร็จสิ้น'::text])));
alter table public.lg_law_workflow add constraint lg_law_workflow_workflow_type_check CHECK ((workflow_type = ANY (ARRAY['add'::text, 'monitor'::text])));
alter table public.lg_process_tracker add constraint lg_process_tracker_stage_check CHECK (((stage >= 1) AND (stage <= 5)));
alter table public.lg_ref_answers add constraint lg_ref_answers_ref_type_check CHECK ((ref_type = ANY (ARRAY['specific'::text, 'whole_law'::text, 'pending'::text])));
alter table public.lg_ref_answers add constraint lg_ref_answers_status_check CHECK ((status = ANY (ARRAY['answered'::text, 'not_answered'::text, 'pending_issuance'::text])));
alter table public.lg_reports add constraint lg_reports_recurrence_check CHECK ((recurrence = ANY (ARRAY['once'::text, 'monthly'::text, 'quarterly'::text, 'semiannually'::text, 'annually'::text, 'asneeded'::text])));
alter table public.lg_reports add constraint lg_reports_trigger_type_check CHECK ((trigger_type = ANY (ARRAY['fixed'::text, 'event'::text])));
alter table public.lg_settings add constraint single_row CHECK ((id = 1));
alter table public.compliance_logs add constraint compliance_logs_law_id_fkey FOREIGN KEY (law_id) REFERENCES laws(id);
alter table public.compliance_summary add constraint compliance_summary_category_id_fkey FOREIGN KEY (category_id) REFERENCES law_categories(id);
alter table public.laws add constraint laws_category_id_fkey FOREIGN KEY (category_id) REFERENCES law_categories(id);
alter table public.lg_ai_discovered_laws add constraint lg_ai_discovered_laws_registered_law_id_fkey FOREIGN KEY (registered_law_id) REFERENCES lg_laws(id);
alter table public.lg_assessment_flow add constraint lg_assessment_flow_assigned_dept_id_fkey FOREIGN KEY (assigned_dept_id) REFERENCES lg_departments(id);
alter table public.lg_assessment_flow add constraint lg_assessment_flow_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id) ON DELETE CASCADE;
alter table public.lg_improvement_plans add constraint lg_improvement_plans_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id) ON DELETE CASCADE;
alter table public.lg_improvement_plans add constraint lg_improvement_plans_owner_dept_id_fkey FOREIGN KEY (owner_dept_id) REFERENCES lg_departments(id);
alter table public.lg_improvement_plans add constraint lg_improvement_plans_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES lg_requirements(id) ON DELETE CASCADE;
alter table public.lg_law_quarter_stats add constraint lg_law_quarter_stats_cat_fkey FOREIGN KEY (cat) REFERENCES lg_categories(code);
alter table public.lg_law_workflow add constraint lg_law_workflow_discovered_fk FOREIGN KEY (discovered_law_id) REFERENCES lg_ai_discovered_laws(id);
alter table public.lg_law_workflow add constraint lg_law_workflow_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id) ON DELETE CASCADE;
alter table public.lg_laws add constraint lg_laws_cat_fkey FOREIGN KEY (cat) REFERENCES lg_categories(code);
alter table public.lg_process_tracker add constraint lg_process_tracker_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id) ON DELETE CASCADE;
alter table public.lg_process_tracker add constraint lg_process_tracker_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES lg_requirements(id) ON DELETE SET NULL;
alter table public.lg_reports add constraint lg_reports_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id);
alter table public.lg_requirements add constraint lg_requirements_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id) ON DELETE CASCADE;
alter table public.lg_review_log add constraint lg_review_log_law_id_fkey FOREIGN KEY (law_id) REFERENCES lg_laws(id) ON DELETE CASCADE;


-- ============ INDEXES ============
CREATE INDEX idx_communication_direction ON public.communication_matrix USING btree (direction);
CREATE INDEX idx_compliance_logs_law ON public.compliance_logs USING btree (law_id);
CREATE INDEX idx_compliance_summary_year ON public.compliance_summary USING btree (year);
CREATE INDEX idx_laws_cancelled ON public.laws USING btree (is_cancelled);
CREATE INDEX idx_laws_category ON public.laws USING btree (category_id);
CREATE INDEX idx_laws_status ON public.laws USING btree (compliance_status);
CREATE INDEX idx_lg_activity_created ON public.lg_activity_log USING btree (created_at DESC);
CREATE INDEX idx_lg_agent_queue_status ON public.lg_agent_queue USING btree (status);
CREATE INDEX idx_lg_agent_runs_agent ON public.lg_agent_runs USING btree (agent, started_at DESC);
CREATE INDEX idx_lg_ai_discovered_status ON public.lg_ai_discovered_laws USING btree (status);
CREATE INDEX idx_lg_attachments_ref ON public.lg_attachments USING btree (ref_type, ref_id);
CREATE INDEX idx_lg_communications_next_sched ON public.lg_communications USING btree (next_scheduled_date);
CREATE INDEX idx_lg_flow_batch ON public.lg_assessment_flow USING btree (cat, law_code);
CREATE INDEX idx_lg_flow_dept ON public.lg_assessment_flow USING btree (assigned_dept_id);
CREATE INDEX idx_lg_flow_law ON public.lg_assessment_flow USING btree (law_id);
CREATE INDEX idx_lg_import_staging_status ON public.lg_import_staging USING btree (status);
CREATE INDEX idx_lg_impr_dept ON public.lg_improvement_plans USING btree (owner_dept_id);
CREATE INDEX idx_lg_impr_law ON public.lg_improvement_plans USING btree (law_id);
CREATE INDEX idx_lg_impr_req ON public.lg_improvement_plans USING btree (requirement_id);
CREATE INDEX idx_lg_impr_stat ON public.lg_improvement_plans USING btree (status);
CREATE INDEX idx_lg_law_refs_key ON public.lg_law_refs USING btree (ref_key);
CREATE INDEX idx_lg_law_updates_detected ON public.lg_law_updates USING btree (detected_at DESC);
CREATE INDEX idx_lg_law_workflow_law ON public.lg_law_workflow USING btree (law_id);
CREATE INDEX idx_lg_law_workflow_stage ON public.lg_law_workflow USING btree (stage);
CREATE INDEX idx_lg_law_workflow_status ON public.lg_law_workflow USING btree (status);
CREATE INDEX idx_lg_laws_cat ON public.lg_laws USING btree (cat);
CREATE INDEX idx_lg_laws_review ON public.lg_laws USING btree (review_date);
CREATE INDEX idx_lg_notif_ref ON public.lg_notification_log USING btree (ref_type, ref_id);
CREATE INDEX idx_lg_notif_type ON public.lg_notification_log USING btree (type);
CREATE INDEX idx_lg_process_stage ON public.lg_process_items USING btree (stage);
CREATE INDEX idx_lg_process_tracker_law ON public.lg_process_tracker USING btree (law_id);
CREATE INDEX idx_lg_process_tracker_next_review ON public.lg_process_tracker USING btree (next_review_date);
CREATE INDEX idx_lg_process_tracker_stage ON public.lg_process_tracker USING btree (stage);
CREATE INDEX idx_lg_reports_due ON public.lg_reports USING btree (next_due_date);
CREATE INDEX idx_lg_reports_next_due ON public.lg_reports USING btree (next_due_date);
CREATE INDEX idx_lg_req_law ON public.lg_requirements USING btree (law_id);
CREATE INDEX idx_lg_review_log_law ON public.lg_review_log USING btree (law_id);
CREATE INDEX idx_lg_search_log_at ON public.lg_search_log USING btree (searched_at DESC);
CREATE INDEX idx_lg_staging_verify ON public.lg_import_staging USING btree (verify_status);
CREATE INDEX lg_ref_answers_resolved_idx ON public.lg_ref_answers USING btree (resolved_at DESC);
CREATE INDEX lg_ref_answers_topic_idx ON public.lg_ref_answers USING btree (topic_key, status, resolved_at DESC) WHERE (topic_key IS NOT NULL);
CREATE INDEX lg_reports_due_idx ON public.lg_reports USING btree (next_due_date);


-- ============ FUNCTIONS ============
CREATE OR REPLACE FUNCTION public.lg_notify_report_due()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
  insert into lg_notification_log (type, ref_id, ref_type, message, due_date)
  select 'report_due_law', l.id, 'law',
         l.code || ' ใกล้ครบกำหนดส่งรายงานราชการ (' || to_char(l.report_due_date, 'DD/MM/YYYY') || ')',
         l.report_due_date
  from lg_laws l
  where l.report_due_date is not null
    and l.status <> 'repealed'
    and l.report_due_date between current_date and current_date + interval '30 days'
    and not exists (
      select 1 from lg_notification_log n
      where n.type = 'report_due_law' and n.ref_id = l.id and n.dismissed_at is null
        and n.created_at > now() - interval '20 hours'
    );
end $function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$
;


-- ============ VIEWS ============

create or replace view public.law_compliance_overview as
 SELECT lc.id AS category_id,
    lc.name_th AS category_name,
    lc.total_laws,
    count(l.id) FILTER (WHERE l.compliance_status = 'C'::text AND NOT l.is_cancelled) AS compliant_laws,
    count(l.id) FILTER (WHERE l.compliance_status = 'NC'::text AND NOT l.is_cancelled) AS non_compliant_laws,
    count(l.id) FILTER (WHERE l.is_cancelled) AS cancelled_laws,
    round(count(l.id) FILTER (WHERE l.compliance_status = 'C'::text AND NOT l.is_cancelled)::numeric / NULLIF(count(l.id) FILTER (WHERE NOT l.is_cancelled), 0)::numeric * 100::numeric, 1) AS compliance_rate_pct
   FROM law_categories lc
     LEFT JOIN laws l ON l.category_id = lc.id
  GROUP BY lc.id, lc.name_th, lc.total_laws
  ORDER BY lc.id;

create or replace view public.lg_tasks with (security_invoker=true) as
 WITH wf(task_id, kind, ref_id, law_id, law_code, law_name, cat, title, subtitle, owner_name, due_date, stage, status_raw, state, done_at, created_at, updated_at) AS (
         SELECT 'wf-'::text || w.id::text AS "?column?",
            'workflow'::text AS "?column?",
            w.id::text AS id,
            w.law_id,
            l.code,
            l.name,
            l.cat,
            COALESCE(l.name, w.follow_issue, 'งานทวนสอบกฎหมาย'::text) AS "coalesce",
            (
                CASE w.workflow_type
                    WHEN 'add'::text THEN 'เพิ่มกฎหมายใหม่'::text
                    WHEN 'monitor'::text THEN 'ทวนสอบกฎหมายเดิม'::text
                    ELSE w.workflow_type
                END || ' · รอบ '::text) || w.round::text AS "?column?",
            w.owner_name,
            w.reverify_date,
            w.stage::integer AS stage,
            w.status,
                CASE
                    WHEN w.status = 'เสร็จสิ้น'::text THEN
                    CASE
                        WHEN w.reverify_date IS NOT NULL AND w.reverify_date < CURRENT_DATE AND NOT (EXISTS ( SELECT 1
                           FROM lg_law_workflow w2
                          WHERE w2.law_id = w.law_id AND w2.id <> w.id AND w2.status <> 'เสร็จสิ้น'::text)) THEN 'overdue'::text
                        ELSE 'done'::text
                    END
                    WHEN w.status = 'ไม่สอดคล้อง'::text AND w.reverify_date IS NOT NULL AND w.reverify_date < CURRENT_DATE THEN 'overdue'::text
                    WHEN (w.status = ANY (ARRAY['ไม่สอดคล้อง'::text, 'รอประเมิน'::text])) OR w.stage >= 2 THEN 'doing'::text
                    ELSE 'todo'::text
                END AS "case",
            w.completed_at,
            w.created_at,
            w.updated_at
           FROM lg_law_workflow w
             LEFT JOIN lg_laws l ON l.id = w.law_id
          WHERE l.id IS NULL OR l.status <> 'repealed'::text AND l.active IS NOT FALSE
        ), rp(task_id, kind, ref_id, law_id, law_code, law_name, cat, title, subtitle, owner_name, due_date, stage, status_raw, state, done_at, created_at, updated_at) AS (
         SELECT 'rp-'::text || r.id::text AS "?column?",
            'report'::text AS "?column?",
            r.id::text AS id,
            r.law_id,
            COALESCE(r.law_code, l.code) AS "coalesce",
            l.name,
            l.cat,
            r.title,
            NULLIF(concat_ws(' · '::text, r.authority, r.responsible), ''::text) AS "nullif",
            r.responsible,
            r.next_due_date,
            NULL::integer AS int4,
            NULL::text AS text,
                CASE
                    WHEN r.next_due_date < CURRENT_DATE THEN 'overdue'::text
                    ELSE 'todo'::text
                END AS "case",
            r.last_submitted_at,
            r.created_at,
            r.updated_at
           FROM lg_reports r
             LEFT JOIN lg_laws l ON l.id = r.law_id
          WHERE r.next_due_date IS NOT NULL AND (l.id IS NULL OR l.status <> 'repealed'::text AND l.active IS NOT FALSE)
        ), cm(task_id, kind, ref_id, law_id, law_code, law_name, cat, title, subtitle, owner_name, due_date, stage, status_raw, state, done_at, created_at, updated_at) AS (
         SELECT 'cm-'::text || c.id::text AS "?column?",
            'comm'::text AS "?column?",
            c.id::text AS id,
            NULL::bigint AS int8,
            NULL::text AS text,
            NULL::text AS text,
            NULL::text AS text,
            c.topic,
            c.assigned_to,
            c.assigned_to,
            c.next_scheduled_date,
            NULL::integer AS int4,
            NULL::text AS text,
                CASE
                    WHEN c.next_scheduled_date < CURRENT_DATE THEN 'overdue'::text
                    ELSE 'todo'::text
                END AS "case",
            c.last_sent_at,
            NULL::timestamp with time zone AS timestamptz,
            NULL::timestamp with time zone AS timestamptz
           FROM lg_communications c
          WHERE c.next_scheduled_date IS NOT NULL
        ), u AS (
         SELECT wf.task_id,
            wf.kind,
            wf.ref_id,
            wf.law_id,
            wf.law_code,
            wf.law_name,
            wf.cat,
            wf.title,
            wf.subtitle,
            wf.owner_name,
            wf.due_date,
            wf.stage,
            wf.status_raw,
            wf.state,
            wf.done_at,
            wf.created_at,
            wf.updated_at
           FROM wf
        UNION ALL
         SELECT rp.task_id,
            rp.kind,
            rp.ref_id,
            rp.law_id,
            rp.law_code,
            rp.law_name,
            rp.cat,
            rp.title,
            rp.subtitle,
            rp.owner_name,
            rp.due_date,
            rp.stage,
            rp.status_raw,
            rp.state,
            rp.done_at,
            rp.created_at,
            rp.updated_at
           FROM rp
        UNION ALL
         SELECT cm.task_id,
            cm.kind,
            cm.ref_id,
            cm.law_id,
            cm.law_code,
            cm.law_name,
            cm.cat,
            cm.title,
            cm.subtitle,
            cm.owner_name,
            cm.due_date,
            cm.stage,
            cm.status_raw,
            cm.state,
            cm.done_at,
            cm.created_at,
            cm.updated_at
           FROM cm
        )
 SELECT task_id,
    kind,
    ref_id,
    law_id,
    law_code,
    law_name,
    cat,
    title,
    subtitle,
    owner_name,
    due_date,
    stage,
        CASE kind
            WHEN 'workflow'::text THEN
            CASE
                WHEN state = 'overdue'::text THEN 'เกินกำหนดทวนสอบ'::text
                ELSE status_raw
            END
            WHEN 'report'::text THEN
            CASE
                WHEN state = 'overdue'::text THEN 'เกินกำหนดส่งรายงาน'::text
                ELSE 'ถึงกำหนดส่งรายงาน'::text
            END
            WHEN 'comm'::text THEN
            CASE
                WHEN state = 'overdue'::text THEN 'เกินกำหนดสื่อสาร'::text
                ELSE 'ถึงกำหนดสื่อสาร'::text
            END
            ELSE NULL::text
        END AS status_label,
    state,
    done_at,
    created_at,
    updated_at
   FROM u;


-- ============ TRIGGERS ============
CREATE TRIGGER trigger_laws_updated_at BEFORE UPDATE ON public.laws FOR EACH ROW EXECUTE FUNCTION update_updated_at();


-- ============ ROW LEVEL SECURITY ============
alter table public.communication_matrix enable row level security;
alter table public.compliance_logs enable row level security;
alter table public.compliance_summary enable row level security;
alter table public.law_categories enable row level security;
alter table public.laws enable row level security;
alter table public.lg_activity_log enable row level security;
alter table public.lg_agent_queue enable row level security;
alter table public.lg_agent_runs enable row level security;
alter table public.lg_ai_discovered_laws enable row level security;
alter table public.lg_assessment_flow enable row level security;
alter table public.lg_attachments enable row level security;
alter table public.lg_categories enable row level security;
alter table public.lg_categories_ccsbak_20260731 enable row level security;
alter table public.lg_communications enable row level security;
alter table public.lg_compliance_months enable row level security;
alter table public.lg_departments enable row level security;
alter table public.lg_import_staging enable row level security;
alter table public.lg_improvement_plans enable row level security;
alter table public.lg_law_quarter_stats enable row level security;
alter table public.lg_law_refs enable row level security;
alter table public.lg_law_updates enable row level security;
alter table public.lg_law_workflow enable row level security;
alter table public.lg_laws enable row level security;
alter table public.lg_laws_ccsbak_20260731 enable row level security;
alter table public.lg_laws_datebackup_20260721 enable row level security;
alter table public.lg_laws_datefix_bak_20260731 enable row level security;
alter table public.lg_notification_log enable row level security;
alter table public.lg_process_items enable row level security;
alter table public.lg_process_substatus enable row level security;
alter table public.lg_process_tracker enable row level security;
alter table public.lg_ref_answers enable row level security;
alter table public.lg_reports enable row level security;
alter table public.lg_requirements enable row level security;
alter table public.lg_requirements_bak_20260717 enable row level security;
alter table public.lg_requirements_ccsbak_20260731 enable row level security;
alter table public.lg_review_log enable row level security;
alter table public.lg_search_log enable row level security;
alter table public.lg_settings enable row level security;
alter table public.regulatory_documents enable row level security;

create policy "Public read communication_matrix" on public.communication_matrix as PERMISSIVE for SELECT to public using (true);
create policy "Public read compliance_logs" on public.compliance_logs as PERMISSIVE for SELECT to public using (true);
create policy "Public read compliance_summary" on public.compliance_summary as PERMISSIVE for SELECT to public using (true);
create policy "Public read law_categories" on public.law_categories as PERMISSIVE for SELECT to public using (true);
create policy "Public read laws" on public.laws as PERMISSIVE for SELECT to public using (true);
create policy lg_activity_all on public.lg_activity_log as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_agent_queue_all on public.lg_agent_queue as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_agent_runs_all on public.lg_agent_runs as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_ai_discovered_laws_all on public.lg_ai_discovered_laws as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_assessment_flow_all on public.lg_assessment_flow as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_attachments_all on public.lg_attachments as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_cat_all on public.lg_categories as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_comm_all on public.lg_communications as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_months_all on public.lg_compliance_months as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_departments_all on public.lg_departments as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_import_staging_all on public.lg_import_staging as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_staging_all on public.lg_import_staging as PERMISSIVE for ALL to public using (true) with check (true);
create policy stage_all on public.lg_import_staging as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_improvement_plans_all on public.lg_improvement_plans as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_lqs_all on public.lg_law_quarter_stats as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_law_refs_all on public.lg_law_refs as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_law_updates_all on public.lg_law_updates as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_law_workflow_all on public.lg_law_workflow as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_laws_all on public.lg_laws as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_notif_all on public.lg_notification_log as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_process_all on public.lg_process_items as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_process_substatus_all on public.lg_process_substatus as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_process_tracker_all on public.lg_process_tracker as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_ref_answers_all on public.lg_ref_answers as PERMISSIVE for ALL to public using (true) with check (true);
create policy "lg_reports delete" on public.lg_reports as PERMISSIVE for DELETE to public using (true);
create policy "lg_reports insert" on public.lg_reports as PERMISSIVE for INSERT to public with check (true);
create policy "lg_reports read" on public.lg_reports as PERMISSIVE for SELECT to public using (true);
create policy "lg_reports update" on public.lg_reports as PERMISSIVE for UPDATE to public using (true);
create policy lg_reports_all on public.lg_reports as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_req_all on public.lg_requirements as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_review_log_all on public.lg_review_log as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_search_log_all on public.lg_search_log as PERMISSIVE for ALL to public using (true) with check (true);
create policy lg_settings_all on public.lg_settings as PERMISSIVE for ALL to public using (true) with check (true);
create policy "Public read regulatory_documents" on public.regulatory_documents as PERMISSIVE for SELECT to public using (true);


-- ============ COMMENTS ============
comment on table public.lg_assessment_flow is 'DEPRECATED (P10) — replaced by lg_law_workflow. Kept read-only, no new writes.';
comment on table public.lg_import_staging is 'DEPRECATED (P12) — pipeline เดียวคือ lg_ai_discovered_laws. drop ได้หลังยืนยัน production';
comment on table public.lg_process_items is 'DEPRECATED (P11) — UI ใช้ lg_law_workflow (P10) เป็น source of truth. ปลอดภัยที่จะ drop หลังยืนยัน production 1 เดือน';
comment on table public.lg_process_tracker is 'DEPRECATED (P11) — UI ใช้ lg_law_workflow (P10) เป็น source of truth. ปลอดภัยที่จะ drop หลังยืนยัน production 1 เดือน';
comment on table public.lg_tasks is 'P16 · รวมงานที่ต้องทำจาก workflow/report/comm (security_invoker). อ่านจากที่เดียวสำหรับหน้ารายการที่ต้องทำ';
comment on column public.lg_laws.status is 'ok | bad | pending (P18: มีข้อปฏิบัติที่ยังไม่ประเมิน) | repealed';
comment on column public.lg_laws.gazette_ref is 'เลขอ้างอิงราชกิจจานุเบกษา รูปแบบ "เล่ม <เล่ม> ตอนที่ <ตอน> <ประเภท> หน้า <หน้า>" เช่น เล่ม 143 ตอนที่ 17 ก หน้า 4-7';
comment on column public.lg_requirements.status is 'met | unmet | pending (P18: ยังไม่ประเมิน — ค่าเริ่มต้นของข้อปฏิบัติที่เพิ่งสร้าง)';
comment on column public.lg_requirements.from_related_law is 'Skill 3 · ชื่อกฎหมายต้นทางที่ข้อนี้ถูกดึงมา · null = ข้อของกฎหมายฉบับหลักเอง';
comment on column public.lg_requirements.from_law_url is 'Skill 3 · ลิงก์ไฟล์ตัวบทของกฎหมายต้นทาง (โดเมนที่เชื่อถือได้เท่านั้น) — ให้ผู้ตรวจเปิดตรวจเองได้';
comment on column public.lg_requirements.from_law_confidence is 'Skill 3 · ระดับความมั่นใจของการดึงตัวบท: high | medium | low — ที่ไม่ใช่ high ต้องเตือนให้ตรวจตัวบทเอง';
