#ifndef INTERNETTESTER_H
#define INTERNETTESTER_H

#include "JW78QTLib/jw78qtmacros.h"
#include <QTcpSocket>
#include <QTimer>

class InternetTester: public QObject
{
    Q_OBJECT
    JWPROPERTY(bool, internetConnected, InternetConnected, true);
    QTcpSocket tcpSocket;
    void connectToGoogle();
    QTimer timer;
private slots:
    void onTimerTimeout();
    void onConnected();
    void onConnectToGoogleError(QAbstractSocket::SocketError socketError);
public:
    InternetTester(QObject *parent);
};

#endif // INTERNETTESTER_H
