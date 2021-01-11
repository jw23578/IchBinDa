#ifndef IBDPERSON_H
#define IBDPERSON_H

#include "dataModel/jw78ProxyObject.h"

class IBDPerson: public jw78::ProxyObject
{
    Q_OBJECT
public:
    IBDPerson();
    JWPROPERTY(QString, fstname, Fstname, "")
    JWPROPERTY(QString, surname, Surname, "");
    JWPROPERTY(QString, street, Street, "");
    JWPROPERTY(QString, housenumber, Housenumber, "");
    JWPROPERTY(QString, zip, Zip, "");
    JWPROPERTY(QString, location, Location, "");
    JWPROPERTY(QString, emailAdress, EmailAdress, "");
};

#endif // IBDPERSON_H
