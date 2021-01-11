#include "flyergenerator.h"
#include <QPdfWriter>
#include <QPageLayout>
#include <QPageSize>
#include "jw78utils.h"
#include <QPainter>

FlyerGenerator::FlyerGenerator()
{

}

QString FlyerGenerator::generateA6Flyer(const QString &facilityName, const QImage &logo, const QString qrCodeFilename, int number)
{
    QString a6Flyer(jw78::Utils::getTempPath() + "/a6flyer " + QString::number(number) + ".pdf");
    QPdfWriter pdf(a6Flyer);
    QPageLayout layout(pdf.pageLayout());
    layout.setOrientation(QPageLayout::Landscape);
    layout.setMode(QPageLayout::FullPageMode);
    QPageSize ps(QPageSize::A6);
    layout.setPageSize(ps);
    pdf.setPageLayout(layout);
    QPainter painter(&pdf);
    QRect r(painter.viewport());
    int pdfPixelWidth(r.width());
    int pdfPixelHeight(r.height());
    QImage background(QString(":/images/A6-So-funktioniert-es-") + QString::number(number) + ".png");
    painter.drawImage(QRect(0, 0, pdfPixelWidth, pdfPixelHeight), background);
    int pngPixelWidth(1653);
    int pngPixelHeight(1181);
    QRect logoRect(pdfPixelWidth * 67 / pngPixelWidth,
                   pdfPixelHeight * 67 / pngPixelHeight,
                   pdfPixelWidth * 290 / pngPixelWidth,
                   pdfPixelHeight * 290 / pngPixelHeight);
    painter.fillRect(logoRect, "white");

    QRect behindCaption(logoRect.right(),
                        logoRect.top(),
                        pdfPixelWidth - logoRect.right(),
                        logoRect.height() / 4);
    painter.fillRect(behindCaption, "white");

    painter.drawImage(logoRect, logo);
    QFont font = painter.font();
    font.setPixelSize(logoRect.height() / 4);
    painter.setFont(font);
    QPen pen = painter.pen();
    pen.setColor("black");
    painter.setPen(pen);
    QFontMetrics fontMetrics(painter.fontMetrics());
    QRect nameRect(fontMetrics.boundingRect(facilityName));
    painter.drawText(pdfPixelWidth * 366 / pngPixelWidth, logoRect.top() + nameRect.height() / 3 * 2, facilityName);

    QImage qr(qrCodeFilename);
    QRect qrCodeRect(pdfPixelWidth * 1026 / pngPixelWidth,
                     pdfPixelHeight * 530 / pngPixelHeight,
                     pdfPixelWidth * 540 / pngPixelWidth,
                     pdfPixelHeight * 540 / pngPixelHeight);

    painter.drawImage(qrCodeRect, qr);

    painter.end();
    return a6Flyer;
}

QString FlyerGenerator::generateA5Flyer(const QString &facilityName, const QImage &logo, const QString qrCodeFilename, int number)
{
    QString a5Flyer(jw78::Utils::getTempPath() + "/a5flyer " + QString::number(number) + ".pdf");
    QPdfWriter pdf(a5Flyer);
    QPageLayout layout(pdf.pageLayout());
    layout.setOrientation(QPageLayout::Landscape);
    layout.setMode(QPageLayout::FullPageMode);
    QPageSize ps(QPageSize::A5);
    layout.setPageSize(ps);
    pdf.setPageLayout(layout);
    QPainter painter(&pdf);
    QRect r(painter.viewport());
    int pdfPixelWidth(r.width());
    int pdfPixelHeight(r.height());
    QImage background(QString(":/images/A5-So-funktioniert-es-") + QString::number(number) + ".png");
    painter.drawImage(QRect(0, 0, pdfPixelWidth, pdfPixelHeight), background);
    int pngPixelWidth(2480);
    int pngPixelHeight(1653);
    QRect logoRect(pdfPixelWidth * 105 / pngPixelWidth,
                   pdfPixelHeight * 100 / pngPixelHeight,
                   pdfPixelWidth * 420 / pngPixelWidth,
                   pdfPixelHeight * 420 / pngPixelHeight);
    painter.fillRect(logoRect, "white");

    QRect behindCaption(logoRect.right(),
                        logoRect.top(),
                        pdfPixelWidth - logoRect.right(),
                        logoRect.height() / 4);
    painter.fillRect(behindCaption, "white");

    painter.drawImage(logoRect, logo);
    QFont font = painter.font();
    font.setPixelSize(logoRect.height() / 4);
    painter.setFont(font);
    QPen pen = painter.pen();
    pen.setColor("black");
    painter.setPen(pen);
    QFontMetrics fontMetrics(painter.fontMetrics());
    QRect nameRect(fontMetrics.boundingRect(facilityName));
    painter.drawText(pdfPixelWidth * 585 / pngPixelWidth, logoRect.top() + nameRect.height() / 3 * 2, facilityName);

    QImage qr(qrCodeFilename);
    QRect qrCodeRect(pdfPixelWidth * 1475 / pngPixelWidth,
                     pdfPixelHeight * 690 / pngPixelHeight,
                     pdfPixelWidth * 845 / pngPixelWidth,
                     pdfPixelHeight * 845 / pngPixelHeight);

    painter.drawImage(qrCodeRect, qr);

    painter.end();
    return a5Flyer;
}

QString FlyerGenerator::generateA4Flyer1(const QString &facilityName, const QImage &logo, const QString qrCodeFilename, int number)
{
    QString a4Flyer(jw78::Utils::getTempPath() + "/a4flyer" + QString::number(number) + ".pdf");
    QPdfWriter pdf(a4Flyer);
    QPageLayout layout(pdf.pageLayout());
    layout.setOrientation(QPageLayout::Portrait);
    layout.setMode(QPageLayout::FullPageMode);
    QPageSize ps(QPageSize::A4);
    layout.setPageSize(ps);
    pdf.setPageLayout(layout);
    QPainter painter(&pdf);
    QRect r(painter.viewport());
    int pdfPixelWidth(r.width());
    int pdfPixelHeight(r.height());
    QImage background(QString(":/images/A4-So-funktioniert-es-") + QString::number(number) + ".png");
    painter.drawImage(QRect(0, 0, pdfPixelWidth, pdfPixelHeight), background);
    int pngPixelWidth(2481);
    int pngPixelHeight(3508);

    QRect logoRect(pdfPixelWidth * 156 / pngPixelWidth,
                   pdfPixelHeight * 100 / pngPixelHeight,
                   pdfPixelWidth * 420 / pngPixelWidth,
                   pdfPixelHeight * 420 / pngPixelHeight);
    painter.fillRect(logoRect, "white");

    QRect behindCaption(logoRect.right(),
                        logoRect.top(),
                        pdfPixelWidth - logoRect.right(),
                        logoRect.height() / 4);
    painter.fillRect(behindCaption, "white");

    painter.drawImage(logoRect, logo);
    QFont font = painter.font();
    font.setPixelSize(logoRect.height() / 4);
    painter.setFont(font);
    QPen pen = painter.pen();
    pen.setColor("black");
    painter.setPen(pen);
    QFontMetrics fontMetrics(painter.fontMetrics());
    QRect nameRect(fontMetrics.boundingRect(facilityName));
    painter.drawText(pdfPixelWidth * 634 / pngPixelWidth, logoRect.top() + nameRect.height() / 3 * 2, facilityName);

    QImage qr(qrCodeFilename);
    QRect qrCodeRect(pdfPixelWidth * 1107 / pngPixelWidth,
                     pdfPixelHeight * 924 / pngPixelHeight,
                     pdfPixelWidth * 1122 / pngPixelWidth,
                     pdfPixelHeight * 1122 / pngPixelHeight);
    if (number == 3)
    {
        qrCodeRect = QRect(pdfPixelWidth * 684 / pngPixelWidth,
                           pdfPixelHeight * 1008 / pngPixelHeight,
                           pdfPixelWidth * 1122 / pngPixelWidth,
                           pdfPixelHeight * 1122 / pngPixelHeight);
    }
    painter.drawImage(qrCodeRect, qr);
    painter.end();
    return a4Flyer;
}

