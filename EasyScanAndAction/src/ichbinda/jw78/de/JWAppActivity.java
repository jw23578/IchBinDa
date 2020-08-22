package ichbinda78.jw78.de;

import ichbinda78.jw78.de.R;
import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.bindings.QtService;
import ichbinda78.jw78.de.JWAppService;
import android.content.Intent;
import android.util.Log;
import android.os.Bundle;
import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.Context;
import android.content.ComponentName;

public class JWAppActivity extends QtActivity {
    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);

        Log.i("IchBinDaActivity", "IchBinDaActivity Starting Job!");
//        scheduleJob();
    }
    public void scheduleJob()
    {
        Log.i("IchBinDaActivity", "IchBinDaActivity Starting Job! " + JobInfo.getMinPeriodMillis());
        ComponentName mServiceComponent = new ComponentName(this, JWJobService.class);
        JobInfo.Builder builder = new JobInfo.Builder(1, mServiceComponent);
        builder.setPeriodic(5 * 1000, 10 * 10000);
        builder.setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY);
        //		builder.setRequiresDeviceIdle(mRequiresIdleCheckbox.isChecked());
        //		builder.setRequiresCharging(mRequiresChargingCheckBox.isChecked());
        JobScheduler jobScheduler =
        (JobScheduler) getApplication().getSystemService(Context.JOB_SCHEDULER_SERVICE);

        jobScheduler.schedule(builder.build());
    }
    @Override
    protected void onResume() {
        super.onResume();
        }
    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }
    @Override
    public void onPause() {
        super.onPause();
    }
    @Override
    public void onDestroy() {
        super.onDestroy();
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }
}
