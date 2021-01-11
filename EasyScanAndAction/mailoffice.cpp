#include "mailoffice.h"
#include "environment/emailsender.h"
#include <QJsonObject>
#include <QJsonDocument>
#include "environment/flyergenerator.h"
#include "jw78utils.h"


MailOffice::MailOffice(const QString &appName,
                       Encrypter &encrypter,
                       EMailSender &emailSender):
    appName(appName),
    encrypter(encrypter),
    emailSender(emailSender)
{

}


void MailOffice::sendVisitMail(Visit &theVisit)
{
    SimpleMail::MimeMessage *message(new SimpleMail::MimeMessage);
    message->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName));
    message->addTo(SimpleMail::EmailAddress(theVisit.locationContactMailAdress()));

    QString subject("Kontaktdaten ");
    if (theVisit.end().isValid())
    {
        subject += "Besuchsende ";
    }
    else
    {
        subject += "Besuchsbeginn ";
    }
    subject += theVisit.facilityName();
    message->setSubject(subject);

    auto text = new SimpleMail::MimeText;

    QString work;
    work += QObject::tr("Datum: ") + theVisit.begin().date().toString() + "\n";
    work += QObject::tr("Uhrzeit: ") + theVisit.begin().time().toString() + "\n";
    work += theVisit.fstname() + " aus " + theVisit.location();

    QJsonObject jsonData2Send;
    jsonData2Send["DateVisitBegin"] = theVisit.begin().date().toString(Qt::ISODate);
    jsonData2Send["TimeVisitBegin"] = theVisit.begin().time().toString(Qt::ISODate);
    if (theVisit.end().isValid())
    {
        jsonData2Send["DateVisitEnd"] = theVisit.end().date().toString(Qt::ISODate);
        jsonData2Send["TimeVisitEnd"] = theVisit.end().time().toString(Qt::ISODate);
    }
    QString plainText(QJsonDocument(jsonData2Send).toJson());
    std::string encrypted(encrypter.publicKeyEncrypt(plainText.toStdString()));
    work += "\n\n";
    work += encrypted.c_str();
    work += "\n\n";
    std::string publicKeyString(Botan::X509::PEM_encode(*encrypter.publicKey));
    work += publicKeyString.c_str();

    text->setText(work);

    // Now add it to the mail
    message->addPart(text);
    emailSender.addMailToSend(message, true);

    if (theVisit.locationAnonymContactMailAdress().size())
    {

        SimpleMail::MimeMessage *visitMessage(new SimpleMail::MimeMessage);
        visitMessage->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName));
        visitMessage->addTo(SimpleMail::EmailAddress(theVisit.locationAnonymContactMailAdress()));

        subject = "Besuchmeldung " + theVisit.facilityName();
        visitMessage->setSubject(subject);
        work = QObject::tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
        work += QObject::tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
        auto visitText = new SimpleMail::MimeText;
        visitText->setText(work);
        visitMessage->addPart(visitText);

        emailSender.addMailToSend(visitMessage, false);
    }
}

void MailOffice::sendQRCode(const QString &qrCodeReceiver,
                            const QString &facilityName,
                            const QImage &logo,
                            std::set<QString> qrCodes)
{
    SimpleMail::MimeMessage *message(new SimpleMail::MimeMessage);
    message->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName));
    message->addTo(SimpleMail::EmailAddress(qrCodeReceiver));

    QString subject("QR-Code ");
    subject += facilityName;
    message->setSubject(subject);

    // Now add some text to the email.
    SimpleMail::MimeHtml *html = new SimpleMail::MimeHtml;

    QString jpgGuid(jw78::Utils::genUUID());

    html->setHtml(QLatin1String("<h1> Hier folgt der QR-Code </h1>"
                                "<img src=\"cid:") + jpgGuid + "\" />");

    // Now add it to the mail
    message->addPart(html);

    // Create a MimeInlineFile object for each image
    std::set<QString>::iterator it(qrCodes.begin());
    QString pngQRCodeFilename;
    while (it != qrCodes.end())
    {
        auto image1 = new SimpleMail::MimeInlineFile(new QFile(*it));

        // An unique content id must be setted
        if (it->right(3) == "jpg")
        {
            image1->setContentId(jpgGuid.toLatin1());
            image1->setContentType(QByteArrayLiteral("image/jpg"));
        }
        if (it->right(3) == "png")
        {
            image1->setContentId(jw78::Utils::genUUID().toLatin1());
            image1->setContentType(QByteArrayLiteral("image/png"));
            pngQRCodeFilename = *it;
        }
        if (it->right(3) == "svg")
        {
            image1->setContentId(jw78::Utils::genUUID().toLatin1());
            image1->setContentType(QByteArrayLiteral("image/svg+xml"));
        }

        message->addPart(image1);
        ++it;
    }
    SimpleMail::MimeAttachment *attachmentInstallationA4PDF(new SimpleMail::MimeAttachment(new QFile(QLatin1String(":/pdfs/InstallationA4.pdf"))));
    attachmentInstallationA4PDF->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentInstallationA4PDF);

    SimpleMail::MimeAttachment *attachmentInstallationA4PDFQuer(new SimpleMail::MimeAttachment(new QFile(QLatin1String(":/pdfs/InstallationA4Quer.pdf"))));
    attachmentInstallationA4PDFQuer->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentInstallationA4PDFQuer);

    FlyerGenerator flyerGenerator;
    SimpleMail::MimeAttachment *attachmentA4Flyer1(new SimpleMail::MimeAttachment(new QFile(flyerGenerator.generateA4Flyer1(facilityName, logo, pngQRCodeFilename, 1))));
    attachmentA4Flyer1->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentA4Flyer1);

    SimpleMail::MimeAttachment *attachmentA4Flyer2(new SimpleMail::MimeAttachment(new QFile(flyerGenerator.generateA4Flyer1(facilityName, logo, pngQRCodeFilename, 2))));
    attachmentA4Flyer1->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentA4Flyer2);

    SimpleMail::MimeAttachment *attachmentA4Flyer3(new SimpleMail::MimeAttachment(new QFile(flyerGenerator.generateA4Flyer1(facilityName, logo, pngQRCodeFilename, 3))));
    attachmentA4Flyer1->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentA4Flyer3);

    SimpleMail::MimeAttachment *attachmentA6Flyer1(new SimpleMail::MimeAttachment(new QFile(flyerGenerator.generateA6Flyer(facilityName, logo, pngQRCodeFilename, 1))));
    attachmentA4Flyer1->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentA6Flyer1);

    SimpleMail::MimeAttachment *attachmentA5Flyer1(new SimpleMail::MimeAttachment(new QFile(flyerGenerator.generateA5Flyer(facilityName, logo, pngQRCodeFilename, 1))));
    attachmentA4Flyer1->setContentType(QByteArrayLiteral("application/pdf"));
    message->addPart(attachmentA5Flyer1);

    emailSender.addMailToSend(message, true);
}

void MailOffice::sendKontaktTagebuchEMails(const QString &fstname,
                                           const QString &surname,
                                           const QString &eMailAdress,
                                           const QString &otherFstname,
                                           const QString &otherSurname,
                                           const QString &otherEMail)
{
    SimpleMail::MimeMessage *message(new SimpleMail::MimeMessage);
    message->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName));
    message->addTo(SimpleMail::EmailAddress(otherEMail));
    QString subject("IchBinDa! Kontakttagebuch");
    message->setSubject(subject);
    auto text = new SimpleMail::MimeText;
    QString work;
    work += QObject::tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
    work += QObject::tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
    work += "\n";
    work += fstname + " " + surname + "\n";
    work += eMailAdress;
    text->setText(work);
    message->addPart(text);
    emailSender.addMailToSend(message, false);

    message = new SimpleMail::MimeMessage;
    message->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName));
    message->addTo(SimpleMail::EmailAddress(eMailAdress));
    message->setSubject(subject);
    text = new SimpleMail::MimeText;
    work = QObject::tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
    work += QObject::tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
    work += "\n";
    work += otherFstname + " " + otherSurname + "\n";
    work += otherEMail;
    text->setText(work);
    message->addPart(text);
    emailSender.addMailToSend(message, true);
}


