#include "mailoffice.h"
#include "environment/emailsender.h"
#include <QJsonObject>
#include <QJsonDocument>


MailOffice::MailOffice(const QString &smtpSender,
                       const QString &appName,
                       Encrypter &encrypter,
                       EMailSender &emailSender):
    smtpSender(smtpSender),
    appName(appName),
    encrypter(encrypter),
    emailSender(emailSender)
{

}


void MailOffice::sendVisitMail(Visit &theVisit)
{
    SimpleMail::MimeMessage *message(new SimpleMail::MimeMessage);
    message->setSender(SimpleMail::EmailAddress(smtpSender, appName));
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

