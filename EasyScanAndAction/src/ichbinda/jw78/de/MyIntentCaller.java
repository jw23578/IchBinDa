package ichbinda78.jw78.de;

import ichbinda78.jw78.de.R;
import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.bindings.QtService;
import android.content.Intent;
import android.content.Context;
import android.util.Log;
import android.os.Bundle;
import android.text.Html;
import android.provider.MediaStore;
import android.net.Uri;
import java.io.File;
import android.support.v4.content.FileProvider;

public class MyIntentCaller
{
    private static String AUTHORITY="ichbinda.jw78.de.fileprovider";
    static public void shareText(String title, String subject,
                                 String content, QtActivity activity)
    {
        Log.i("ShareIntent", "shareText called!");
        Intent share = new Intent(Intent.ACTION_SEND);
        share.setType("text/plain");
        
        share.putExtra(Intent.EXTRA_SUBJECT, subject);
        share.putExtra(Intent.EXTRA_TEXT, content);
        share.putExtra(Intent.EXTRA_HTML_TEXT, content);
        activity.startActivity(Intent.createChooser(share, title));
    }
    public static Intent pickImageIntent()
    {
        Intent intent = new Intent( Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI );
        intent.setType("image/*");
        return Intent.createChooser(intent, "Select Image");
    }
    public static String getRealPathFromURI(Uri contentUri)
    {
        return contentUri.getPath();
    }
    public static String email(String emailTo, String emailCC, String subject, String emailText, String filePaths, QtActivity activity)
    {
        Log.i("email", "email called!");
        try
        {
            //Send the email
            Intent mailIntent = new Intent(Intent.ACTION_SEND);
            mailIntent.putExtra(Intent.EXTRA_EMAIL , emailTo);
            mailIntent.putExtra(Intent.EXTRA_SUBJECT, "Test Email");
            mailIntent.putExtra(Intent.EXTRA_TEXT , "Hi! This is a test!");
            //Deal with the attached report
            Log.i("email", "attachment");
            if (filePaths.length() > 0)
            {
                Log.i("email", filePaths);
                File attachment = new File(filePaths);
                
                if (!attachment.exists() || !attachment.canRead())
                {
                    Log.i("email", "could not find/read file");
                    return "";
                }
                else
                {
                    Uri uri = FileProvider.getUriForFile(activity, AUTHORITY, attachment);
                    Log.d("sendFile", uri.toString());
                    String mimeType = "";
                    if(mimeType == null || mimeType.isEmpty()) {
                                // fallback if mimeType not set
                                mimeType = activity.getContentResolver().getType(uri);
                                Log.d("sendFile guessed mimeType:", mimeType);
                            }  else {
                                Log.d("sendFile w mimeType:", mimeType);
                            }
                    mailIntent.putExtra(Intent.EXTRA_STREAM, uri);
                    mailIntent.setType(mimeType);
                    Log.i("email", "***** found attachment uri");
                }
            }
            
            //Send, if valid!
            try
            {
                Log.i("email", "send");
                mailIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                        mailIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                        activity.startActivity(Intent.createChooser(mailIntent, subject));
            }
            catch (android.content.ActivityNotFoundException ex)
            {
                Log.i("email", "***** There are no email clients installed.");
            }
            catch (java.lang.RuntimeException ex)
            {
                Log.i("email exception", ex.getMessage());
                return ex.getMessage();
            }
        }
        catch (java.lang.Exception ex)
        {
            Log.i("email", "***** toast Exception: " + ex.getMessage());
        }
        return "email Ok";
    }
}
