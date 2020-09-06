#include "internettester.h"
#include <QDebug>

InternetTester::InternetTester(QObject *parent):QObject(parent),
    tcpSocket(this),
    timer(this)
{
    connect(&tcpSocket, &QTcpSocket::errorOccurred, this, &InternetTester::onConnectToGoogleError);
    connect(&tcpSocket, &QTcpSocket::connected, this, &InternetTester::onConnected);
    timer.setInterval(1000 * 5);
    timer.setSingleShot(false);
    connect(&timer, &QTimer::timeout, this, &InternetTester::onTimerTimeout);
    timer.start();
    connectToGoogle();
}


void InternetTester::connectToGoogle()
{
    connect(&tcpSocket, &QTcpSocket::errorOccurred, this, &InternetTester::onConnectToGoogleError);
    connect(&tcpSocket, &QTcpSocket::connected, this, &InternetTester::onConnected);
    tcpSocket.abort();
    tcpSocket.connectToHost("www.google.de", 80);
}

void InternetTester::onTimerTimeout()
{
    qDebug() << "timeout " << tcpSocket.state();
    connectToGoogle();
}

void InternetTester::onConnected()
{
    setInternetConnected(true);
    qDebug() << "connected";
    tcpSocket.disconnect();
    tcpSocket.abort();
    timer.setInterval(5 * 1000);
}

void InternetTester::onConnectToGoogleError(QAbstractSocket::SocketError socketError)
{
    setInternetConnected(false);
    tcpSocket.abort();
    qDebug() << "error " << socketError;
    timer.setInterval(1000);
}
