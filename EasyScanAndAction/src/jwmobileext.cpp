#include "jwmobileext.h"
#include <QQmlContext>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>

#ifdef Q_OS_IOS
#include "ios/ios_functions.h"
#endif

QString jw::mobileext::getAppDataLocation()
{
    QString ret(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    return ret;
}

jw::mobileext::mobileext(QQmlApplicationEngine &engine, QString javapackagestring):QObject(nullptr),
    javapackage(javapackagestring.toStdString())
{
    engine.rootContext()->setContextProperty("jwmobileext", QVariant::fromValue(this));
}

QString jw::mobileext::copyfile2sharefiles(QString filepath)
{
    filepath.replace("file://", "");
    QString location(getAppDataLocation() + "/");
    if (!QDir(location + "sharefiles").exists())
    {
        qDebug() << "create path";
        QDir().mkdir(location + "sharefiles");
    }
    location += "sharefiles/";
    QDir dir(location);
    dir.setNameFilters(QStringList() << "*.*");
    dir.setFilter(QDir::Files);
    foreach(QString dirFile, dir.entryList())
    {
        qDebug() << "delete old share file: " << dirFile;
        dir.remove(dirFile);
    }
    QString target(location + QFileInfo(filepath).fileName());
    if (!QFile::copy(filepath, target))
    {
        qDebug() << "copy failed";
    }
    qDebug() << target;
    return target;
}


void jw::mobileext::sendFile(QString title, QString filePath, QString mimeType)
{
    Q_UNUSED(title)
    Q_UNUSED(mimeType)
    filePath = copyfile2sharefiles(filePath);
#ifdef Q_OS_IOS
    // TODO
#endif
#ifdef Q_OS_ANDROID
    QAndroidJniObject jTitle = QAndroidJniObject::fromString(title);
    QAndroidJniObject jfilePath = QAndroidJniObject::fromString(filePath);
    QAndroidJniObject jmimeType = QAndroidJniObject::fromString(mimeType);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject::callStaticMethod<void>(
                javapackage.c_str(),
                "sendFile",
                "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;"
                "Lorg/qtproject/qt5/android/bindings/QtActivity;)V",
                jTitle.object<jstring>(),
                jfilePath.object<jstring>(),
                jmimeType.object<jstring>(),
                activity.object<jobject>()
                );
#endif
}

QString jw::mobileext::email(QString emailTo, QString emailCC, QString subject, QString emailText, QString filePaths)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject jemailTo = QAndroidJniObject::fromString(emailTo);
    QAndroidJniObject jemailCC = QAndroidJniObject::fromString(emailCC);
    QAndroidJniObject jsubject = QAndroidJniObject::fromString(subject);
    QAndroidJniObject jemailText = QAndroidJniObject::fromString(emailText);
    QAndroidJniObject jfilePaths = QAndroidJniObject::fromString(filePaths);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = QAndroidJniObject::callStaticObjectMethod(
                javapackage.c_str(),
                "email",
                "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;"
                "Lorg/qtproject/qt5/android/bindings/QtActivity;)Ljava/lang/String;",
                jemailTo.object<jstring>(),
                jemailCC.object<jstring>(),
                jsubject.object<jstring>(),
                jemailText.object<jstring>(),
                jfilePaths.object<jobject>(),
                activity.object<jobject>()
                );
    return result.toString();
#endif
}

void jw::mobileext::shareText(QString title, QString subject, QString content)
{
    Q_UNUSED(title)
    Q_UNUSED(subject)
    Q_UNUSED(content)
#ifdef Q_OS_IOS
    ios_functions::share(content);
#endif
#ifdef Q_OS_ANDROID
    QAndroidJniObject jTitle = QAndroidJniObject::fromString(title);
    QAndroidJniObject jSubject = QAndroidJniObject::fromString(subject);
    QAndroidJniObject jContent = QAndroidJniObject::fromString(content);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject::callStaticMethod<void>(
                javapackage.c_str(),
                "shareText",
                "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;"
                "Lorg/qtproject/qt5/android/bindings/QtActivity;)V",
                jTitle.object<jstring>(),
                jSubject.object<jstring>(),
                jContent.object<jstring>(),
                activity.object<jobject>()
                );
#endif
}

void jw::mobileext::pickImage(QJSValue callback)
{
    Q_UNUSED(callback)
#ifdef Q_OS_ANDROID
    the_resultreceiver.pickImagecallback = callback;
    QtAndroid::PermissionResult r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
    if (r == QtAndroid::PermissionResult::Denied)
    {
        QtAndroid::requestPermissionsSync( QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE" );
        r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
        if (r == QtAndroid::PermissionResult::Denied)
        {
            return;
        }
    }
    QAndroidJniObject intent = QAndroidJniObject::callStaticObjectMethod(
                javapackage.c_str(),
                "pickImageIntent",
                "()Landroid/content/Intent;" );
    QtAndroid::startActivity(intent, request_pick_image, &the_resultreceiver);
#endif
}

void jw::mobileext::share(QString text, QString url)
{
    Q_UNUSED(text)
    Q_UNUSED(url)
#ifdef Q_OS_ANDROID
    QAndroidJniObject jText = QAndroidJniObject::fromString(text);
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(url);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject::callStaticMethod<void>(
                javapackage.c_str(),
                "share",
                "(Ljava/lang/String;Ljava/lang/String;"
                "Lorg/qtproject/qt5/android/bindings/QtActivity;)V",
                jText.object<jstring>(),
                jUrl.object<jstring>(),
                activity.object<jobject>()
                );
#endif
}

#ifdef Q_OS_ANDROID
void jw::mobileext::resultreceiver::handleActivityResult(int requestCode, int resultCode, const QAndroidJniObject &data)
{
    qDebug() << "enter handleActivitResult - " << resultCode << " - " << requestCode;
    if (requestCode == request_pick_image)
    {
        if (resultCode == -1)
        {

            QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
            qDebug() << "uri of picked image: " << uri.toString();

            QAndroidJniObject datosAndroid = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
            QAndroidJniEnvironment env;
            jobjectArray proyeccion = reinterpret_cast<jobjectArray>(env->NewObjectArray(1, env->FindClass("java/lang/String"), nullptr));
            jobject proyeccionDatosAndroid = env->NewStringUTF(datosAndroid.toString().toStdString().c_str());
            env->SetObjectArrayElement(proyeccion, 0, proyeccionDatosAndroid);

            QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
            QAndroidJniObject nullObj;

            QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), proyeccion, nullObj.object<jstring>(), nullObj.object<jobjectArray>(), nullObj.object<jstring>());

            jint columnIndex = cursor.callMethod<jint>("getColumnIndexOrThrow","(Ljava/lang/String;)I", datosAndroid.object<jstring>());

            cursor.callMethod<jboolean>("moveToFirst");

            QAndroidJniObject path = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);

            QString filepath = "file://" +  path.toString();
            qDebug() << "filepath: " << filepath;
            cursor.callMethod<void>("close");
            pickImagecallback.call(QJSValueList() << filepath);
        }
    }
}
#endif
