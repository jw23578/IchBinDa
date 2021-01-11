#ifndef MAILOFFICE_H
#define MAILOFFICE_H

#include "visit.h"
#include "environment/encrypter.h"
#include "environment/emailsender.h"

class MailOffice
{
    const QString appName;
    Encrypter &encrypter;
    EMailSender &emailSender;
    MailOffice(Encrypter &encrypter,
               EMailSender &emailSender):
        encrypter(encrypter),
        emailSender(emailSender){}
public:
    MailOffice(const QString &appName,
               Encrypter &encrypter,
               EMailSender &emailSender);
    void sendVisitMail(Visit &theVisit);
    void sendQRCode(const QString &qrCodeReceiver,
                    const QString &facilityName,
                    const QImage &logo,
                    std::set<QString> qrCodes);
    void sendKontaktTagebuchEMails(const QString &fstName,
                                   const QString &surname,
                                   const QString &eMailAdress,
                                   const QString &otherFstname,
                                   const QString &otherSurname,
                                   const QString &otherEMail);
};

#endif // MAILOFFICE_H
