#ifndef MAILOFFICE_H
#define MAILOFFICE_H

#include "visit.h"
#include "environment/encrypter.h"
#include "environment/emailsender.h"

class MailOffice
{
    const QString smtpSender;
    const QString appName;
    Encrypter &encrypter;
    EMailSender &emailSender;
    MailOffice(Encrypter &encrypter,
               EMailSender &emailSender):
        encrypter(encrypter),
        emailSender(emailSender){}
public:
    MailOffice(const QString &smtpSender,
               const QString &appName,
               Encrypter &encrypter,
               EMailSender &emailSender);
    void sendVisitMail(Visit &theVisit);
};

#endif // MAILOFFICE_H
