#ifndef EMAILSENDER_H
#define EMAILSENDER_H

#include <QObject>
#include <SimpleMailSRC/SimpleMail>
#include <map>
#include <set>
#include <QTimer>

class EMailSender: public QObject
{
    Q_OBJECT
    bool sending;
    SimpleMail::Server smtpServer;
    void sendAMail(SimpleMail::MimeMessage *message);
    std::set<SimpleMail::MimeMessage*> messagesToSend;
    std::map<SimpleMail::ServerReply*, SimpleMail::MimeMessage*> reply2message;
    QTimer timer;
    void switchUser();
private slots:
    void onTimeout();
public:
    EMailSender(QObject *parent);
    QString smtpHost;
    int smtpPort;
    QString smtpUser;
    QString smtpPassword;
    QString smtpSender;
    void addMailToSend(SimpleMail::MimeMessage *message);

    QString fstSmtpUser;
    QString fstSmtpPassword;
    QString fstSmtpSender;
    QString scdSmtpUser;
    QString scdSmtpPassword;
    QString scdSmtpSender;

};

#endif // EMAILSENDER_H
