-- LexGuard · restore all data, FK-safe order.
-- Run against a database that already has the schema (schema/schema.sql).
begin;
\i data/sql/lg_categories.sql
\i data/sql/law_categories.sql
\i data/sql/lg_departments.sql
\i data/sql/lg_process_substatus.sql
\i data/sql/lg_settings.sql
\i data/sql/lg_laws.sql
\i data/sql/laws.sql
\i data/sql/lg_requirements.sql
\i data/sql/lg_communications.sql
\i data/sql/lg_reports.sql
\i data/sql/lg_law_quarter_stats.sql
\i data/sql/lg_ai_discovered_laws.sql
\i data/sql/compliance_logs.sql
\i data/sql/compliance_summary.sql
\i data/sql/communication_matrix.sql
\i data/sql/regulatory_documents.sql
\i data/sql/lg_law_workflow.sql
\i data/sql/lg_improvement_plans.sql
\i data/sql/lg_assessment_flow.sql
\i data/sql/lg_process_tracker.sql
\i data/sql/lg_review_log.sql
\i data/sql/lg_compliance_months.sql
\i data/sql/lg_notification_log.sql
\i data/sql/lg_import_staging.sql
\i data/sql/lg_law_updates.sql
\i data/sql/lg_activity_log.sql
\i data/sql/lg_agent_queue.sql
\i data/sql/lg_agent_runs.sql
\i data/sql/lg_process_items.sql
\i data/sql/lg_attachments.sql
\i data/sql/lg_search_log.sql
\i data/sql/lg_law_refs.sql
\i data/sql/lg_ref_answers.sql
commit;
