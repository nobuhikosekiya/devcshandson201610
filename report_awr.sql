SET FEEDBACK OFF

var end_snap number;
var begin_snap number;
BEGIN
  select max(snap_id) into :end_snap from dba_hist_snapshot;
  select :end_snap - 1 into :begin_snap from dual;
END;
/

DEFINE num_days=1
DEFINE report_type='html'
DEFINE begin_snap= :begin_snap
DEFINE end_snap= :end_snap
DEFINE report_name='awrsnap.html'
@?/rdbms/admin/awrrpt
exit;
