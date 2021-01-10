#ifndef ENCRYPTER_H
#define ENCRYPTER_H

#ifdef DMOBILEDEVICE
#ifdef DMOBILEIOS
#include "botan_all_iosarmv7.h"
#else
#include "botan_all_arm32.h"
#endif
#else
#include "botan_all_x64.h"
#endif
#include "persistentmap.h"

class Encrypter
{
    PersistentMap publicKeyMap;
public:
    Encrypter();
    Botan::Public_Key *publicKey = nullptr;
    std::string publicKeyEncrypt(const std::string &plainText);
    void setPublicKey(int qrCodeNumber);
    bool keyNumberOK(int number);
};

#endif // ENCRYPTER_H
