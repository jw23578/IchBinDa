#ifndef HELPOFFER_H
#define HELPOFFER_H

#include "dataModel/jw78ProxyObject.h"
#include "persistent/jw78persistentobject.h"
#include <QDateTime>

class HelpOffer: public jw78::ProxyObject, public jw78::PersistentObject
{
    Q_OBJECT
    JWPROPERTY(QString, description, Description, "");
    JWPROPERTY(QString, caption, Caption, "");    
    JWPROPERTY(QString, offererUuid, OffererUuid, "");
    JWPROPERTY(int, centerRadiusKM, CenterRadiusKM, 0);
    void addVariables();
protected:
    pureReflection *internalCreate(bool genUuid) const override;
public:
    QSet<QString> offerTypes;
    jw78::Coordinate center;
    bool transferred;
    HelpOffer();
    HelpOffer(bool genUuid);
    HelpOffer(const HelpOffer &other);
    Q_INVOKABLE void clearOfferTypes();
    Q_INVOKABLE void addOfferType(const QString &type);
    Q_INVOKABLE void setCenter(double latitude,
                               double longitude);
};

#endif // HELPOFFER_H
