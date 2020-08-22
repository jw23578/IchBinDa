package ichbinda78.jw78.de;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class JWJobService extends JobService
{
    static JobParameters mParams;
    static JWJobService theJob;
    @Override
    public boolean onStartJob(JobParameters params)
    {
        theJob = this;
        mParams = params;
 /*       Intent service = new Intent(getApplicationContext(), LocalWordService.class);
        getApplicationContext().startService(service);
        Util.scheduleJob(getApplicationContext()); // reschedule the job*/
        Log.i("IchBinDaJobService", "IchBinDaJobService Hello from JobService");
//        jobFinished(params, true);
        return false;
    }
    public static void finishTheJob()
    {
        Log.i("IchBinDaJobService", "IchBinDaJobService finishTheJob");
        theJob.jobFinished(mParams, true);
    }

    @Override
    public boolean onStopJob(JobParameters params)
    {
        return true;
    }
}
