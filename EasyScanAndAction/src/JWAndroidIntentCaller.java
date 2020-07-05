package mobileextensions;

import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.bindings.QtService;
import android.content.Intent;
import android.content.Context;
import android.util.Log;
import android.os.Bundle;
import android.text.Html;
import android.provider.MediaStore;
import java.io.File;
import android.net.Uri;
import android.content.ContentProvider;
import android.support.v4.content.FileProvider;

public class JWAndroidIntentCaller
{
    private static String AUTHORITY="com.wienoebst.tempus.fileprovider";
    static public void shareText(String title, String subject,
                                 String content, QtActivity activity)
    {
        Log.i("ShareIntent", "shareText called!");
        Intent share = new Intent(Intent.ACTION_SEND);
        share.setType("text/plain");
        share.putExtra(Intent.EXTRA_SUBJECT, subject);
        share.putExtra(Intent.EXTRA_TEXT, Html.fromHtml(content).toString());
        share.putExtra(Intent.EXTRA_HTML_TEXT, content);
        activity.startActivity(Intent.createChooser(share, title));
    }
    public static Intent pickImageIntent()
    {
        Intent intent = new Intent( Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI );
        intent.setType("image/*");
        return Intent.createChooser(intent, "Select Image");
    }
    public static void share(String text, String url, QtActivity activity)
    {
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, text + " " + url);
        sendIntent.setType("text/plain");
        activity.startActivity(sendIntent);
    }
    public static void sendFile(String title, String filePath, String mimeType, QtActivity activity)
    {
        Log.d("java sendFile", "");
        // using v4 support library create the Intent from ShareCompat
        // Intent sendIntent = new Intent();
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);

        File imageFileToShare = new File(filePath);

        Uri uri;
        try {
            uri = FileProvider.getUriForFile(activity, AUTHORITY, imageFileToShare);
        } catch (IllegalArgumentException e) {
            Log.d("ekkescorner sendFile - cannot be shared: ", filePath);
            Log.d("exception", e.toString());
            return;
        }

        Log.d("sendFile", uri.toString());

        if(mimeType == null || mimeType.isEmpty()) {
            // fallback if mimeType not set
            mimeType = activity.getContentResolver().getType(uri);
            Log.d("sendFile guessed mimeType:", mimeType);
        }  else {
            Log.d("sendFile w mimeType:", mimeType);
        }

        sendIntent.putExtra(Intent.EXTRA_STREAM, uri);
        sendIntent.setType(mimeType);

        sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        sendIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        activity.startActivity(Intent.createChooser(sendIntent, title));
    }
}
