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
};

#endif // IBDPERSON_H
