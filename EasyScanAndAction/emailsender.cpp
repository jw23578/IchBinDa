#include "emailsender.h"
#include "esaaapp.h"

void EMailSender::sendAMail(SimpleMail::MimeMessage *message)
{
    if (sending)
    {
        return;
    }
    sending = true;
    smtpServer.setHost(smtpHost);
    smtpServer.setPort(smtpPort);
    smtpServer.setConnectionType(SimpleMail::Server::SslConnection);

    smtpServer.setUsername(smtpUser);
    smtpServer.setPassword(smtpPassword);

    SimpleMail::ServerReply *reply = smtpServer.sendMail(*message);
    reply2message[reply] = message;
    QObject::connect(reply, &SimpleMail::ServerReply::finished, [reply, this] {
        QString responseText(reply->responseText());
        qDebug() << "Message ServerReply finished" << reply->error() << responseText;
        if (reply->error())
        {
            if (responseText.contains("Hourly email limit for user"))
            {
                switchUser();
            }
            SimpleMail::MimeMessage *message(reply2message[reply]);
            reply2message.erase(reply);
            sendAMail(message);
        }
        else
        {
            SimpleMail::MimeMessage *message(reply2message[reply]);
            if (messagesWithHideSignal.find(message) != messagesWithHideSignal.end())
            {
                theApp->hideWaitMessage();
                messagesWithHideSignal.erase(message);
            }
            reply2message.erase(reply);
            messagesToSend.erase(message);
            delete message;
        }
        reply->deleteLater();// Don't forget to delete it
        sending = false;
    });
}

void EMailSender::switchUser()
{
    if (smtpUser == fstSmtpUser)
    {
        smtpUser = scdSmtpUser;
        smtpPassword = scdSmtpPassword;
        smtpSender = scdSmtpSender;
    }
    else
    {
        smtpUser = fstSmtpUser;
        smtpPassword = fstSmtpPassword;
        smtpSender = fstSmtpSender;
    }
}

void EMailSender::onTimeout()
{
    if (!messagesToSend.size())
    {
        return;
    }
    sendAMail(*messagesToSend.begin());
}

EMailSender::EMailSender(ESAAApp *app):QObject(app), theApp(app), sending(false)
{
    timer.setInterval(1000);
    timer.setSingleShot(false);
    connect(&timer, &QTimer::timeout, this, &EMailSender::onTimeout);
    timer.start();
}

void EMailSender::addMailToSend(SimpleMail::MimeMessage *message, bool hideWaitMessage)
{
    if (hideWaitMessage)
    {
        messagesWithHideSignal.insert(message);
    }
    messagesToSend.insert(message);
}
